import lc3b_types::*;

module reorder_buffer #(parameter data_width = 16, parameter tag_width = 3)
(
	input clk, WE, RE, flush,

	/* Inputs to the 4 data fields */
	input lc3b_opcode inst,
	input lc3b_reg dest,
	input [data_width - 1:0] value,
	input predict,
	input lc3b_word orig_pc_in,
	input logic [3:0] bht_in,
	//input [tag_width-1:0] addr,
	input CDB CDB_in,

	/* NON FIFO style read address */
	input [tag_width - 1: 0] sr1_read_addr, 
	input [tag_width - 1: 0] sr2_read_addr, 

	/* Tail address */
	output logic [tag_width-1:0] w_addr_out, r_addr_out,
	/* Output of the 5 data fields at the head of the FIFO */
	output logic valid_out,
	output lc3b_opcode inst_out,
	output lc3b_reg dest_out, 
	output logic [data_width - 1:0] value_out,
	output logic predict_out,
	output lc3b_word orig_pc_out,
	output logic [3:0] bht_out,
	/* Output if full */
	output logic empty_out,
	output logic full_out,
	/* Non FIFO style read outputs */
	output logic [data_width-1:0] sr1_value_out,
    output logic sr1_valid_out,

	output logic [data_width-1:0] sr2_value_out,
    output logic sr2_valid_out	
);

lc3b_opcode inst_in;
lc3b_reg dest_in; 

logic [data_width - 1: 0] value_in_fifo, value_in_addr;
logic predict_in;
logic ld_value, ld_dest, ld_inst, ld_valid, ld_predict, ld_orig_pc, ld_bht;
logic [2:0] addr_in;
logic empty, full;
logic [data_width-1:0] data_sr1_value_out, data_sr2_value_out;
lc3b_opcode sr1_opcode, sr2_opcode;
lc3b_word sr1_orig_pc_out, sr2_orig_pc_out;

assign sr1_value_out = /*((sr1_opcode == op_jsr) & predict_out) ? (sr1_orig_pc_out + 2'b1*/ data_sr1_value_out;

assign sr2_value_out = /*((sr1_opcode == op_jsr) & predict_out) ? (sr2_orig_pc_out + 2'b10)*/ data_sr2_value_out;

assign ld_inst = WE;
assign inst_in = inst;

assign ld_dest = WE;
assign dest_in = dest;

assign ld_value = (CDB_in.valid);

assign ld_valid = ld_value;
 
assign value_in_fifo = value;
assign value_in_addr = CDB_in.data;

assign predict_in = predict;
assign ld_predict = WE;

assign ld_orig_pc = WE;
assign ld_bht = WE;
assign addr_in = CDB_in.tag;

assign empty_out = empty;
assign full_out = full;

reorder_buffer_data ROB (.*);

endmodule : reorder_buffer
