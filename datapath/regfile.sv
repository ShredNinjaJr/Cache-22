import lc3b_types::*;

module regfile #(parameter data_width = 16, parameter tag_width = 3)
(
    input clk,
	 
	 input ld_busy_ic,
	 input ld_busy_rob,
	 input ld_rob_entry,
	 input ld_value,
	 
	 input [tag_width - 1: 0] rob_entry_in,
	 input [data_width - 1:0] value_in,
	
	 input lc3b_reg src_a_ic, src_b_ic, dest_ic,
	 input lc3b_reg src_a_rob, src_b_rob, dest_rob,
		
	 output logic src_a_busy_out,
	 output logic src_b_busy_out,

	 output logic [tag_width - 1:0] src_a_rob_entry_out,
	 output logic [tag_width - 1:0] src_b_rob_entry_out,
	
	 output logic [data_width - 1:0] src_a_value_out,
	 output logic [data_width - 1:0] src_b_value_out
);

logic ld_busy;
logic busy_in;
logic [tag_width - 1: 0] src_a_busy;
logic [tag_width - 1: 0] src_b_busy;
logic [tag_width - 1: 0] dest_busy;

/* Muxing ld of busy reg  with  ic and rob */
assign ld_busy = (ld_busy_ic) ? 1'b1 : ld_busy_rob;

/* busy bit is automatically set  based off of who loaded it */
assign busy_in = (ld_busy_ic) ? 1'b1 : 1'b0;

/* Muxing inputs */
assign src_a_busy = (ld_busy_ic) ? src_a_ic : src_a_rob;
assign src_b_busy = (ld_busy_ic) ? src_b_ic : src_b_rob;
assign dest_busy = (ld_busy_ic) ? dest_ic : dest_rob;


regfile_data #(.data_width(1),.tag_width(3)) busy_reg (
    .clk(clk),
    .load(ld_busy),
    .in(busy_in),
	 .src_a(src_a_busy), 
	 .src_b(src_b_busy), 
	 .dest(dest_busy),
	 .reg_a(src_a_busy_out), 
	 .reg_b(src_b_busy_out)
);

regfile_data #(.data_width(16),.tag_width(3)) value_reg (
	 .clk(clk),
    .load(ld_value),
    .in(value_in),
	 .src_a(src_a_rob), 
	 .src_b(src_b_rob), 
	 .dest(dest_rob),
	 .reg_a(src_a_value_out), 
	 .reg_b(src_b_value_out)
);

regfile_data #(.data_width(3),.tag_width(3)) rob_entry_reg (
	 .clk(clk),
    .load(ld_rob_entry),
    .in(rob_entry_in),
	 .src_a(src_a_ic), 
	 .src_b(src_b_ic), 
	 .dest(dest_ic),
	 .reg_a(src_a_rob_entry_out), 
	 .reg_b(src_b_rob_entry_out)
);

endmodule :regfile
