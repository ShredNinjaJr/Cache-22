import lc3b_types::*;

module pattern_history_table (parameter data_out = 2, parameter table_index = 7)
(
	input clk,
	input [table_index-1:0] pht_pred_ind,
	input ld_pht, taken_in,
	input [table_index-1:0] pht_taken_ind,
	
	output pred_out
);

logic [data_out-1:0] pht [(2**(table_index) - 1):0];
logic [data_out-1:0] pht_old;

assign pht_old = pht(pht_taken_ind);

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
			2'b00: pht[pht_taken_ind] <= {0, taken_in};
			2'b01: pht[pht_taken_ind] <= {taken_in, 0};
			2'b10: pht[pht_taken_ind] <= {taken_in, 1};
			2'b11: pht[pht_taken_ind] <= {1, taken_in};
		endcase
		
	end
end

always_comb
begin
	pred_out = (pht[pht_pred_ind])[1];
end


endmodule:pattern_history_table
