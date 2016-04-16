
module L2_lru_update
(
	input [2:0] lru_data,
	input [1:0] way_match,
	output logic [2:0] lru_datain,
	output logic [1:0] lru_dataout
);

always_comb
begin
	case(way_match)
	2'b00: lru_datain = {lru_data[2], 2'b00};
	2'b01: lru_datain = {lru_data[2], 2'b10};
	2'b10: lru_datain = {1'b0, lru_data[1], 1'b1};
	2'b11: lru_datain = {1'b1, lru_data[1], 1'b1};
	endcase
	
	case(lru_data)
		3'b011, 3'b111: lru_dataout = 2'b001;
		3'b001, 3'b101: lru_dataout = 2'b01;
		3'b100, 3'b110: lru_dataout = 2'b10;
		3'b000, 3'b010: lru_dataout = 2'b11;
	endcase
end

endmodule
