import lc3b_types::*;


module L2_cache
(
	input clk,

	 /* Memory signals */
	/* L1 to L2 */
	 input mem_read, 
	 input mem_write,
	 input lc3b_word mem_address,
	 input pmem_L1_bus mem_wdata,
	 /* L2 to L1 */
	 output logic mem_resp, 
	 output pmem_L1_bus mem_rdata,
	 
	 /* cache to pmem*/
	 output lc3b_word pmem_address,
	 output pmem_read, pmem_write,
	 output pmem_bus pmem_wdata,
	 
	 /* pmem to cache */
	 input pmem_bus pmem_rdata,
	 input pmem_resp
);

logic valid_in, cache_allocate;
logic datain_mux_sel, write_enable, cache_hit;
logic dirty_datain, pmem_address_sel;
logic dirtyout;
logic addr_reg_load, evict_allocate;

L2_cache_datapath L2_datapath(.*);

L2_cache_control L2_control (.*);

endmodule: L2_cache
