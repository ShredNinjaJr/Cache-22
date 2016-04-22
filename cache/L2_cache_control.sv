module L2_cache_control
(
 input clk,
 input mem_read,
 input mem_write,
 output logic pmem_read, pmem_write,
 output logic mem_resp, 
 input pmem_resp,
 output logic datain_mux_sel, write_enable, valid_in,
 input cache_hit, dirtyout,
 output logic cache_allocate,
 output logic dirty_datain,
 output logic pmem_address_sel,
 output logic addr_reg_load,
 output logic evict_allocate
);

enum logic[1:0] {
    /* List of states */
	 HIT, EVICT, ALLOCATE
} state, next_state;

initial state = HIT;

always_comb
begin: state_actions

/* Default output values */
    datain_mux_sel = 0;
    pmem_read = 0;
    pmem_write = 0;
    write_enable = 0;
	 valid_in = 0;
	 mem_resp = 0;
	 cache_allocate = 0;
	 dirty_datain = 0;
	 pmem_address_sel = 0;
	 evict_allocate = 0;
    /*State actions */
    unique case(state)

	    HIT: begin
			 if(cache_hit)
			 begin
				 if((mem_read))
				 begin
					dirty_datain = dirtyout;
				 end
						
				 else if(mem_write)  
				 begin
						write_enable = 1;
						dirty_datain = 1;
						datain_mux_sel = 1;
						valid_in = 1;
				 end
				 mem_resp = 1;
			 end

	    end

	    ALLOCATE: begin
	      pmem_read = 1;
			if(pmem_resp)
			begin
				valid_in = 1;
				write_enable = 1;
				cache_allocate = 1;
			end
			evict_allocate = 1;
		 end
		 
		 EVICT: begin
			evict_allocate = 1;
			pmem_address_sel = 1;
			valid_in = 0;
			pmem_write = 1;
		 end
		 default: ;
    endcase


end: state_actions


always_comb
begin: next_state_logic
	
	next_state = state;
	addr_reg_load = 0;
	case(state)
	HIT: begin
	if(mem_resp == 0)
		begin
			 if(mem_read | mem_write)
			 begin
				if(dirtyout)
					next_state = EVICT;
				else
					next_state = ALLOCATE;
				addr_reg_load = 1;
			 end
			
		end
	end
	ALLOCATE: begin
		if(pmem_resp)
			 next_state = HIT;
	end
	
	EVICT: begin
		if(pmem_resp)
			next_state = ALLOCATE;
	end
	default: ;
	endcase	

end: next_state_logic

logic [31:0] l2_miss_count;
initial l2_miss_count = 0;

always_ff @(posedge clk)
begin
	state <= next_state;
	
	if((next_state == ALLOCATE) & (state != ALLOCATE))
		l2_miss_count <= l2_miss_count + 1;
end

endmodule: L2_cache_control
