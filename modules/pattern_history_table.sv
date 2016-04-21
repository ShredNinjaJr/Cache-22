import lc3b_types::*;

module pattern_history_table
(
	input clk,
	input lc3b_pht_ind pht_pred_ind,
	input ld_pht, taken_in,
	input [6:0] pht_taken_ind,
	
	output pred_out
);

logic [1:0] pht [6:0];
logic [1:0] pht_old;

initial
begin
	for (int i = 0; i < $size(pht); i++)
	begin
		pht[i] = 2'b01;
	end
end


always_ff @(posedge clk)
begin
	if (ld_pht == 1)
	begin
		pht[pht_taken_ind] <= 2;
	end
end

always_comb
begin
	pred_out = pht[pht_pred_ind][1];
end


endmodule:pattern_history_table
