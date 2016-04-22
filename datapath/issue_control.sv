	import lc3b_types::*;

module issue_control #(parameter data_width = 16, parameter tag_width = 3)
(
	input clk, flush,
	// Fetch -> Issue Control
	input lc3b_word instr,
	input instr_is_new,
	input lc3b_word curr_pc,
	input lc3b_word instruction_pc,
	// CDB -> Issue Control
	input CDB CDB_in,
	// Reservation Station -> Issue Control
	input alu_res1_busy, alu_res2_busy, alu_res3_busy, ldstr_full,
	// ROB -> Issue Control
	input rob_full,
	input lc3b_rob_addr rob_addr,
	input lc3b_word rob_sr2_value_out,
	input lc3b_word rob_sr1_value_out,
	input logic rob_sr1_valid_out,
	input logic rob_sr2_valid_out,
	// Regfile -> Issue Control
	input regfile_t sr1_in, sr2_in, dest_in,
	// Prediction Unit -> Issue Control
	input predict_bit,

	// Issue Control -> Fetch Unit
	output logic stall,
	output logic pcmux_sel,
	output lc3b_word br_pc,
	// Issue Control -> Reservation Station
	output lc3b_opcode res_op_in,
	output logic [data_width-1:0] res_Vj, res_Vk,
	output logic [tag_width-1:0] res_Qj, res_Qk, 
	output lc3b_rob_addr res_dest,
	output logic issue_ld_busy_dest, issue_ld_Vj, issue_ld_Vk, issue_ld_Qk, issue_ld_Qj,
	output logic [2:0] res_station_id,
	// Issue Control -> Load Buffer NOTE and res_dest are all used for load buffer as well
	output logic ldstr_write_enable,
	output lc3b_word ldstr_offset,
	output logic [tag_width-1:0] ldstr_Qsrc, ldstr_Qbase, ldstr_dest,
	output logic ldstr_Vsrc_valid_in, ldstr_Vbase_valid_in,
	output lc3b_word ldstr_Vsrc, ldstr_Vbase, 
 	// Issue Control -> ROB
	output logic rob_write_enable,
	output lc3b_opcode rob_opcode, 
	output lc3b_reg rob_dest,
	output logic [data_width-1:0] rob_value_in,
	output lc3b_word rob_pc_addr,
	// Issue Control -> Regfile
	output lc3b_reg reg_dest, sr1, sr2,
	output logic ld_reg_busy_dest,
	output lc3b_rob_addr reg_rob_entry,
	output [tag_width-1:0] rob_sr1_read_addr,
	output [tag_width-1:0] rob_sr2_read_addr,
	output logic bit5,
	output lc3b_word trap_reg		// Holds the value of PC so that ROB can hold the jump address

);

assign bit5 = instr[5];

lc3b_word sext5_out;
lc3b_word sext6_out;
lc3b_word adj6_out;
lc3b_word adj9_out;
lc3b_word adj11_out;

lc3b_reg dest_reg;
lc3b_opcode opcode;

logic sr1_reg_busy;
logic sr2_reg_busy;
logic dest_reg_busy;
lc3b_word sr1_value;
lc3b_word sr2_value;
lc3b_word dest_value;
lc3b_rob_addr sr1_rob_e;
lc3b_rob_addr sr2_rob_e;
lc3b_rob_addr dest_rob_e;
lc3b_word sr1_rob_value;
lc3b_word sr2_rob_value;
logic sr1_rob_valid;
logic sr2_rob_valid;
logic branch_stall_in;

logic firstIssueLDI;
lc3b_rob_addr ldi_rob_e;
logic firstIssueSTI;
lc3b_rob_addr sti_rob_e;

assign dest_reg = instr[11:9];
assign opcode = lc3b_opcode'(instr[15:12]);

assign sr1 = instr[8:6];
assign sr2 = instr[2:0];

always_comb
begin:offset_logic
	case(opcode)
		op_stb, op_ldb: ldstr_offset = sext6_out;
		op_ldr, op_str, op_ldi, op_sti, op_str: 
			begin
				if(firstIssueLDI == 1'b1 || firstIssueSTI == 1'b1)
					ldstr_offset = 0;
				else
					ldstr_offset = adj6_out;
			end
		op_trap: ldstr_offset = 0;
		default: ldstr_offset = 16'hXXXX;
	endcase
end

assign sr1_reg_busy = sr1_in.busy;
assign sr2_reg_busy = sr2_in.busy;
assign dest_reg_busy = dest_in.busy;
assign sr1_value = sr1_in.data;
assign sr2_value = sr2_in.data;
assign dest_value = dest_in.data;
assign sr1_rob_e = sr1_in.rob_entry;
assign sr2_rob_e = sr2_in.rob_entry;
assign dest_rob_e = dest_in.rob_entry;
assign sr1_rob_value = rob_sr1_value_out;
assign sr2_rob_value = rob_sr2_value_out;
assign sr1_rob_valid = rob_sr1_valid_out;
assign sr2_rob_valid = rob_sr2_valid_out;

assign rob_sr1_read_addr = sr1_in.rob_entry;
assign rob_sr2_read_addr = (opcode == op_sti || opcode == op_str || opcode == op_stb) ? dest_in.rob_entry : sr2_in.rob_entry;

logic branch_stall;
initial branch_stall = 0;
always_ff @( posedge clk)
begin
	case(opcode)
	op_br: begin
		if(predict_bit & ~branch_stall & instr_is_new)
			branch_stall <= 1'b1;
		else
			branch_stall <= 0;
	end
	op_jsr, op_jmp: begin
		branch_stall <= branch_stall_in;
	end
	default: branch_stall <= 0;
				
	endcase
end


initial 
begin
	firstIssueLDI = 0;
	ldi_rob_e = 0;
end
always_ff @( posedge clk)
begin
	case(opcode)
	op_ldi: begin
		if((firstIssueLDI == 0) & rob_write_enable)
		begin
			firstIssueLDI <= 1;
			ldi_rob_e <= rob_addr;
		end
		else if (rob_write_enable)
		begin
			firstIssueLDI <= 0;
			ldi_rob_e <= 0;
		end
	end
	default: 
	begin
		firstIssueLDI <= 0;
		ldi_rob_e <= 0;
	end
	endcase
end


initial 
begin
	firstIssueSTI = 0;
	sti_rob_e = 0;
end
always_ff @( posedge clk)
begin
	case(opcode)
	op_sti: begin
		if((firstIssueSTI == 0) & rob_write_enable)
		begin
			firstIssueSTI <= 1;
			sti_rob_e <= rob_addr;
		end
		else if(firstIssueSTI == 1 && stall == 1'b0)
		begin
			firstIssueSTI <= 0;
			sti_rob_e <= 0;
		end
	end
	default: 
	begin
		firstIssueSTI <= 0;
		sti_rob_e <= 0;
	end
	endcase
end

initial trap_reg = 0;
always_ff @ (posedge clk)
begin
	if (flush)
		trap_reg <= 0;
	else if((opcode == op_trap) & (trap_reg == 0) & rob_write_enable)
		trap_reg <= curr_pc;
end

sext #(.width(5)) sext5
(
	.in(instr[4:0]),
	.out(sext5_out)
);

sext #(.width(6)) sext6
(
	.in(instr[5:0]),
	.out(sext6_out)
);

adj #(.width(6)) adj6
(
	.in(instr[5:0]),
	.out(adj6_out)
);

adj #(.width(9)) adj9
(
	.in(instr[8:0]),
	.out(adj9_out)
);

adj #(.width(11)) adj11
(
	.in(instr[10:0]),
	.out(adj11_out)
);


always_comb
begin
	stall = 0;
	rob_dest = 0;
	res_op_in = op_br;
	res_Vj = 0;
	res_Vk = 0;
	res_Qj = 0;
	res_Qk = 0;
	ldstr_write_enable = 0;
	issue_ld_busy_dest = 0;
	issue_ld_Vj = 0;
	issue_ld_Vk = 0;
	issue_ld_Qj = 0;
	issue_ld_Qk = 0;
	res_station_id = 0;
	branch_stall_in = 0;
	
	ldstr_Qsrc = 0;
	ldstr_Qbase = 0;
	ldstr_dest = rob_addr;
	ldstr_Vsrc_valid_in = 0;
	ldstr_Vbase_valid_in = 0;
	ldstr_Vsrc = 0;
	ldstr_Vbase = 0;
	
	res_dest = rob_addr;
	rob_write_enable = 0;
	rob_value_in = 0;
	reg_dest = 0;
	ld_reg_busy_dest = 0;
	reg_rob_entry = 0;
	pcmux_sel = 0;
	br_pc = 0;
	rob_pc_addr = instruction_pc;
	rob_opcode = opcode;
	
	if (rob_full || 
	(alu_res1_busy && alu_res2_busy && alu_res3_busy && (opcode == op_add || opcode == op_and || opcode == op_not || opcode == op_shf)) ||
	(ldstr_full && (opcode == op_trap || opcode == op_ldr || opcode == op_str || opcode === op_ldi || opcode == op_sti 	|| opcode == op_stb || opcode == op_ldb)) || branch_stall || 
	!instr_is_new)
	begin
		// STALL
		if(rob_full ||
			(alu_res1_busy && alu_res2_busy && alu_res3_busy && (opcode == op_add || opcode == op_and || opcode == op_not || opcode == op_shf)) ||
			(ldstr_full && (opcode == op_trap || opcode == op_ldr || opcode == op_str || opcode === op_ldi || opcode === op_sti || opcode == op_stb || opcode == op_ldb)) || 
			(instr_is_new & ~branch_stall))
			stall = 1'b1;
	end
	else
	begin	
		case(opcode)
			// ADD, AND, NOT, SHF
			op_add, op_and, op_not, op_shf:
			begin
				if (!alu_res1_busy)
					res_station_id = 3'b000;
				else if (!alu_res2_busy)
					res_station_id = 3'b001;
				else
					res_station_id = 3'b010;
				/*		RESERVATION STATION OUTPUTS 	*/
				res_op_in = opcode;
				issue_ld_busy_dest = 1'b1;
				/* J */
				if (sr1_reg_busy) // sr1_reg busy
				begin
					if (CDB_in.valid == 1'b1 && CDB_in.tag == sr1_rob_e)	// CDB has value for J
					begin
						res_Vj = CDB_in.data;
						issue_ld_Vj = 1'b1;
					end
					else if (sr1_rob_valid) // ROB has value for J
					begin
						res_Vj = sr1_rob_value;
						issue_ld_Vj = 1'b1;
					end
					else
					begin
						res_Qj = sr1_rob_e;
						issue_ld_Qj = 1'b1;
					end
				end
				else	// sr1_reg not busy
				begin
					res_Vj = sr1_value;
					issue_ld_Vj = 1'b1;
				end
				/* K */
				if (instr[5] || ( opcode == op_shf))	// Immediate
				begin
					res_Vk = sext5_out;
					issue_ld_Vk = 1'b1;
				end
				else	// Not immediate
				begin
					if (sr2_reg_busy) // sr2_reg_busy
					begin
						if (CDB_in.valid == 1'b1 && CDB_in.tag == sr2_rob_e)	// CDB has value for K
						begin
							res_Vk = CDB_in.data;
							issue_ld_Vk = 1'b1;
						end
						else if (sr2_rob_valid) // ROB has value for J
						begin
							res_Vk = sr2_rob_value;
							issue_ld_Vk = 1'b1;
						end
						else
						begin
							res_Qk = sr2_rob_e;
							issue_ld_Qk = 1'b1;
						end
					end	// sr2_reg not busy
					else
					begin
						res_Vk = sr2_value;
						issue_ld_Vk = 1'b1;
					end
				end
				
				/* ROB OUTPUTS */
				rob_write_enable = 1'b1;
				rob_dest = dest_reg;
				
				/* REGFILE OUTPUTS */
				reg_dest = dest_reg;
				ld_reg_busy_dest = 1'b1;
				reg_rob_entry = rob_addr;
			end
			
			
			// LDR, LDB
			op_ldr, op_ldb:
			begin
				/* LOAD BUFFER OUTPUTS */
				ldstr_write_enable = 1'b1;
				res_op_in = opcode;
				if (sr1_reg_busy)	// Base not ready
				begin
					if (CDB_in.valid == 1'b1 && CDB_in.tag == sr1_rob_e)	// CDB has value for Base
					begin
						ldstr_Vbase = CDB_in.data;
						ldstr_Vbase_valid_in = 1'b1;
					end
					else if (sr1_rob_valid) // ROB has value for Base
					begin
						ldstr_Vbase = sr1_rob_value;
						ldstr_Vbase_valid_in = 1'b1;
					end
					else		// Wait for Base value
						ldstr_Qbase = sr1_rob_e;
				end
				else	// Base is ready
				begin
					ldstr_Vbase = sr1_value;
					ldstr_Vbase_valid_in = 1'b1;
				end
				
				
				/* ROB OUTPUTS */
				rob_write_enable = 1'b1;
				rob_dest = dest_reg;
				
				/* REGFILE OUTPUTS */
				reg_dest = dest_reg;
				ld_reg_busy_dest = 1'b1;
				reg_rob_entry = rob_addr;
				
			end
			
			// STR, STB
			op_str, op_stb:
			begin
				ldstr_write_enable = 1'b1;
				res_op_in = opcode;
				ldstr_dest = 0;
				if (sr1_reg_busy)	// Base not ready
				begin
					if (CDB_in.valid == 1'b1 && CDB_in.tag == sr1_rob_e)	// CDB has value for Base
					begin
						ldstr_Vbase = CDB_in.data;
						ldstr_Vbase_valid_in = 1'b1;
					end
					else if (sr1_rob_valid) // ROB has value for Base
					begin
						ldstr_Vbase = sr1_rob_value;
						ldstr_Vbase_valid_in = 1'b1;
					end
					else		// Wait for Base value
						ldstr_Qbase = sr1_rob_e;
				end
				else	// Base is ready
				begin
					ldstr_Vbase = sr1_value;
					ldstr_Vbase_valid_in = 1'b1;
				end
				
				if (dest_reg_busy)	// Source is busy
				begin
					if (CDB_in.valid == 1'b1 && CDB_in.tag == dest_rob_e)	// CDB has value for Source
					begin
						ldstr_Vsrc = CDB_in.data;
						ldstr_Vsrc_valid_in = 1'b1;
					end
					else if (sr2_rob_valid) // ROB has value for Source
					begin
						ldstr_Vsrc = sr2_rob_value;
						ldstr_Vsrc_valid_in = 1'b1;
					end
					else		// Wait for Source value
						ldstr_Qsrc = dest_rob_e;
				end
				else	// Source is ready
				begin
					ldstr_Vsrc = dest_value;
					ldstr_Vsrc_valid_in = 1'b1;
				end
				
				/* ROB OUTPUTS */
				rob_write_enable = 1'b1;
				rob_dest = 0;
				
				/* REGFILE OUTPUT */
				reg_dest = dest_reg;
				
			end
			
			
			// BR
			op_br:
			begin
				rob_write_enable = 1'b1;
				rob_dest = dest_reg;
				br_pc = curr_pc + adj9_out;
				if (predict_bit)
				begin
					rob_value_in = curr_pc;
					pcmux_sel = 1'b1;
				end
				else
				begin
					rob_value_in = br_pc;
				end

			end
			
			// LEA Only uses ROB
			op_lea:
			begin
				rob_write_enable = 1'b1;
				rob_value_in = curr_pc + adj9_out;
				rob_dest = dest_reg;
				ld_reg_busy_dest = 1'b1;
				reg_rob_entry = rob_addr;
				reg_dest = dest_reg;
			end
			
			// JMP Will stall until register is ready
			op_jmp:
			begin
				branch_stall_in = 1;
				pcmux_sel = 1'b1;
				if (sr1_reg_busy)	// Base not ready
				begin
					if (CDB_in.valid == 1'b1 && CDB_in.tag == sr1_rob_e)	// CDB has value for Base
					begin
						br_pc = CDB_in.data;
					end
					else if (sr1_rob_valid) // ROB has value for Base
					begin
						br_pc = sr1_rob_value;
					end
					else		// Wait for Base value
					begin
						stall = 1'b1;
						branch_stall_in = 0;
					end
				end
				else
				begin
					br_pc = sr1_value;
				end
			end
			
			/* Similar to Jmp, but writes PC into R7 through ROB */
			op_jsr:
			begin
				branch_stall_in = 1;
				rob_write_enable = 1'b1;
				rob_value_in = curr_pc;
				rob_dest = 3'b111;
				ld_reg_busy_dest = 1'b1;
				reg_rob_entry = rob_addr;
				reg_dest = 3'b111;
				pcmux_sel = 1'b1;

				if(instr[11]) //JSR
				begin
					br_pc = curr_pc + adj11_out;
				end
				else 	//JSRR
				begin
					if (sr1_reg_busy)	// Base not ready
					begin
						if (CDB_in.valid == 1'b1 && CDB_in.tag == sr1_rob_e)	// CDB has value for Base
						begin
							br_pc = CDB_in.data;
						end
						else if (sr1_rob_valid) // ROB has value for Base
						begin
							br_pc = sr1_rob_value;
						end
						else		// Wait for Base value
						begin
							stall = 1'b1;
							rob_write_enable = 1'b0;
							branch_stall_in = 0;
						end
					end
					else
					begin
						br_pc = sr1_value;
					end
				end
			end
			
			op_trap: begin
				
				/* LOAD BUFFER OUTPUTS */
				ldstr_write_enable = 1'b1;
				res_op_in = op_ldr;
				
				ldstr_Vbase = {7'b0,instr[7:0], 1'b0};
				ldstr_Vbase_valid_in = 1'b1;
				
				
				/* ROB OUTPUTS */
				rob_write_enable = 1'b1;
				rob_value_in = curr_pc;
				rob_dest = 3'b111;
				ld_reg_busy_dest = 1'b1;
				reg_rob_entry = rob_addr;
				reg_dest = 3'b111;
			end
			
			
			// LDI
			op_ldi:
			begin
				if (firstIssueLDI == 1'b0)
					begin
					/* First Issue */
					ldstr_write_enable = 1'b1;
					res_op_in = op_ldr;
					if (sr1_reg_busy)	// Base not ready
					begin
						if (CDB_in.valid == 1'b1 && CDB_in.tag == sr1_rob_e)	// CDB has value for Base
						begin
							ldstr_Vbase = CDB_in.data;
							ldstr_Vbase_valid_in = 1'b1;
						end
						else if (sr1_rob_valid) // ROB has value for Base
						begin
							ldstr_Vbase = sr1_rob_value;
							ldstr_Vbase_valid_in = 1'b1;
						end
						else		// Wait for Base value
							ldstr_Qbase = sr1_rob_e;
					end
					else	// Base is ready
					begin
						ldstr_Vbase = sr1_value;
						ldstr_Vbase_valid_in = 1'b1;
					end
			
					/* ROB OUTPUTS */
					rob_write_enable = 1'b1;
					rob_dest = dest_reg;
					
					stall = 1'b1;
				end
				else 
				begin
				
					/* Second Issue */
					ldstr_write_enable = 1'b1;
					res_op_in = op_ldr;
					
					if (CDB_in.valid == 1'b1 && CDB_in.tag == ldi_rob_e)	// CDB has value for Base
					begin
						ldstr_Vbase = CDB_in.data;
						ldstr_Vbase_valid_in = 1'b1;
					end
			//		else if (sr1_rob_valid) // We don't need to check register file
			//			begin
			//			ldstr_Vbase = sr1_rob_value;
			//			ldstr_Vbase_valid_in = 1'b1;
			//		end
					else		// Wait for Base value
						ldstr_Qbase = ldi_rob_e;
					
					/* ROB OUTPUTS */
					rob_write_enable = 1'b1;
					rob_dest = dest_reg;
					
					/* REGFILE OUTPUTS */
					reg_dest = dest_reg;
					ld_reg_busy_dest = 1'b1;
					reg_rob_entry = rob_addr;
					
				end
			end
			
			// STI
			op_sti:
			begin
				if (firstIssueSTI == 1'b0)
					begin
						/* First Issue */
						ldstr_write_enable = 1'b1;
						res_op_in = op_ldr;
						if (sr1_reg_busy)	// Base not ready
						begin
							if (CDB_in.valid == 1'b1 && CDB_in.tag == sr1_rob_e)	// CDB has value for Base
							begin
								ldstr_Vbase = CDB_in.data;
								ldstr_Vbase_valid_in = 1'b1;
							end
							else if (sr1_rob_valid) // ROB has value for Base
							begin
								ldstr_Vbase = sr1_rob_value;
								ldstr_Vbase_valid_in = 1'b1;
							end
							else		// Wait for Base value
								ldstr_Qbase = sr1_rob_e;
							end
						else	// Base is ready
						begin
							ldstr_Vbase = sr1_value;
							ldstr_Vbase_valid_in = 1'b1;
						end
				
						/* ROB OUTPUTS */
						rob_write_enable = 1'b1;
						rob_dest = dest_reg;
						
						stall = 1'b1;
				end
				else 
				begin
				
					/* Second Issue */
					ldstr_write_enable = 1'b1;
					res_op_in = op_str;
					ldstr_dest = 0;
					rob_opcode = op_str;
					
					/* Setting Base Registers in ldstr buffer */
					if (CDB_in.valid == 1'b1 && CDB_in.tag == sti_rob_e)	// CDB has value for Base
						begin
							ldstr_Vbase = CDB_in.data;
							ldstr_Vbase_valid_in = 1'b1;
						end
						//else if (sr1_rob_valid) // ROB has value for Base
						//begin
							//ldstr_Vbase = sr1_rob_value;
							//ldstr_Vbase_valid_in = 1'b1;
						//end
						else		// Wait for Base value
							ldstr_Qbase = sti_rob_e;
					
					/* Setting Source Registers in ldstr buffer */
					if (dest_reg_busy)	// Source is busy
					begin
						if (CDB_in.valid == 1'b1 && CDB_in.tag == dest_rob_e)	// CDB has value for Source
						begin
							ldstr_Vsrc = CDB_in.data;
							ldstr_Vsrc_valid_in = 1'b1;
						end
						else if (sr2_rob_valid) // ROB has value for Source
						begin
							ldstr_Vsrc = sr2_rob_value;
							ldstr_Vsrc_valid_in = 1'b1;
						end
						else		// Wait for Source value
							ldstr_Qsrc = dest_rob_e;
					end
					else	// Source is ready
					begin
						ldstr_Vsrc = dest_value;
						ldstr_Vsrc_valid_in = 1'b1;
					end
					
					/* ROB OUTPUTS */
					rob_write_enable = 1'b1;
					rob_dest = 0;
					
					/* REGFILE OUTPUT */
					reg_dest = dest_reg;
					
				end
			end
			
			
			default:;
		endcase
	end
end



endmodule: issue_control
