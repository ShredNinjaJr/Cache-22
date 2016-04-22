import lc3b_types::*;

/*
4 bit Branch History, 3 bits from PC -> 
8 entries in Branch History Table, 7 bit address to index PHT. ->
128 entries in PHT, 2 bits each, -> 
256 bits in PHT,
*/
module predict_unit
(
	input clk,
	input ld_pred_unit,
	input lc3b_word new_pc, old_pc,
	input taken_in,
	
	output logic pred_out
);

lc3b_bht_ind pc_in, pc_taken_in;
lc3b_bht_out bht_out;
lc3b_pht_ind pht_ind;


assign pht_ind = {pc_in, bht_out};
assign pc_in = new_pc[3:1];
assign pc_taken_in = old_pc[3:1];

branch_history_table BHT
(
	.clk(clk),
	.pc_pred_in(pc_in),
	.ld_bht(ld_pred_unit),
	.taken_in(taken_in),
	.pc_taken_in(pc_taken_in),
	
	.bht_out(bht_out)
);



pattern_history_table PHT
(
	.clk(clk),
	.pc_pred_in(pht_ind),
	.ld_pht(ld_pred_unit),
	.taken_in(taken_in),
	.pc_taken_in(pc_taken_in),
	
	.pred_out(pred_out)
);


endmodule:predict_unit
