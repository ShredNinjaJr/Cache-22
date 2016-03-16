import lc3b_types::*;

module reorder_buffer #(parameter data_width = 16, parameter tag_width = 3)
(
	input clk, WE, RE, flush,
	input lc3b_opcode inst,
	input lc3b_reg dest,
	input [data_width - 1:0] value,
	input predict,
	input [tag_width-1:0] addr,
	input CDB CDB_in,
	
	output logic [tag_width-1:0] addr_out,
	output logic valid_out,
	output lc3b_opcode inst_out,
	output lc3b_reg dest_out, 
	output logic [data_width - 1:0] value_out,
	output logic predict_out,
	output logic full_out

);

lc3b_opcode inst_in;
lc3b_reg dest_in; 
logic valid_in;
logic [data_width - 1: 0] value_in;
logic predict_in;
logic ld_value, ld_dest, ld_inst, ld_valid, ld_predict;
logic [2:0] addr_in;
logic empty, full;

assign ld_inst = WE;
assign inst_in = inst;

assign ld_dest = WE;
assign dest_in = dest;

assign ld_valid = (CDB_in.valid & 1) ? 1'b1 : WE;
assign valid_in = (WE) ? 1'b0 : (CDB_in.valid & 1);

assign ld_value = (CDB_in.valid & 1) ? 1'b1 : WE; 
assign value_in = (CDB_in.valid & 1) ? CDB_in.data : value;

assign predict_in = predict;
assign ld_predict = WE;

assign addr_in = (CDB_in.valid & 1) ? CDB_in.tag : addr;

assign full_out = full;

reorder_buffer_data ROB (.*);

endmodule : reorder_buffer
