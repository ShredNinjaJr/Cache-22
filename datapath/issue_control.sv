import lc3b_types::*;

module issue_control #(parameter data_width = 16, parameter tag_width = 3)
(
	input clk,
	// Fetch -> Issue Control
	input lc3b_word instr,
	input instr_is_new,
	// CDB -> Issue Control
	input CDB CDB_in,
	// Reservation Station -> Issue Control
	input alu_res1_busy, alu_res2_busy, alu_res3_busy, ld_buffer_full, st_buffer_full,
	// ROB -> Issue Control
	input rob_full,
	input lc3b_rob_addr rob_addr,
	// Regfile -> Issue Control
	input lc3b_word reg_value [7:0],
	input logic reg_busy [7:0],
	input lc3b_rob_addr reg_robs[7:0],
	// Issue Control -> Reservation Station
	output lc3b_opcode res_op_in,
	output logic [data_width-1:0] res_Vj, res_Vk,
	output logic [tag_width-1:0] res_Qj, res_Qk, res_dest,
	output logic issue_ld_busy_dest, issue_ld_Vj, issue_ld_Vk, issue_ld_Qk, issue_ld_Qj, issue_ld_validJ, issue_ld_validK,
	output logic [2:0] res_station_id,
	output logic  res_validJ, res_validK, // [valid J, valid K]
 	// Issue Control -> ROB
	output logic rob_write_enable,
	output logic [6:0] rob_inst,
	output logic [data_width-1:0] rob_value_in,
	// Issue Control -> Regfile
	output lc3b_reg reg_dest,
	output logic ld_reg_busy_dest,
	output lc3b_rob_addr reg_rob_entry
);

lc3b_word sext5_out;

lc3b_reg dest_reg;
lc3b_opcode opcode;
lc3b_reg sr1;
lc3b_reg sr2;

logic sr1_reg_busy;
logic sr2_reg_busy;
lc3b_word sr1_value;
lc3b_word sr2_value;
lc3b_rob_addr sr1_rob_e;
lc3b_rob_addr sr2_rob_e;

assign dest_reg = instr[11:9];
assign opcode = lc3b_opcode'(instr[15:12]);
assign sr1 = instr[8:6];
assign sr2 = instr[2:0];

assign sr1_reg_busy = reg_busy[sr1];
assign sr2_reg_busy = reg_busy[sr2];
assign sr1_value = reg_value[sr1];
assign sr2_value = reg_value[sr2];
assign sr1_rob_e = reg_robs[sr1];
assign sr2_rob_e = reg_robs[sr2];

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
				rob_inst = instr[15:9];
				
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