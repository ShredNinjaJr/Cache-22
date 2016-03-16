module rob_testbench;

/* This tests reorder_buffer _data*/

timeunit 1ns; 
timeprecision 1ns;

logic clk = 0;
logic WE,RE,flush;

logic ld_value, ld_busy, ld_tag, ld_inst, ld_valid, ld_predict;

logic [15:0] value_in;
logic [2:0] tag_in;
logic [15:0] inst_in;
logic busy_in, valid_in, predict_in;

logic [15:0] value_out;
logic[2:0]  tag_out;
logic[15:0]  inst_out;
logic busy_out, valid_out, predict_out;

logic empty, full;
logic [2:0] addr_in;


reorder_buffer ROB(
	.clk(clk),
	.WE(WE),
	.RE(RE),
	.flush(flush),
	.value_in(value_in),
	.busy_in(busy_in),
	.tag_in(tag_in),
	.inst_in(inst_in),
	.valid_in(valid_in),
	.predict_in(predict_in),
	.ld_value(ld_value), 
	.ld_busy(ld_busy), 
	.ld_tag(ld_tag), 
	.ld_inst(ld_inst), 
	.ld_predict(ld_predict),
	.ld_valid(ld_valid),
	.addr_in(addr_in),
	.value_out(value_out),
	.busy_out(busy_out),
	.tag_out(tag_out),
	.inst_out(inst_out),
	.valid_out(valid_out),
	.predict_out(predict_out),
	.empty(empty),
	.full(full)

);

always #1 clk = ~clk;

initial begin: CLOCK_INITIALIZATION
	clk = 0;
end

initial begin: TEST_VECTORS

WE = 0;
RE = 0;
flush = 0;

ld_value = 0;
ld_busy = 0;
ld_tag = 0;
ld_inst = 0;
ld_valid = 0;
ld_predict = 0;

value_in = 0;
tag_in = 0; 
inst_in = 0;
busy_in = 0;
valid_in = 0;
predict_in = 0;

addr_in = 0;

#3

busy_in = 1;
tag_in = 4;
predict_in = 0;
value_in = 20;
WE = 1;

#1 WE = 0;

#3

busy_in = 1;
tag_in = 2;
predict_in = 0;
value_in = 15;
WE = 1;

#1 WE = 0;


#3

busy_in = 1;
tag_in = 7;
predict_in = 0;
value_in = 8;
WE = 1;

#1 WE = 0;


#3

busy_in = 1;
tag_in = 5;
predict_in = 0;
value_in = 12;
WE = 1;

#1 WE = 0;

#3

busy_in = 1;
tag_in = 4;
predict_in = 0;
value_in = 9;
WE = 1;

#1 WE = 0;


#3

busy_in = 1;
tag_in = 0;
predict_in = 0;
value_in = 44;
WE = 1;

#1 WE = 0;

#3

busy_in = 1;
tag_in = 6;
predict_in = 0;
value_in = 23;
WE = 1;

#1 WE = 0;

#3

busy_in = 1;
tag_in = 1;
predict_in = 0;
value_in = 22;
WE = 1;

#1 WE = 0;

#4 RE = 1;

#1 RE = 0;

#4 RE = 1;

#1 RE = 0;

#2 
value_in = 34;
addr_in = 1;
ld_value = 1;

#2 ld_value = 0;

#2

#4 RE = 1;

#1 RE = 0;

#4 RE = 1;

#1 RE = 0;

#4 RE = 1;

#1 RE = 0;

#4 RE = 1;

#1 RE = 0;

#4 RE = 1;

#1 RE = 0;

#4 RE = 1;

#1 RE = 0;

#4 RE = 1;

#1 RE = 0;

#4 RE = 1;

#1 RE = 0;

end

endmodule : rob_testbench