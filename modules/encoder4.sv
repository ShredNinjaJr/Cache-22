
module encoder4
(
	input in0, in1, in2, in3,
	output logic [1:0] out
);

assign out = (in0)? 2'b0 : 
				 (in1) ? 2'b1 :
				 (in2) ? 2'b10 :
				 (in3) ? 2'b11 : 2'b00; 

endmodule: encoder4
