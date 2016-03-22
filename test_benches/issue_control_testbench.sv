import lc3b_types::*;

module issue_control_testbench;

timeunit 1ns; 
timeprecision 1ns;

	logic clk = 0;
	// Fetch -> Issue Control
	lc3b_word instr;
	logic instr_is_new;
	lc3b_word curr_pc;
	// CDB -> Issue Control
	CDB CDB_in;
	// Reservation Station -> Issue Control
	logic alu_res1_busy, alu_res2_busy, alu_res3_busy, ld_buffer_full, st_buffer_full;
	// ROB -> Issue Control
	logic rob_full;
	lc3b_rob_addr rob_addr;
	lc3b_word rob_sr1_value_out;
	lc3b_word rob_sr2_value_out;
	logic rob_sr1_valid_out;
	logic rob_sr2_valid_out;
	// Regfile -> Issue Control
	regfile_t sr1_in;
	regfile_t sr2_in;
	regfile_t dest_in;

	logic stall;
	// Issue Control -> Reservation Station
	lc3b_opcode res_op_in;
	logic [15:0] res_Vj, res_Vk;
	logic [2:0] res_Qj, res_Qk;
	lc3b_rob_addr res_dest;
	logic issue_ld_busy_dest, issue_ld_Vj, issue_ld_Vk, issue_ld_Qk, issue_ld_Qj;
	logic [2:0] res_station_id;
	// Issue Control -> Load Buffer
	logic load_buf_write_enable;
	lc3b_word load_buf_offset;
 	// Issue Control -> ROB
	logic rob_write_enable;
	lc3b_opcode rob_opcode;
	lc3b_reg rob_dest;
	logic [15:0] rob_value_in;
	// Issue Control -> Regfile
	lc3b_reg reg_dest, sr1, sr2;
	logic ld_reg_busy_dest;
	lc3b_rob_addr reg_rob_entry;
	logic [3] rob_sr1_read_addr;
	logic [3[ rob_sr2_read_addr;
	


issue_control I_C(
	.clk(clk),
	.instr(instr),
	.instr_is_new(instr_is_new),
	.curr_pc(curr_pc),
	.CDB_in(CDB_in),
	.alu_res1_busy(alu_res1_busy),
	.alu_res2_busy(alu_res2_busy),
	.alu_res3_busy(alu_res3_busy),
	.ld_buffer_full(ld_buffer_full),
	.st_buffer_full(st_buffer_full),
	.rob_full(rob_full),
	.rob_addr(rob_addr),
	.rob_sr1_value_out(rob_sr1_value_out);
	.rob_sr2_value_out(rob_sr2_value_out);
	.sr1_in(sr1_in);
	.sr2_in(sr2_in);
	.dest_in(dest_in);
	.stall(stall);
	.res_op_in(res_op_in),
	.res_Vj(res_Vj),
	.res_Vk(res_Vk),
	.res_Qj(res_Qj),
	.res_Qk(res_Qk),
	.res_dest(res_dest),
	.issue_ld_busy_dest(issue_ld_busy_dest),
	.issue_ld_Vj(issue_ld_Vj),
	.issue_ld_Vk(issue_ld_Vk),
	.issue_ld_Qj(issue_ld_Qj),
	.issue_ld_Qk(issue_ld_Qk),
	.res_station_id(res_station_id),
	.load_buf_write_enable(load_buf_write_enable),
	.load_buf_offset(load_buf_offset),
	.rob_write_enable(rob_write_enable),
	.rob_opcode(rob_opcode),
	.reg_dest(reg_dest),
	.rob_value_in(rob_value_in),
	.reg_dest(reg_dest),
	.sr1(sr1),
	.sr2(sr2),
	.ld_reg_busy_dest(ld_reg_busy_dest),
	.reg_rob_entry(reg_rob_entry),
	.rob_sr1_read_addr(rob_sr1_read_addr),
	.rob_sr2_read_addr(rob_sr2_read_addr)
);

always #1 clk = ~clk;

initial begin: CLOCK_INITIALIZATION
	clk = 1;
end

initial begin: TEST_VECTORS

instr = 16'b0001000001000010; // R0 <- R1 + R2
instr_is_new = 1;

CDB_in.valid = 0;
CDB_in.tag = 0;
CDB_in.data = 0;

alu_res1_busy = 1;
alu_res2_busy = 0;
alu_res3_busy = 0;
ld_buffer_full = 0;
st_buffer_full = 0;

rob_full = 0;
rob_addr = 1;


end

endmodule : issue_control_testbench
