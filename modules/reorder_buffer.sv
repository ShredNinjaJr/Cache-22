/* Synchronous FIFO Module */
/* Can read and write on the same cycle */
module reorder_buffer #(parameter w = 8, parameter n = 4, parameter tag_width = 3)
(
	input clk, WE, RE, flush
	input logic [w-1:0] val_in,
	input logic busy_in,
	input [tag_width:0] logic tag_in,
	input [2**n-1:0] logic instruc_in,
	input logic valid_in,
	input ld_value, ld_busy, ld_tag, ld_instruc, ld_valid,
	input [w-1:0] addr_in,
	output logic [w-1:0] value_out,
	output logic B_out,
	output [tag_width:0] logic tag_out,
	output [2**n-1:0] logic instruc_out,
	output logic valid_out,
	output logic empty, full
);

logic [n-1:0] r_addr, w_addr;
logic [w-1:0] value [2**n-1:0];
logic [w-1:0] tag[tag_width-1:0];
logic [w-1:0] instruc[2**n-1:0];
logic [w-1:0] valid;
logic [w-1:0] busy;

assign empty = (r_addr == w_addr);
assign full = (r_addr == (w_addr + 1));

assign val_out = value[r_addr];
assign B_out = busy[r_addr];
assign instruc_out = instruc[r_addr];
assign tag_out = tag[r_addr];
assign valid_out = valid[r_addr];

initial
begin
	r_addr = 0;
	w_addr = 0;
    for (int i = 0; i < $size(value); i++)
    begin
			value[i] <= 0;
			busy[i] <= 0;
			tag[i] <= 0;
			instruc[i] <= 0;
			valid[i] <= 0;
	end
end


always_ff @(posedge clk)
begin	
	if(flush)
		begin
			for (int i = 0; i < $size(value); i++)
				begin
					r_addr <= 0;
					w_addr <= 0;
					valid[i] <= 0;
				end	
		end
	if(WE)
	begin: Write
		if(~full)
		begin
			value[w_addr] <= val_in;
			busy[w_addr] <= B_in;
			tag[w_addr] <= tag_in;
			instruc[w_addr] <= instruc_in;
			valid[w_addr] <= valid_in;
			w_addr <= w_addr + 8'b1;
		end
	end		
	else 
		begin
			if(ld_val)
				value[addr_in] <= val_in;
			if(ld_B)
				busy[addr_in] <= B_in;
			if(ld_tag)
				tag[addr_in] <= tag_in;
			if(ld_instruc)
				instruc[addr_in] <= instruc_in;
			if(ld_valid)
				valid[addr_in] <= valid_in;
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

endmodule : reorder_buffer
