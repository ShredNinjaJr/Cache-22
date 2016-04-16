
module L2_write_decoder
(
	input enable,  allocate, 
	input [2:0] lru_d, 
	input [1:0] way_match,
	output logic out0, out1, out2, out3
);


always_comb
begin
	
	out0 = 0;
	out1 = 0;
	out2 = 0;
	out3 = 0;
	
	if(allocate)
	begin
		case(lru_d)
		3'b011, 3'b111: out0 = 1;
		3'b001, 3'b101: out1 = 1;
		3'b100, 3'b110: out2 = 1;
		3'b000, 3'b010: out3 = 1;
		endcase
	end
	else
	begin
		if(enable)
		begin	
			begin
				out0 = (way_match == 2'b00);
				out1 = (way_match == 2'b01);
				out2 = (way_match == 2'b10);
				out3 = (way_match == 2'b11);
			end
		end

	end

end

endmodule
