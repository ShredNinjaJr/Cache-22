import lc3b_types::*;

module ldstr_decoder #(parameter n = 7)
(
	input WE, RE, dmem_resp, dmem_read,
	
	/* RS wires */
	output logic issue_WE[0:n],
	output logic issue_ld_mem_val[0:n],
	output [2:0] r_addr
);

byte unsigned j;

logic [2:0] w_addr; 
logic [3:0] counter;
logic full, empty;

assign empty = (counter == 0);
assign full = (counter == n+1);

initial
begin
	r_addr <= 0;
	w_addr <= 0;
	counter <= 0;
end


always_ff @ ( posedge clk)
begin
	if(WE)
	begin: Write
		if(~full)
		begin
			counter <= counter + 1;
			w_addr <= w_addr + 3'b1;
		end
	end
end


always_ff @ ( posedge clk)
begin
	if(RE)
	begin: Read
		if(~empty)
		begin
			counter <= counter - 1;
			r_addr <= r_addr + 3'b1;
		end
	end
end

always_comb
begin

	for(j = 0; j <= n; j++)
	begin
		issue_WE[j] = 0;
		issue_ld_mem_val[j] = 0;
	end
	
	issue_WE[w_addr] = WE;
	issue_ld_mem_val[r_addr] = dmem_resp & dmem_read;
end

endmodule : ldstr_decoder
