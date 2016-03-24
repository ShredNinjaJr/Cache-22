import lc3b_types::*;

module L1_icache
(
	 input clk,

	 /* Memory signals */
	/* cpu to cache */
	 input mem_read,
	 input lc3b_word mem_address,
	 /* Cache to cpu */
	 output logic mem_resp,
	 output lc3b_word mem_rdata,
	 
	 /* cache to pmem*/
	 output lc3b_word pmem_address,
	 output logic pmem_read,
	 
	 /* pmem to cache */
	 input pmem_bus pmem_rdata,
	 input pmem_resp	 
);

logic write_enable, cache_hit;
icache_datapath cache_datapath(.*);
icache_control cache_control(.*);



endmodule: L1_icache