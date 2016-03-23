import lc3b_types::*;

/* Reorder buffer has 5 fields:
  Opcode : opcode of the instruction
  dest : Destination register of instruction
  valid: Boolean if value field is valid 
  value: The value stored into the regfile
  predict: Only useful for branch instruction. Contains the prediction made.
  	  Used to detect mispredicts.
*/

module reorder_buffer_data #(parameter data_width = 16, parameter tag_width = 3)
(
	input clk, WE, RE, flush,
	
	/* Inputs for the opcode, dest, valid, value and predict field */
	input lc3b_opcode inst_in,	
	input lc3b_reg dest_in,			
	input logic [data_width-1:0] value_in,	
	input logic predict_in,		
	
	/* load signals */
	input ld_value, ld_dest, ld_inst, ld_valid, ld_predict,

	/* Addr to write to in non FIFO manner ( for the value and valid field) */
	input [tag_width-1:0] addr_in,	

	/* Address to read from in non FIFO manner */
	input [tag_width-1: 0] sr1_read_addr,
	input [tag_width-1: 0] sr2_read_addr,
	/* Outputs from each of the fields, from the head of the queue */
	output lc3b_opcode inst_out,
	output lc3b_reg dest_out,
	output logic valid_out,
	output logic [data_width-1:0] value_out,
	output logic predict_out,

	/* The current tail address of the FIFO*/
	output [tag_width-1:0] addr_out,
	
	/* Signals if the Buffer is empty/full */
	output logic empty, full,

	output logic [data_width-1:0] sr1_value_out,
	output logic sr1_valid_out,
	output logic [data_width-1:0] sr2_value_out,
	output logic sr2_valid_out
);


logic [tag_width-1:0] r_addr, w_addr; 	/* Read and write addr for the FIFO */
/* The 5 Data fields */
logic [data_width-1:0] value [2**tag_width-1:0];
logic [tag_width-1:0] dest	[2**tag_width-1:0];
lc3b_opcode inst [2**tag_width-1:0];
logic valid [2**tag_width - 1:0];
logic predict [2**tag_width - 1:0];

logic [tag_width : 0] cnt;

/* Empty / full logic */
assign empty = (cnt == 0);
assign full = (cnt == 2**tag_width);

/* Output values of the head of the FIFO */
assign value_out = value[r_addr];
assign inst_out = inst[r_addr];
assign dest_out = dest[r_addr];
assign valid_out = valid[r_addr];
assign predict_out = predict[r_addr];

assign addr_out = w_addr;

/* Assign non FIFO style outputs */
assign sr1_value_out = value[sr1_read_addr];
assign sr1_valid_out = valid[sr1_read_addr];
assign sr2_value_out = value[sr2_read_addr];
assign sr2_valid_out = valid[sr2_read_addr];

/* Clear the buffer initially */
initial
begin
	r_addr = 0;
	w_addr = 0;
    for (int i = 0; i < 2**tag_width; i++)
    begin
		value[i] <= 0;
		dest[i] <= 0;
		inst[i] <= op_br;
		valid[i] <= 0;
		predict[i] <= 0;
		cnt <= 0;
	end
end



always_ff @(posedge clk)
begin: Write_logic
	if(flush)
	begin
		w_addr <= 0;
		for (int i = 0; i < 2**tag_width; i++)
			begin	
				valid[i] <= 1'b0;
				cnt <= 0;
			end	
	end
	else
	begin
		/* Write to the tail on WE */
		if(WE)
		begin: Write
			if(~full)
			begin
				value[w_addr] <= value_in;
				dest[w_addr] <= dest_in;
				inst[w_addr] <= inst_in;
				valid[w_addr] <= 1'b0;
				predict[w_addr] <= predict_in;
				w_addr <= w_addr + 1'b1;
				cnt <= cnt + 1'b1;
			end
		end		
		/* Write to the given address input  */
			if(ld_value)
				value[addr_in] <= value_in;
			if(ld_valid)
				valid[addr_in] <= 1'b1;

		/* If reading from the head of the tail, clear the valid bit */
		if(RE)
		begin
			valid[r_addr] <= 1'b0;
			cnt <= cnt - 1'b1;
		end
	end
			
end

always_ff @ ( posedge clk)
begin :	read_logic 
	if(flush)
		begin
			r_addr <= 0;
		end
	else if(RE)
	/* If not empty, increment the head of the FIFO */
	begin: Read
		if(~empty)
		begin
			r_addr <= r_addr + 3'b1;
		end
	end
end : read_logic

endmodule
