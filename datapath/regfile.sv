import lc3b_types::*;

module regfile #(parameter data_width = 16, parameter tag_width = 3)
(
    input clk, flush, 
	 
	/* Load signals for each register */
	 input ld_busy_ic,
	 input ld_busy_rob,
	 input ld_rob_entry,
	 input ld_value,
	 
	 /* ROB ENTRY input from Issue Control */
	 input [tag_width - 1:0] rob_entry_in,
	 /* VALUE input from ROB */
	 input [data_width - 1:0] value_in,
	
	 input lc3b_reg sr1_ic, sr2_ic, dest_ic,
	 input lc3b_reg dest_rob,
	 input lc3b_reg dest_wr,
	 
	 output lc3b_rob_addr dest_wr_out,

	 /* Dest output needed for Issue Control */
	 output regfile_t sr1_out, sr2_out, dest_out
);

//logic ld_busy;
//logic busy_in;
//logic [tag_width - 1: 0] sr1_busy;
//logic [tag_width - 1: 0] sr2_busy;
//logic [tag_width - 1: 0] dest_busy;

/* Muxing ld of busy reg  with  ic and rob */
//assign ld_busy = (ld_busy_ic) ? 1'b1 : ld_busy_rob;

/* busy bit is automatically set  based off of who loaded it */
//assign busy_in = (ld_busy_ic) ? 1'b1 : 1'b0;

/* Muxing inputs */
//assign sr1_busy = (ld_busy_ic) ? sr1_ic : sr1_rob;
//assign sr2_busy = (ld_busy_ic) ? sr2_ic : sr2_rob;
//assign dest_busy = (ld_busy_ic) ? dest_ic : dest_rob;

/* A has priority over B if writing to same address */
two_write_regfile #(.data_width(1),.tag_width(3)) busy_reg (
    .clk(clk), .flush, 
    .load_a(ld_busy_ic),
	 .load_b(ld_busy_rob),
    .in_a(1'b1),
	 .in_b(1'b0),
	 .sr1(sr1_ic), 
	 .sr2(sr2_ic), 
	 .dest_a(dest_ic),
	 .dest_b(dest_rob),
	 .reg_a(sr1_out.busy), 
	 .reg_b(sr2_out.busy),
	 .dest_out(dest_out.busy)
);

regfile_data #(.data_width(16),.tag_width(3)) value_reg (
	 .clk(clk),
    .load(ld_value),
    .in(value_in),
	 .sr1(sr1_ic), 
	 .sr2(sr2_ic), 
	 .dest(dest_rob),
	 .dest_b(dest_ic),
	 .reg_a(sr1_out.data), 
	 .reg_b(sr2_out.data),
	 //.dest_out(dest_out.data),
	 .dest_b_out(dest_out.data)
);

regfile_data #(.data_width(3),.tag_width(3)) rob_entry_reg (
	 .clk(clk),
    .load(ld_rob_entry),
    .in(rob_entry_in),
	 .sr1(sr1_ic), 
	 .sr2(sr2_ic), 
	 .dest(dest_ic),
	 .reg_a(sr1_out.rob_entry), 
	 .reg_b(sr2_out.rob_entry),
	 .dest_out(dest_out.rob_entry),
	 .dest_b(dest_wr),
	 .dest_b_out(dest_wr_out)
);

endmodule :regfile
