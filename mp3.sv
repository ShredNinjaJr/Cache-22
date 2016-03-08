import lc3b_types::*;
import cache_types::*;
module mp3
(
	input clk,
	output lc3b_word pmem_address,
	input pmem_bus pmem_rdata,
	output pmem_bus pmem_wdata,
	input pmem_resp,
	output pmem_read, pmem_write
);



 /* Memory signals */
 logic mem_resp;
 lc3b_word mem_rdata;
 logic mem_read;
 logic mem_write;
 lc3b_mem_wmask mem_byte_enable;
 lc3b_word mem_address;
 lc3b_word mem_wdata;
 
 
 cpu cpu(.*);
 
 cache cache(.*);
 
 endmodule: mp3