import lc3b_types::*;

module ld_str_res_station #(parameter data_width = 16, parameter tag_width = 3)
(
	input clk, flush,
	input ld_opcode, ld_Qsrc, ld_Vsrc, ld_Qbase, ld_Vbase, ld_offset, ld_dest, ld_mem_val,
	input [data_width - 1: 0] Vsrc_in, Vbase_in, mem_val_in, offset_in,
	input [tag_width - 1: 0] Qsrc_in, Qbase_in, dest_in,
	input lc3b_opcode opcode_in,
	input Vsrc_valid_in,
	input Vbase_valid_in,
	input mem_val_valid_in,
	
	output logic [data_width - 1: 0] Vsrc_out, Vbase_out, mem_val_out, offset_out,
	output logic [tag_width - 1: 0] Qsrc_out, Qbase_out, dest_out,
	output lc3b_opcode opcode_out,
	output logic Vsrc_valid_out,
	output logic Vbase_valid_out,
	output logic mem_val_valid_out
);

/* All the data fields in this kind of ld/str res station

lc3b_opcode					opcode			

lc3b_reg 					Qsrc 				
logic  						Vsrc_valid 	
lc3b_word					Vsrc	 			

lc3b_reg 					Qbase 		
logic  						Vbase_valid 	
lc3b_word 					Vbase 			

lc3b_word 					offset 			

lc3b_rob_addr 			 	dest 				

logic 						mem_val_valid	
lc3b_word 					mem_val 			
*/

register #(.width(4)) opcode
(
    .clk, .load(ld_opcode), .clr(flush),
    .in(opcode_in),
    .out({opcode_out})
);

register #(.width(tag_width)) Qsrc
(
    .clk, .load(ld_Qsrc), .clr(flush),
    .in(Qsrc_in),
    .out(Qsrc_out)
);

register #(.width(1)) Vsrc_valid
(
    .clk, .load(ld_Vsrc), .clr(flush),
    .in(Vsrc_valid_in),
    .out(Vsrc_valid_out)
);

register #(.width(data_width)) Vsrc
(
    .clk, .load(ld_Vsrc), .clr(flush),
    .in(Vsrc_in),
    .out(Vsrc_out)
);

register #(.width(tag_width)) Qbase
(
    .clk, .load(ld_Qbase), .clr(flush),
    .in(Qbase_in),
    .out(Qbase_out)
);

register #(.width(1)) Vbase_valid
(
    .clk, .load(ld_Vbase), .clr(flush),
    .in(Vbase_valid_in),
    .out(Vbase_valid_out)
);

register #(.width(data_width)) Vbase
(
    .clk, .load(ld_Vbase), .clr(flush),
    .in(Vbase_in),
    .out(Vbase_out)
);

register #(.width(data_width)) offset
(
    .clk, .load(ld_offset), .clr(flush),
    .in(offset_in),
    .out(offset_out)
);

register #(.width(tag_width)) dest
(
    .clk, .load(ld_dest), .clr(flush),
    .in(dest_in),
    .out(dest_out)
);

register #(.width(1)) mem_val_valid
(
    .clk, .load(ld_mem_val), .clr(flush),
    .in(mem_val_valid_in),
    .out(mem_val_valid_out)
);

register #(.width(data_width)) mem_val
(
    .clk, .load(ld_mem_val), .clr(flush),
    .in(mem_val_in),
    .out(mem_val_out)
);

endmodule: ld_str_res_station
