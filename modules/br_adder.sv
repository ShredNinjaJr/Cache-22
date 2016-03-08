import lc3b_types::*;
module br_adder
(
	input lc3b_word in,
	input lc3b_word pc,
	output lc3b_word out
);

assign out = in + pc;


endmodule

