import lc3b_types::*;

module issue_control #(parameter data_width = 16, parameter tag_width = 3)
(
	input clk,
	// Fetch -> Issue Control
	input lc3b_word instr,
	input instr_is_new,
	input lc3b_word curr_pc,
	// CDB -> Issue Control
	input CDB CDB_in,
	// Reservation Station -> Issue Control
	input alu_res1_busy, alu_res2_busy, alu_res3_busy, ld_buffer_full, st_buffer_full,
	// ROB -> Issue Control
	input rob_full,
	input lc3b_rob_addr rob_addr,
	input lc3b_word rob_sr2_value_out,
	input lc3b_word rob_sr1_value_out,
	input logic rob_sr1_valid_out,
	input logic rob_sr2_valid_out,
	// Regfile -> Issue Control
	input regfile_t sr1_in, sr2_in, dest_in;

	// Issue Control -> Reservation Station
	output lc3b_opcode res_op_in,
	output logic [data_width-1:0] res_Vj, res_Vk,
	output logic [tag_width-1:0] res_Qj, res_Qk, res_dest,
	output logic issue_ld_busy_dest, issue_ld_Vj, issue_ld_Vk, issue_ld_Qk, issue_ld_Qj, issue_ld_validJ, issue_ld_validK,
	output logic [2:0] res_station_id,
	output logic  res_validJ, res_validK, // [valid J, valid K]
 	// Issue Control -> ROB
	output logic rob_write_enable,
	output lc3b_opcode rob_opcode, 
	output lc3b_reg rob_dest,
	output logic [data_width-1:0] rob_value_in,
	// Issue Control -> Regfile
	output lc3b_reg reg_dest, sr1, sr2,
	output logic ld_reg_busy_dest,
	output lc3b_rob_addr reg_rob_entry
	output [tag_width-1:0] rob_sr1_read_addr,
	output [tag_width-1:0] rob_sr2_read_addr,

);

lc3b_word sext5_out;

lc3b_reg dest_reg;
lc3b_opcode opcode;

logic sr1_reg_busy;
logic sr2_reg_busy;
lc3b_word sr1_value;
lc3b_word sr2_value;
lc3b_rob_addr sr1_rob_e;
lc3b_rob_addr sr2_rob_e;
lc3b_word sr1_rob_value;
lc3b_word sr2_rob_value;
logic sr1_rob_valid;
logic sr2_rob_valid;

assign dest_reg = instr[11:9];
assign opcode = lc3b_opcode'(instr[15:12]);
assign sr1 = instr[8:6];
assign sr2 = instr[2:0];

assign sr1_reg_busy = reg_busy[sr1];
assign sr2_reg_busy = reg_busy[sr2];
assign sr1_value = sr1_in.value;
assign sr2_value = sr2_in.value;
assign sr1_rob_e = sr1_in.rob_entry;
assign sr2_rob_e = sr2_in.rob_entry;
assign sr1_rob_value = rob_value_out;
assign sr2_rob_value = rob_value_out;
assign sr1_rob_valid = rob_valid_out;
assign sr2_rob_valid = rob_valid_out;

sext #(.width(5)) sext5
(
	.in(instr[4:0]),
	.out(sext5_out)
);

always_comb
begin
	res_op_in = op_br;
	res_Vj = 0;
	res_Vk = 0;
	res_Qj = 0;
	res_Qk = 0;
	res_dest = 0;
	res_validJ = 0;
	res_validK = 0;
	issue_ld_busy_dest = 0;
	issue_ld_Vj = 0;
	issue_ld_Vk = 0;
	issue_ld_Qj = 0;
	issue_ld_Qk = 0;
	issue_ld_validJ = 0;
	issue_ld_validK = 0;
	res_station_id = 0;
	res_dest = rob_addr;
	rob_write_enable = 0;
	rob_inst = 0;
	rob_value_in = 0;
	reg_dest = 0;
	ld_reg_busy_dest = 0;
	reg_rob_entry = 0;
	
	if (rob_full || (alu_res1_busy && alu_res2_busy && alu_res3_busy) || !instr_is_new)
	begin
		// STALL
	end
	else
	begin
		if (!alu_res1_busy)
			res_station_id = 3'b000;
		else if (!alu_res2_busy)
			res_station_id = 3'b001;
		else
			res_station_id = 3'b010;
			
		case(opcode)
			// ADD, AND, NOT
			op_add, op_and, op_not:
			begin
				/*		RESERVATION STATION OUTPUTS 	*/
				res_op_in = opcode;
				res_dest = rob_addr;
				issue_ld_busy_dest = 1'b1;
				/* J */
				if (sr1_reg_busy) // sr1_reg busy
				begin
					if (CDB_in.valid == 1'b1 && CDB_in.tag == sr1)	// CDB has value for J
					begin
						res_validJ = 1'b1;
						res_Vj = CDB_in.data;
						issue_ld_validJ = 1'b1;
						issue_ld_Vj = 1'b1;
					end
					else if (sr1_rob_valid) // ROB has value for J
					begin
						res_validJ = 1'b1;
						res_Vj = sr1_rob_value;
						issue_ld_validJ = 1'b1;
						issue_ld_Vj = 1'b1;
					end
					else
					begin
						res_validJ = 1'b0;
						res_Qj = sr1_rob_e;
						issue_ld_validJ = 1'b1;
						issue_ld_Qj = 1'b1;
					end
				end
				else	// sr1_reg not busy
				begin
					res_validJ = 1'b1;
					res_Vj = sr1_value;
					issue_ld_validJ = 1'b1;
					issue_ld_Vj = 1'b1;
				end
				/* K */
				if (instr[5])	// Immediate
				begin
					res_validK = 1'b1;
					res_Vk = sext5_out;
					issue_ld_validK = 1'b1;
					issue_ld_Vk = 1'b1;
				end
				else	// Not immediate
				begin
					if (sr2_reg_busy) // sr2_reg_busy
					begin
						if (CDB_in.valid == 1'b1 && CDB_in.tag == sr2)	// CDB has value for K
						begin
							res_validK = 1'b1;
							res_Vk = CDB_in.data;
							issue_ld_validK = 1'b1;
							issue_ld_Vk = 1'b1;
						end
						else if (sr2_rob_valid) // ROB has value for J
						begin
							res_validK = 1'b1;
							res_Vk = sr2_rob_value;
							issue_ld_validK = 1'b1;
							issue_ld_Vk = 1'b1;
						end
						else
						begin
							res_validK = 1'b0;
							res_Qk = sr2_rob_e;
							issue_ld_validK = 1'b1;
							issue_ld_Qk = 1'b1;
						end
					end	// sr2_reg not busy
					else
					begin
						res_validK = 1'b1;
						res_Vk = sr2_value;
						issue_ld_validK = 1'b1;
						issue_ld_Vk = 1'b1;
					end
				end
				
				/* ROB OUTPUTS */
				rob_write_enable = 1'b1;
				rob_opcode = opcode ;
				rob_dest = dest_reg;
				
				/* REGFILE OUTPUTS */
				reg_dest = dest_reg;
				ld_reg_busy_dest = 1'b1;
				reg_rob_entry = rob_addr;
			end
			default:;
		endcase
	end
end



endmodule: issue_control
