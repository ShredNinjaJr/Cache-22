import lc3b_types::*;

module alu_res_testbench;

timeunit 1ns; 
timeprecision 1ns;

logic clk;
logic flush;

logic busy_in, ld_busy, issue_ld_Vj, issue_ld_Vk, issue_ld_Qk, issue_ld_Qj;

logic [15:0] Vj, Vk;
logic [2:0] Qj, Qk, dest;

logic busy_out;

CDB CDB_in, CDB_out;
lc3b_word instr;
lc3b_opcode op_in;


alu_res_station rs ( .*);

always #1 clk = ~clk;

initial begin: CLOCK_INITIALIZATION
	clk = 1;
end

initial begin: TEST_VECTORS

#2 flush = 1;

#4 flush = 0;
CDB_in = 0;

#1 
/* Simple add test */
busy_in = 1;
op_in = op_add;
Vj = 16'h15;
Vk = 16'h42;

#1
ld_busy = 1;
issue_ld_Vj = 1;
issue_ld_Vk = 1;

#2

ld_busy = 0;
issue_ld_Vj = 0;
issue_ld_Vk = 0;
$display("Alu add test out = %x; Expected out = %x", CDB_out.data, (Vj+Vk));

#2
flush = 1;

/* Add with waiting on 1 register */
#1
flush = 0;
busy_in = 1;
op_in = op_add;
Vj = 16'h32;
Qk = 3'h3;

#1 
ld_busy = 1;
issue_ld_Vj = 1;
issue_ld_Qk = 1;
#1
CDB_in.data = 16'hFFF4;
CDB_in.valid = 1;
CDB_in.tag = 3'h3;
#1
ld_busy = 0;
issue_ld_Vj = 0;
issue_ld_Qk = 0;
#2

$display("Alu add test out = %x; Expected out = %x", CDB_out.data, (Vj - 12));

/* ADD Test with wrong both registers waiting; CDB outputs wrong tags */
#2
flush = 1;

#1
flush = 0;
Qk = 3'h2;
Qj = 3'h3;
busy_in = 1;

#1
ld_busy = 1;
issue_ld_Qk = 1;
issue_ld_Qj = 1;

#2
CDB_in.valid = 0;
#1
CDB_in.data = 16'hBAAD;
CDB_in.valid = 1;
CDB_in.tag = 3'h4;

#2
CDB_in.data = 16'h600d;
CDB_in.valid = 1;
CDB_in.tag = 3'h3;

#2
CDB_in.data = 16'hBAAd;
CDB_in.valid = 1;
CDB_in.tag = 3'h3;

#2
CDB_in.data = 16'h600f;
CDB_in.valid = 1;
CDB_in.tag = 3'h2;
end

endmodule : alu_res_testbench
