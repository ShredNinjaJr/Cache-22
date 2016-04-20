import lc3b_types::*;

module cache_arbiter
(
	input clk,
	/* Pmem to Arbiter */
	input pmem_resp,
	input pmem_L1_bus pmem_rdata,
	
	/* Cache to Arbiter */
	input lc3b_word imem_address, dmem_address,
	input dmem_write, dmem_read, imem_read,
	input pmem_L1_bus dmem_wdata,
	
	/* Arbiter to Cache */
	output logic imem_resp, dmem_resp,
	output pmem_L1_bus imem_rdata, dmem_rdata,
	
	
	/* Arbiter to pmem */
	output pmem_L1_bus pmem_wdata,
	output logic pmem_read, pmem_write,
	output lc3b_word pmem_address
);

enum logic {I, D} state, next_state;
initial
begin
	state = I;
end

/* Datapath */
lc3b_word pmem_address_mux_out;

/* Arbiter to pmem */
always_ff @ (posedge clk)
begin
	pmem_wdata <= dmem_wdata;
	pmem_write <= dmem_write & (state == D);
	pmem_read <= (state == I) ? imem_read : dmem_read;
	
	pmem_address <= pmem_address_mux_out;
	/* Arbiter to Cache */
	imem_rdata <= pmem_rdata;
	dmem_rdata <= pmem_rdata;
	
	if(state == I)
		imem_resp <= pmem_resp;
	else
		imem_resp <= 0;
	if(state == D)
		dmem_resp <= pmem_resp;
	else
		dmem_resp <= 0;
end
mux2 #(.width($size(lc3b_word))) pmem_address_mux
(
	.sel((state == I)), 
	.a(dmem_address), .b(imem_address),
	.f(pmem_address_mux_out)
);





/* State machine */

/* Next state logic*/
always_comb
begin
	next_state = state;
	case(state)
	I: begin
		if(~imem_read)
			next_state = D;
	end
	D: begin
		if(imem_read & ~(dmem_read | dmem_write))
			next_state = I;
	end
	
	endcase
end

always_ff @(posedge clk)
begin
	state <= next_state;
end


endmodule:cache_arbiter
