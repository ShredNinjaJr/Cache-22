
module reorder_buffer #(parameter w = 8, parameter n = 4, parameter tag_width = 3)
(
	input clk, WE, RE, flush,
	input logic [w-1:0] value_in,
	input logic busy_in,
	input [tag_width - 1:0] tag_in,
	input [2**n-1:0] inst_in,
	input logic valid_in,
	input ld_value, ld_busy, ld_tag, ld_inst, ld_valid,
	input [w-1:0] addr_in,
	output logic [w-1:0] value_out,
	output logic busy_out,
	output logic[tag_width - 1:0]  tag_out,
	output logic[2**n-1:0]  inst_out,
	output logic valid_out,
	output logic empty, full
);

logic [n-1:0] r_addr, w_addr;
logic [w-1:0] value [2**n-1:0];
logic [w-1:0] tag[tag_width-1:0];
logic [w-1:0] inst[2**n-1:0];
logic [w-1:0] valid;
logic [w-1:0] busy;

assign empty = (r_addr == w_addr);
assign full = (r_addr == (w_addr + 1));

assign value_out = value[r_addr];
assign busy_out = busy[r_addr];
assign inst_out = inst[r_addr];
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
			inst[i] <= 0;
			valid[i] <= 1'b0;
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
					valid[i] <= 1'b0;
				end	
		end
	if(WE)
	begin: Write
		if(~full)
		begin
			value[w_addr] <= value_in;
			busy[w_addr] <= busy_in;
			tag[w_addr] <= tag_in;
			inst[w_addr] <= inst_in;
			valid[w_addr] <= 1'b1;
			w_addr <= w_addr + 8'b1;
		end
	end		
	else 
		begin
			if(ld_value)
				value[addr_in] <= value_in;
			if(ld_busy)
				busy[addr_in] <= busy_in;
			if(ld_tag)
				tag[addr_in] <= tag_in;
			if(ld_inst)
				inst[addr_in] <= inst_in;
			if(ld_valid)
				valid[addr_in] <= valid_in;
		end
	if(RE)
	begin
		valid[r_addr] <= 1'b0;
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
