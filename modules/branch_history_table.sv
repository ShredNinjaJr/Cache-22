import lc3b_types::*;

module branch_history_table
(
	input clk,
	input lc3b_bht_ind pc_pred_in,
	input ld_bht, taken_in,
	input lc3b_bht_ind pc_taken_in,
	
	output lc3b_bht_out bht_out
);

logic lc3b_bht_out bht [2:0];
logic [2:0] bht_old;

assign bht_old = bht[pc_taken_in][2:0];

initial
begin
	for (int i = 0; i < $size(bht); i++)
	begin
		bht[i] = 0;
	end
end


always_ff @(posedge clk)
begin
	if (ld_bht)
	begin
		bht[pc_taken_in] <= {bht_old, taken_in};
	end
end

always_comb
begin
	bht_out = bht[pc_pred_in];
end

endmodule:branch_history_table
