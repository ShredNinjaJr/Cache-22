
module branch_history_table #(parameter data_out = 4, parameter table_index = 3)
(
	input clk,
	input logic [table_index-1:0] pc_pred_in,
	input ld_bht, taken_in,
	input logic [table_index-1:0] pc_taken_in,
	
	output logic [data_out-1:0] bht_out
);

logic [data_out-1:0] bht [(2**(table_index) - 1):0];
logic [data_out-2:0] bht_old;

assign bht_old = bht[pc_taken_in][data_out-2:0];

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
