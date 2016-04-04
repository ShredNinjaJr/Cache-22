import lc3b_types::*;

module cdb_ld_str_res_station #(parameter data_width = 16, parameter tag_width = 3)
(
	input clk, flush, WE, ld_mem_val,
	input lc3b_opcode opcode_in,
	input CDB CDB_in,
	input Vsrc_valid_in, Vbase_valid_in,
	input [data_width-1:0] Vbase, Vsrc, mem_val_in, offset_in,
	input [tag_width-1:0] Qbase, Qsrc, dest,
	
	output Vsrc_valid_out, Vbase_valid_out,
	output CDB CDB_out,
	output lc3b_word dmem_addr,
	output logic dmem_write, dmem_read,
	output lc3b_word dmem_wdata,
	output lc3b_mem_wmask dmem_byte_enable
	
);

logic [data_width - 1: 0] Vsrc_in, Vbase_in;
logic [tag_width - 1: 0] Qsrc_in, Qbase_in, dest_in;
logic ld_opcode, ld_Qsrc, ld_Vsrc, ld_Qbase, ld_Vbase, ld_offset, ld_dest, ld_busy;
logic Vbase_valid_input, Vsrc_valid_input;

logic [data_width - 1: 0] Vsrc_out, Vbase_out, mem_val_out, offset_out, offset_b_out;
logic [tag_width - 1: 0] Qsrc_out, Qbase_out, dest_out;
logic busy_in, busy_out;
lc3b_opcode opcode_out;

logic mem_val_valid_in;
logic mem_val_valid_out;

assign Qbase_in = Qbase;
assign Qsrc_in = Qsrc;
assign dest_in = dest;
assign busy_in = 1'b1;
	
assign Vbase_in = (WE) ? Vbase : CDB_in.data;
assign Vsrc_in = (WE) ? Vsrc : CDB_in.data;

assign Vbase_valid_input = (WE) ? Vbase_valid_in : 1'b1;
assign Vsrc_valid_input = (WE) ? Vsrc_valid_in : 1'b1;

assign ld_busy = WE;
assign ld_opcode = WE;
assign ld_Qsrc = WE;
assign ld_Vsrc = (WE) ? 1'b1 : ((Qsrc_out == CDB_in.tag) & (opcode_out == op_str) & CDB_in.valid & busy_out & ~Vsrc_valid_out);
assign ld_Qbase = WE;
assign ld_Vbase = (WE) ?  1'b1 : ((Qbase_out == CDB_in.tag) & (opcode_out == op_str || op_ldr) & CDB_in.valid & busy_out &  ~Vbase_valid_out);
assign ld_offset = WE;
assign ld_dest = WE;
assign mem_val_valid_in = 1'b1;


ld_str_res_station ld_str_res_station_reg (.*);

assign dmem_addr = (opcode_out == op_ldr || opcode_out == op_str) ? (Vbase_out + offset_out) : (Vbase_out + {offset_out[15:1], 1'b0});

assign dmem_write = Vbase_valid_out & Vsrc_valid_out;

assign dmem_wdata = Vsrc_out;

assign dmem_byte_enable = (opcode_out == op_stb) ? (offset_out[0] ? 2'b10 : 2'b01) : 2'b11;

always_comb
begin
	case(opcode_out)
   op_ldr, op_ldb: dmem_read = Vbase_valid_out & !Vsrc_valid_out;
	default: dmem_read = 0;
	endcase
end

assign CDB_out.valid  = mem_val_valid_out;
assign CDB_out.tag = dest_out;
assign CDB_out.data = (opcode_out == op_ldb) ? (offset_out[0] == 1'b1 ? ({mem_val_out[15:8],8'b0}) : ({8'b0,mem_val_out[7:0]})) : mem_val_out;

endmodule: cdb_ld_str_res_station