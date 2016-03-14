import lc3b_types::*;
module br_adder
(
	input logic[15:0] in,
	input logic[15:0] pc,
	output logic[15:0] out
);

assign out = in + pc;


endmodule

