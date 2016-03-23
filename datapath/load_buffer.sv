import lc3b_types::*;

module load_buffer #(parameter data_width = 16, parameter entries_addr = 2)
(
	input clk,

	/* From Issue Control */
	input WE, flush,
	input lc3b_reg Q_in,
	input [data_width - 1:0] V,
	input [data_width - 1:0] offset_in,
	input lc3b_rob_addr dest_in,
	
	/* From Dcache */
	input logic dmem_resp, dmem_rdata,
	
	/* CDB */
	input CDB CDB_in,
	output CDB CDB_out,
		
	/* To Dcache */
	output lc3b_word dmem_addr,
	output logic dmem_read,
	
	/* To Issue Control */
	output logic empty,
	output logic full,
	
	/* The thing that vib needs to  send stuff to ROB*/
	output lc3b_reg dest_out
	
);

logic RE;

logic ld_mem_val;
lc3b_word mem_val_in;
logic mem_val_valid_out;
lc3b_word mem_val_out;

logic ld_V;
logic [data_width - 1: 0] V_in;

logic ld_valid;
logic valid_in;
logic valid_out;

logic [data_width - 1: 0] V_out;
logic [data_width - 1: 0] offset_out;

lc3b_reg Q_out0, Q_out1, Q_out2, Q_out3;
logic [1:0] addr_in;

/* Handling of Input Signals from CDB and Issue Control*/
assign ld_valid = (CDB_in.valid) ? 1'b1 : WE;
assign valid_in = (WE) ? 1'b0 : (CDB_in.valid);

assign ld_V = (CDB_in.valid) ? 1'b1 : WE; 
assign V_in = (WE) ? V : (CDB_in.data);

/* assigns appropriate entry in load buffer to write valid bit and value into*/
assign addr_in = (CDB_in.tag == Q_out0) ? 2'b00 : (CDB_in.tag == Q_out1) ? 2'b01 : (CDB_in.tag == Q_out2) ? 2'b10 : 2'b11;

load_buffer_data LB (.*);

assign dmem_addr = (V_out + offset_out);

assign dmem_read = valid_out;

assign ld_mem_val = dmem_resp;

assign mem_val_in = dmem_rdata;

assign RE = mem_val_valid_out;

assign CDB_out.valid = mem_val_valid_out;
assign CDB_out.tag = dest_out;
assign CDB_out.data = mem_val_out;

endmodule : load_buffer
