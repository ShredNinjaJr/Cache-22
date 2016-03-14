import lc3b_types::*;

module zext #(parameter width)
(
	input [width-1:0] in,
	output logic[15:0] out
);

	
assign out = in;

endmodule: zext
