import lc3b_types::*;

module reorder_buffer_data #(parameter data_width = 16, parameter tag_width = 3)
(
	input clk, WE, RE, flush,
	
	input lc3b_opcode	inst_in,
	input lc3b_reg dest_in,
	input logic valid_in,
	input logic [data_width-1:0] value_in,
	input logic predict_in,
	
	input ld_value, ld_dest, ld_inst, ld_valid, ld_predict,
	input [tag_width-1:0] addr_in,

	output lc3b_opcode inst_out,
	output lc3b_reg dest_out,
	output logic valid_out,
	output logic [data_width-1:0] value_out,
	output logic predict_out,
	output [tag_width-1:0] addr_out,
	
	output logic empty, full
);

logic [tag_width-1:0] r_addr, w_addr;
logic [data_width-1:0] value [2**tag_width-1:0];
logic [tag_width-1:0] dest	[2**tag_width-1:0];
lc3b_opcode inst [2**tag_width-1:0];
logic valid [2**tag_width - 1:0];
logic predict [2**tag_width - 1:0];
logic [tag_width - 1:0] temp;

assign temp= w_addr + 1;

assign empty = (r_addr == w_addr);
assign full = (r_addr == temp);

assign value_out = value[r_addr];
assign inst_out = inst[r_addr];
assign dest_out = dest[r_addr];
assign valid_out = valid[r_addr];
assign predict_out = predict[r_addr];

assign addr_out = w_addr;

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
	end
end


always_ff @(posedge clk)
begin	
	if(flush)
		begin
			w_addr <= 0;
			for (int i = 0; i < 2**tag_width; i++)
				begin	
					valid[i] <= 1'b0;
				end	
		end
	if(WE)
	begin: Write
		if(~full)
		begin
			value[w_addr] <= value_in;
			dest[w_addr] <= dest_in;
			inst[w_addr] <= inst_in;
			valid[w_addr] <= 1'b0;
			predict[w_addr] <= predict_in;
			w_addr <= w_addr + 3'b1;
		end
	end		
	else 
		begin
			if(ld_value)
				value[addr_in] <= value_in;
			if(ld_dest)
				dest[addr_in] <= dest_in;
			if(ld_inst)
				inst[addr_in] <= inst_in;
			if(ld_valid)
				valid[addr_in] <= valid_in;
			if(ld_predict)
				predict[addr_in] <= predict_in;
		end
	if(RE)
	begin
		valid[r_addr] <= 1'b0;
	end
			
end

always_ff @ ( posedge clk)
begin : reading
	if(flush)
		begin
			r_addr <= 0;
		end
	if(RE)
	begin: Read
		if(~empty)
		begin
			r_addr <= r_addr + 3'b1;
		end
	end
end : reading

endmodule : reorder_buffer_data
