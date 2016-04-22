import lc3b_types::*;


module L1_cache
(
	 input clk,

	 /* Memory signals */
	/* CPU to cache */
	 input imem_read, dmem_read,
	 input dmem_write,
	 input lc3b_mem_wmask dmem_byte_enable,
	 input lc3b_word dmem_address, imem_address,
	 input lc3b_word dmem_wdata,
	 /* Cache to cpu */
	 output logic imem_resp, dmem_resp,
	 output lc3b_word imem_rdata, dmem_rdata,
	 
	 /* cache to pmem*/
	 output lc3b_word pmem_address,
	 output pmem_read, pmem_write,
	 output pmem_L1_bus pmem_wdata,
	 
	 /* pmem to cache */
	 input pmem_L1_bus pmem_rdata,
	 input pmem_resp	 
);

	logic d_pmem_write, d_pmem_read, i_pmem_read;
	lc3b_word d_pmem_address, i_pmem_address;
	pmem_L1_bus d_pmem_wdata;
	pmem_L1_bus d_pmem_rdata, i_pmem_rdata;
	logic d_pmem_resp, i_pmem_resp;

L1_dcache dcache
(
	 .clk,
	 .mem_read(dmem_read),
	 .mem_write(dmem_write),
	 .mem_byte_enable(dmem_byte_enable),
	 .mem_address(dmem_address),
	 .mem_wdata(dmem_wdata),
	 /* Cache to cpu */
	 .mem_resp(dmem_resp),
	 .mem_rdata(dmem_rdata),
	 
	 /* cache to pmem*/
	 .pmem_address(d_pmem_address),
	 .pmem_write(d_pmem_write),
	 .pmem_read(d_pmem_read),
	 .pmem_wdata(d_pmem_wdata),
	 
	 /* pmem to cache */
	 .pmem_rdata(d_pmem_rdata),
	 .pmem_resp(d_pmem_resp)	
);

L1_icache icache
(
	 .clk,
	 .mem_read(imem_read),
	 .mem_address(imem_address),
	 /* Cache to cpu */
	 .mem_resp(imem_resp),
	 .mem_rdata(imem_rdata),
	 
	 /* cache to pmem*/
	 .pmem_address(i_pmem_address),
	 .pmem_read(i_pmem_read),
	 
	 /* pmem to cache */
	 .pmem_rdata(i_pmem_rdata),
	 .pmem_resp(i_pmem_resp)
);

cache_arbiter arbiter
(
   .clk,
	/* Pmem to Arbiter */
	.pmem_resp,
	.pmem_rdata,
	
	/* Cache to Arbiter */
	.imem_address(i_pmem_address), .dmem_address(d_pmem_address),
	.dmem_write(d_pmem_write), .dmem_read(d_pmem_read), .imem_read(i_pmem_read),
	.dmem_wdata(d_pmem_wdata),
	
	/* Arbiter to Cache */
	.imem_resp(i_pmem_resp), .dmem_resp(d_pmem_resp),
	.imem_rdata(i_pmem_rdata), .dmem_rdata(d_pmem_rdata),
	
	
	/* Arbiter to pmem */
	.pmem_wdata,
	.pmem_read, .pmem_write,
	.pmem_address
);



endmodule: L1_cache