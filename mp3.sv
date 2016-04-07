import lc3b_types::*;

module mp3
(
	input clk,
	output lc3b_word pmem_address,
	input pmem_bus pmem_rdata,
	output pmem_bus pmem_wdata,
	input pmem_resp,
	output pmem_read, pmem_write
);

lc3b_word imem_rdata,dmem_rdata;
lc3b_word imem_address, dmem_address;
logic imem_read,dmem_read,dmem_write;
logic imem_resp, dmem_resp;
lc3b_mem_wmask dmem_byte_enable;
lc3b_word dmem_wdata;

cpu_datapath cpu_datapath(.*);

cache cache(.*);

endmodule: mp3