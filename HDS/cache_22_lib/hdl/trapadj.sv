import lc3b_types::*;

module trapadj #(parameter width = 8)
(
	input [width-1:0] in,
	output logic[15:0] out
);

	
assign out = {in, 1'b0};

endmodule: trapadj
