
module ldstr_decoder #(parameter n = 7)
(
	input clk, flush,
	input WE, RE, dmem_resp, dmem_read,
	
	/* RS wires */
	output logic issue_WE[0:n],
	output logic issue_flush[0:n],
	output logic issue_ld_mem_val[0:n],
	output [1:0] r_addr_out,
	output logic full
);

byte unsigned j;
logic [1:0] r_addr;
logic [1:0] w_addr; 
logic [2:0] counter;
logic empty;

assign empty = (counter == 0);
assign full = (counter == n+1);
assign r_addr_out = r_addr;

initial
begin
	r_addr <= 0;
	w_addr <= 0;
	counter <= 0;
end


always_ff @( posedge clk)
begin: count_logic
	if(flush)
		counter <= 0;
	else
	begin
		if(RE & ~WE)
			counter <= counter - 3'b1;
		else if(WE & ~RE)
		begin
			if(~full)
				counter <= counter + 3'b1;
		end
	end
end



always_ff @ ( posedge clk)
begin
	if(flush)
	begin
		r_addr <= 0;
		w_addr <= 0;
	end
	else
	begin
		if(WE)
		begin: Write
			if(~full)
			begin
				w_addr <= w_addr + 2'b1;
			end
		end: Write
		
		if(RE)
		begin: Read
			if(~empty)
			begin
				r_addr <= r_addr + 2'b1;
			end
		end: Read
	end
end

always_comb
begin

	for(j = 0; j <= n; j++)
	begin
		issue_WE[j] = 0;
		issue_flush[j] = 0;
		issue_ld_mem_val[j] = 0;
	end
	
	if(RE)
		issue_flush[r_addr] = 1'b1;
	
	issue_WE[w_addr] = WE;
	issue_ld_mem_val[r_addr] = dmem_resp & dmem_read;
end

endmodule : ldstr_decoder
