/* Upper level cache module that contains all caches */
import lc3b_types::*;

module cache
(
	 input clk,

	 /* Memory signals */
	/* Cache to pmem */
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
	 output pmem_bus pmem_wdata,
	 
	 /* pmem to cache */
	 input pmem_bus pmem_rdata,
	 input pmem_resp	
);


logic L2_mem_read, L2_mem_write;
lc3b_word L2_mem_address;
pmem_L1_bus L2_mem_wdata, L2_mem_rdata;
logic L2_mem_resp;

L1_cache L1_cache
(
	 .clk,

	 /* Memory signals */
	/* CPU  to L1 */
	 .imem_read, .dmem_read,
	 .dmem_write,
	 .dmem_byte_enable,
	 .dmem_address, .imem_address,
	 .dmem_wdata,
	 /* Cache to cpu */
	 .imem_resp, .dmem_resp,
	 .imem_rdata, .dmem_rdata,
	 
	 /* L1 to L2*/
	 .pmem_address(L2_mem_address),
	 .pmem_read(L2_mem_read), .pmem_write(L2_mem_write),
	 .pmem_wdata(L2_mem_wdata),
	 
	 /* L2 to L1 */
	 .pmem_rdata(L2_mem_rdata),
	 .pmem_resp(L2_mem_resp)
);

L2_cache L2_cache
(
	.clk,
	 /* Memory signals */
	/* L1 to L2 */
	 .mem_read(L2_mem_read), 
	 .mem_write(L2_mem_write),
	 .mem_address(L2_mem_address),
	 .mem_wdata(L2_mem_wdata),
	 /* L2 to L1 */
	 .mem_resp(L2_mem_resp), 
	 .mem_rdata(L2_mem_rdata),
	 
	 /* cache to pmem*/
	 .pmem_address,
	 .pmem_read, .pmem_write,
	 .pmem_wdata,
	 
	 /* pmem to cache */
	 .pmem_rdata,
	 .pmem_resp
);

endmodule: cache