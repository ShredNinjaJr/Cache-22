/* Synchronous FIFO Module */
/* Can read and write on the same cycle */
module FIFO #(parameter w = 6, parameter n = 8)
(
	input clk, WE, RE,
	input logic [w-1:0] data_in,
	output logic [w-1:0] data_out,
	output logic empty, full
);

logic [n-1:0] r_addr, w_addr;
logic [w-1:0] mem_array [2**n-1:0];

assign empty = (r_addr == w_addr);
assign full = (r_addr == (w_addr + 1));
assign data_out = mem_array[r_addr];


always_ff @(posedge clk)
begin	
	if(WE)
	begin: Write
		if(~full)
		begin
			mem_array[w_addr] <= data_in;
			w_addr <= w_addr + 8'b1;
		end
	end		
end

always_ff @ ( posedge clk)
begin
	if(RE)
	begin: Read
		if(~empty)
		begin
			r_addr <= r_addr + 8'b1;
		end
	end
end

endmodule
