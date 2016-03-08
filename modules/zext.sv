import lc3b_types::*;

module zext #(parameter width)
(
	input [width-1:0] in,
	output lc3b_word out
);

	
assign out = in;

endmodule: zext
