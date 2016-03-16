import lc3b_types::*;

/* This tests reorder_buffer */
module rob_testbench_2;

timeunit 1ns; 
timeprecision 1ns;

logic clk, WE, RE, flush;
lc3b_opcode inst;
lc3b_reg dest;
logic [15:0] value;
logic predict;
logic [2:0] addr;
CDB CDB_in;

logic [2:0] addr_out;
logic valid_out;
lc3b_opcode inst_out;
lc3b_reg dest_out;
logic [15:0] value_out;
logic predict_out;
logic full_out;

reorder_buffer ROB(.*);

always #1 clk = ~clk;

initial begin: CLOCK_INITIALIZATION
	clk = 0;
end

initial begin: TEST_VECTORS

WE = 0;
RE = 0;
flush = 0;
inst = op_add;
dest = 0;
value = 0;
predict = 0;
addr = 0;

CDB_in.data = 0;
CDB_in.valid = 0;
CDB_in.tag = 0;

#2

inst = op_add;
dest = 2;
WE = 1;

#2 WE = 0;

#2

inst = op_and;
dest = 4;
WE = 1;

#2 WE = 0;


#2

inst = op_add;
dest = 1;
WE = 1;

#2 WE = 0;

#2

inst = op_add;
dest = 3;
WE = 1;

#2 WE = 0;

#2
RE = 1;

#2 RE = 0;

#2
CDB_in.valid = 1;
CDB_in.tag = 3;
CDB_in.data = 15;

#2
CDB_in.valid = 0;
CDB_in.tag = 0;
CDB_in.data = 24;




end

endmodule : rob_testbench_2