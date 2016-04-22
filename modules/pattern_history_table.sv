
module pattern_history_table #(parameter data_out = 2, parameter table_index = 7)
(
	input clk,
	input [table_index-1:0] pc_pred_in,
	input logic ld_pht, taken_in,
	input [table_index-1:0] pc_taken_in,
	
	output logic pred_out
);

logic [data_out-1:0] pht [(2**(table_index) - 1):0];
logic [data_out-1:0] pht_old;

assign pht_old = pht[pc_taken_in];

initial
begin
	for (int i = 0; i < $size(pht); i++)
	begin
		pht[i] = 2'b01;
	end
end


always_ff @(posedge clk)
begin
	if (ld_pht)
	begin
		case (pht_old)
			2'b00: pht[pc_taken_in] <= {1'b0, taken_in};
			2'b01: pht[pc_taken_in] <= {taken_in, 1'b0};
			2'b10: pht[pc_taken_in] <= {taken_in, 1'b1};
			2'b11: pht[pc_taken_in] <= {1'b1, taken_in};
		endcase
		
	end
end

always_comb
begin
	pred_out = pht[pc_pred_in][1];
end


endmodule:pattern_history_table
