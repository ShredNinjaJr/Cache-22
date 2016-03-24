import lc3b_types::*;

module L1_dcache
(
	 input clk,

	 /* Memory signals */
	/* cpu to cache */
	 input mem_read,
	 input mem_write,
	 input lc3b_mem_wmask mem_byte_enable,
	 input lc3b_word mem_address,
	 input lc3b_word mem_wdata,
	 /* Cache to cpu */
	 output logic mem_resp,
	 output lc3b_word mem_rdata,
	 
	 /* cache to pmem*/
	 output lc3b_word pmem_address,
	 output logic pmem_read, pmem_write,
	 output pmem_bus pmem_wdata,
	 
	 /* pmem to cache */
	 input pmem_bus pmem_rdata,
	 input pmem_resp	 
);


logic valid_in, cache_allocate;
logic datain_mux_sel, write_enable, cache_hit;
logic dirty_datain, pmem_address_sel;
logic dirtyout;
dcache_datapath cache_datapath(.*);
dcache_control cache_control(.*);



endmodule: L1_dcache