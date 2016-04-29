import lc3b_types::*;


module L2_data_write
(
	input pmem_L1_bus mem_wdata,
	input pmem_bus pmem_wdata,
	input L2cache_offset offset,
	output pmem_bus data_writeout
);


always_comb
begin

	data_writeout = pmem_wdata;
	
	if(offset)
		data_writeout[255:128] = mem_wdata;
	else
		data_writeout[127:0] = mem_wdata;

end



endmodule: L2_data_write
