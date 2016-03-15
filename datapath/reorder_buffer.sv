
module reorder_buffer #(parameter data_width = 16, parameter tag_width = 3)
(
	input clk, WE, RE, flush,
	input lc3b_opcode inst,
	input lc3b_reg dest,
	input [data_width - 1:0] value,
	input predict,
	input addr,
	input CDB CDB_in,
	
	output logic [tag_width-1:0] waddr,
	output logic valid_out,
	output lc3b_opcode inst_out,
	output lc3b_reg dest_out, 
	output logic value_out,
	output logic predict_out,
	output logic full_out

);

lc3b_opcode inst_in;
lc3b_reg dest_in; 
logic valid_in;
logic [data_width - 1: 0] value_in;
logic predict_in;
logic ld_value, ld_dest, ld_inst, ld_valid, ld_predict;
logic addr_in;
logic empty, full;

assign inst_in = inst;

assign dest_in = dest;
assign valid_in = (WE) ? 0 : ((dest_out == CDB_in.tag) & CDB_in.valid);
assign value_in = ((dest_out == CDB_in.tag) & CDB_in.valid) ? CDB_in.data : value;
assign predict_in = predict;
	
assign ld_value = ((dest_out == CDB_in.tag) & CDB_in.valid) ? 1 : WE; 
assign ld_dest = WE;
assign ld_inst = WE;
assign ld_valid = ((dest_out == CDB_in.tag) & CDB_in.valid) ? 1 : WE;
assign ld_predict = WE;

assign addr_in = addr;

assign full_out = full;

reorder_buffer_data ROB (.*);

endmodule : reorder_buffer
