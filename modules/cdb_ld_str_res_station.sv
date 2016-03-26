import lc3b_types::*;

module cdb_ld_str_res_station #(parameter data_width = 16, parameter tag_width = 3)
(
	input clk, flush, WE, ld_mem_val,
	input lc3b_opcode opcode_in,
	input CDB CDB_in,
	input Vsrc_valid_in, Vbase_valid_in,
	input [data_width-1:0] Vbase, Vsrc, mem_val_in,
	input [tag_width-1:0] Qbase, Qsrc, dest,
	
	output Vsrc_valid_out, Vbase_valid_out,
	output CDB CDB_out,
	output lc3b_word dmem_addr,
	output logic dmem_write, dmem_read,
	output lc3b_word dmem_wdata
	
);

logic [data_width - 1: 0] Vsrc_in, Vbase_in, mem_val_in, offset_in;
logic [tag_width - 1: 0] Qsrc_in, Qbase_in, dest_in;
logic ld_opcode, ld_Qsrc, ld_Vsrc, ld_Qbase, ld_Vbase, ld_offset, ld_dest, ld_mem_val;

logic [data_width - 1: 0] Vsrc_out, Vbase_out, mem_val_out, offset_out;
logic [tag_width - 1: 0] Qsrc_out, Qbase_out, dest_out;
lc3b_opcode opcode_out;
logic Vsrc_valid_out;
logic Vbase_valid_out;

logic mem_val_valid_out;

assign Qbase_in = Qbase;
assign Qsrc_in = Qsrc;
assign dest_in = dest;
	
assign Vbase_in = (WE) ? Vbase : CDB_in.data;
assign Vsrc_in = (WE) ? Vsrc : CDB_in.data;

assign ld_opcode = WE;
assign ld_Qsrc = WE;
assign ld_Vsrc = (WE) ? 1'b1 : ((Qsrc_out == CDB_in.tag) & CDB_in.valid & ~Vsrc_valid_out);
assign ld_Qbase = WE;
assign ld_Vbase = (WE) ?  1'b1 : ((Qbase_out == CDB_in.tag) & CDB_in.valid & ~Vbase_valid_out);
assign ld_offset = WE;
assign ld_dest = WE;

ld_str_res_station ld_str_res_station_reg (.*);

assign dmem_addr = (Vbase_out + offset_out);

assign dmem_write = Vbase_valid_out & Vsrc_valid_out;

assign dmem_wdata = Vsrc_out;

assign dmem_read = Vbase_valid_out & !Vsrc_valid_out;

assign CDB_out.valid  = mem_val_valid_out;
assign CDB_out.tag = dest_out;
assign CDB_out.data = mem_val_out;

endmodule: cdb_ld_str_res_station