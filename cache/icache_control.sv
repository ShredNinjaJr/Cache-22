module icache_control
(
 input clk,
 input mem_read,
 output logic pmem_read,
 output logic mem_resp, 
 input pmem_resp,
 output logic write_enable, 
 output logic addr_reg_load,
 input cache_hit,
 output logic evict_allocate
);

enum logic {HIT, ALLOCATE} state, next_state;
initial
begin
	state = HIT;
end
always_comb
begin: state_actions

/* Default output values */
    pmem_read = 0;
    write_enable = 0;
	 mem_resp = 0;
	 evict_allocate = 0;
    /*State actions */
    unique case(state)

	    HIT: begin
			 if(cache_hit)
				 mem_resp = mem_read;
	    end

	    ALLOCATE: begin
	      pmem_read = 1;
			if(pmem_resp)
				write_enable = 1;
			
			evict_allocate = 1;
		 end
    endcase

end: state_actions


always_comb
begin: next_state_logic
	next_state = state;
	addr_reg_load = 0;
	case (state)
	HIT: begin
		if(~cache_hit & mem_read)
		begin
			next_state = ALLOCATE;
			addr_reg_load = 1;
		end
	end
	ALLOCATE: begin
		if(pmem_resp)
			next_state = HIT;
	end	
	endcase

	
	
end: next_state_logic

logic [31:0] icache_miss_count;
initial icache_miss_count = 0;

always_ff @(posedge clk)
begin
	state <= next_state;
	
	if(next_state == ALLOCATE)
		icache_miss_count <= icache_miss_count + 1;
end

endmodule: icache_control
