import lc3b_types::*;

/* 

4 Data fields handled in a FIFO manner:
Valid, Q, V, Offset, Dest

Q and V carry the same meaning as  res_station, no j and k values due to just one data 
Valid meaning if the Value is  valid or not
Dest meaning ROB entry to go to

Commentted output signals are there if need for them arises 

*/

module load_buffer_data #(parameter data_width = 16, parameter entries_addr = 2)
(
	input clk, WE, RE, flush,
	
	input valid_in,
	input lc3b_reg Q_in,
	input [data_width - 1:0] V_in,
	input [data_width - 1:0] offset_in, 
	input lc3b_rob_addr dest_in,

	input [entries_addr - 1:0] addr_in,
	input logic ld_valid, ld_V,
	
	output logic valid_out,
	output lc3b_reg Q_out0, Q_out1, Q_out2, Q_out3,
	output [data_width-1:0] V_out,
	output [data_width-1:0] offset_out,
	output logic empty, full

	//output lc3b_rob_addr dest_out,
	
);

/* Addresses */
logic [entries_addr-1:0] r_addr, w_addr;
logic [entries_addr:0] counter;

/* Arrays */
logic  valid [2**entries_addr-1:0];
lc3b_reg Q [2**entries_addr-1:0];
logic [data_width-1:0] V [2**entries_addr-1:0];
logic [data_width-1:0] offset [2**entries_addr-1:0];
lc3b_rob_addr dest [2**entries_addr-1:0];

/* Output Signals */
assign empty = (counter == 3'b0);
assign full = (counter == 2**entries_addr);
assign valid_out = valid[r_addr];
assign Q_out0 = Q[2'b00];
assign Q_out1 = Q[2'b01];
assign Q_out2 = Q[2'b10];
assign Q_out3 = Q[2'b11];

assign V_out = V[r_addr];
assign offset_out = offset[r_addr];
//assign dest_out = dest_out[r_addr];

/* Clear the buffer initially */
initial
begin
	r_addr = 0;
	w_addr = 0;
	counter <= 0;
   for (int i = 0; i < 2**entries_addr; i++)
    begin
	 	valid[i] <= 0;
		Q[i] <= 0;
		V[i] <= 0;
		offset[i] <= 0;
		dest[i] <= 0;
	end
end

always_ff @(posedge clk)
begin	
	if(flush)
	begin
		w_addr <= 0;
		for (int i = 0; i < 2**entries_addr; i++)
			begin
				valid[i] <= 1'b0;
			end	
	end
	else
	begin
		/* Write to the tail on WE */
		if(WE)
		begin: Write
			if(~full)
			begin
				valid[w_addr] <= 1'b0;
				Q[w_addr] <= Q_in;
				V[w_addr] <= V_in;
				offset[w_addr] <= offset_in;
				dest[w_addr] <= dest_in;
				counter <= counter + 3'b01;
				w_addr <= w_addr + 2'b1;
			end
		end		
		else 
		/* Write to the given address input  */
		begin
			if(ld_valid)
				valid[addr_in] <= valid_in;
			if(ld_V)
				V[addr_in] <= V_in;
		end
		/* If reading from the head of the tail, clear the valid bit */
		if(RE)
		begin
			valid[r_addr] <= 1'b0;
			counter <= counter - 3'b1;
		end
	end		
end

always_ff @ ( posedge clk)
begin
	if(RE)
	begin: Read
		if(~empty)
		begin
			r_addr <= r_addr + 2'b1;
		end
	end
end

endmodule : load_buffer_data