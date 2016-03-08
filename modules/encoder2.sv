
module encoder2
(
	input in0, in1,
	output logic out
);

assign out = (in0) ? 1'b0 : in1; 

endmodule: encoder2
