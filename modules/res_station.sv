import lc3b_types::*;

module res_station #(parameter data_width = 16, parameter tag_width = 3)
(
	input clk, flush,
	input ld_op, ld_Vj, ld_Qj, ld_Vk, ld_Qk, ld_busy, ld_dest,
	input [data_width - 1: 0] Vj_in, Vk_in,
	input [tag_width - 1: 0] Qj_in, Qk_in, dest_in,
	input lc3b_opcode op_in,
	input busy_in,
	input Vk_valid_in,
	input Vj_valid_in,
	
	output logic [data_width - 1: 0] Vj_out, Vk_out,
	output logic [tag_width - 1: 0] Qj_out, Qk_out, dest_out,
	output lc3b_opcode op_out,
	output logic busy_out,
	output logic Vk_valid_out,
	output logic Vj_valid_out	
);

register #(.width(1)) Vk_valid
(
    .clk, .load(ld_Vk), .clr(flush),
    .in(Vk_valid_in),
    .out(Vk_valid_out)
);

register #(.width(tag_width)) Qk
(
    .clk, .load(ld_Qk), .clr(flush),
    .in(Qk_in),
    .out(Qk_out)
);

register #(.width(data_width)) Vk
(
    .clk, .load(ld_Vk), .clr(flush),
    .in(Vk_in),
    .out(Vk_out)
);

register #(.width(tag_width)) Qj
(
    .clk, .load(ld_Qj), .clr(flush),
    .in(Qj_in),
    .out(Qj_out)
);

register #(.width(1)) Vj_valid
(
    .clk, .load(ld_Vj), .clr(flush),
    .in(Vj_valid_in),
    .out(Vj_valid_out)
);

register #(.width(data_width)) Vj
(
    .clk, .load(ld_Vj), .clr(flush),
    .in(Vj_in),
    .out(Vj_out)
);

register #(.width(tag_width)) dest
(
    .clk, .load(ld_dest), .clr(flush),
    .in(dest_in),
    .out(dest_out)
);

register #(.width(1)) busy
(
    .clk, .load(ld_busy), .clr(flush),
    .in(busy_in),
    .out(busy_out)
);

register #(.width(4)) op
(
    .clk, .load(ld_op), .clr(flush),
    .in(op_in),
    .out({op_out})
);


endmodule: res_station
