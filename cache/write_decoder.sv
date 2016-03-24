
module write_decoder
(
	input enable, lru_dataout, allocate, way_match,
	output logic out0, out1
);

always_comb
begin
	if(allocate)
	begin
		out0 = ~lru_dataout;
		out1 = lru_dataout;
	end
	else
	begin
		if(enable)
		begin
			
			begin
				out0 = ~way_match;
				out1 = way_match;
			end
		end
		else
		begin
			out0 = 0;
			out1 = 0;
		end
	end

end

endmodule
