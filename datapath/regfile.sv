import lc3b_types::*;

module regfile #(parameter data_width = 16, parameter tag_width = 3)
(
    input clk,
	 
	 input ld_busy_ic,
	 input ld_busy_rob,
	 input ld_rob_entry,
	 input ld_value,
	 
	 input regfile_t rob_in;
	 input regfile_t ic_in;

	 input lc3b_reg sr1_ic, sr2_ic, dest_ic,
	 input lc3b_reg sr1_rob, sr2_rob, dest_rob,

	 output regfile_t sr1_ic_out, sr2_ic_out, dest_ic_out;
);

logic ld_busy;
logic busy_in;
logic [tag_width - 1: 0] sr1_busy;
logic [tag_width - 1: 0] sr2_busy;
logic [tag_width - 1: 0] dest_busy;

/* Muxing ld of busy reg  with  ic and rob */
assign ld_busy = (ld_busy_ic) ? 1'b1 : ld_busy_rob;

/* busy bit is automatically set  based off of who loaded it */
assign busy_in = (ld_busy_ic) ? 1'b1 : 1'b0;

/* Muxing inputs */
assign sr1_busy = (ld_busy_ic) ? sr1_ic : sr1_rob;
assign sr2_busy = (ld_busy_ic) ? sr2_ic : sr2_rob;
assign dest_busy = (ld_busy_ic) ? dest_ic : dest_rob;


regfile_data #(.data_width(1),.tag_width(3)) busy_reg (
    .clk(clk),
    .load(ld_busy),
    .in(busy_in),
	 .sr1(sr1_busy), 
	 .sr2(sr2_busy), 
	 .dest(dest_busy),
	 .reg_a(sr1_busy_out), 
	 .reg_b(sr2_busy_out)
);

regfile_data #(.data_width(16),.tag_width(3)) value_reg (
	 .clk(clk),
    .load(ld_value),
    .in(value_in),
	 .sr1(sr1_rob), 
	 .sr2(sr2_rob), 
	 .dest(dest_rob),
	 .reg_a(sr1_value_out), 
	 .reg_b(sr2_value_out)
);

regfile_data #(.data_width(3),.tag_width(3)) rob_entry_reg (
	 .clk(clk),
    .load(ld_rob_entry),
    .in(rob_entry_in),
	 .sr1(sr1_ic), 
	 .sr2(sr2_ic), 
	 .dest(dest_ic),
	 .reg_a(sr1_rob_entry_out), 
	 .reg_b(sr2_rob_entry_out)
);

endmodule :regfile
