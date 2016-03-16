import lc3b_types::*;

module issue_control_testbench;

timeunit 1ns; 
timeprecision 1ns;

	logic clk = 0;
	// Fetch -> Issue Control
	lc3b_word instr;
	logic instr_is_new;
	// CDB -> Issue Control
	CDB CDB_in;
	// Reservation Station -> Issue Control
	logic alu_res1_busy, alu_res2_busy, alu_res3_busy, ld_buffer_full, st_buffer_full;
	// ROB -> Issue Control
	logic rob_full;
	lc3b_rob_addr rob_addr;
	// Regfile -> Issue Control
	lc3b_word reg_value [7:0];
	logic reg_busy [7:0];
	lc3b_rob_addr reg_robs [7:0];
	// Issue Control -> Reservation Station
	lc3b_opcode res_op_in;
	logic [15:0] res_Vj, res_Vk;
	logic [2:0] res_Qj, res_Qk, res_dest;
	logic issue_ld_busy_dest, issue_ld_Vj, issue_ld_Vk, issue_ld_Qk, issue_ld_Qj, issue_ld_validJ, issue_ld_validK;
	logic [2:0] res_station_id;
	logic  res_validJ, res_validK; // [valid J, valid K]
 	// Issue Control -> ROB
	logic rob_write_enable;
	logic [6:0] rob_inst;
	logic [15:0] rob_value_in;
	// Issue Control -> Regfile
	lc3b_reg reg_dest;
	logic ld_reg_busy_dest;
	lc3b_rob_addr reg_rob_entry;


issue_control I_C(
	.clk(clk),
	.instr(instr),
	.instr_is_new(instr_is_new),
	.CDB_in(CDB_in),
	.alu_res1_busy(alu_res1_busy),
	.alu_res2_busy(alu_res2_busy),
	.alu_res3_busy(alu_res3_busy),
	.ld_buffer_full(ld_buffer_full),
	.st_buffer_full(st_buffer_full),
	.rob_full(rob_full),
	.rob_addr(rob_addr),
	.reg_value(reg_value),
	.reg_busy(reg_busy),
	.reg_robs(reg_robs),
	.res_op_in(res_op_in),
	.res_Vj(res_Vj),
	.res_Vk(res_Vk),
	.res_Qj(res_Qj),
	.res_Qk(res_Qk),
	.res_dest(res_dest),
	.res_validJ(res_validJ),
	.res_validK(res_validK),
	.issue_ld_busy_dest(issue_ld_busy_dest),
	.issue_ld_Vj(issue_ld_Vj),
	.issue_ld_Vk(issue_ld_Vk),
	.issue_ld_Qj(issue_ld_Qj),
	.issue_ld_Qk(issue_ld_Qk),
	.issue_ld_validJ(issue_ld_validJ),
	.issue_ld_validK(issue_ld_validK),
	.res_station_id(res_station_id),
	.rob_write_enable(rob_write_enable),
	.rob_inst(rob_inst),
	.rob_value_in(rob_value_in),
	.reg_dest(reg_dest),
	.ld_reg_busy_dest(ld_reg_busy_dest),
	.reg_rob_entry(reg_rob_entry)
);

always #1 clk = ~clk;

initial begin: CLOCK_INITIALIZATION
	clk = 0;
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

reg_value[0] = 0;
reg_value[1] = 4;
reg_value[2] = 19;
reg_busy[0] = 0;
reg_busy[1] = 0;
reg_busy[2] = 0;
reg_robs[0] = 0;

#1 
instr = 16'b1001000010111111; // R0 
instr_is_new = 1;






end

endmodule : issue_control_testbench
