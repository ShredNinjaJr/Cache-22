import lc3b_types::*;
import cache_types::*;

module data_write
(
	input logic [1:0] mem_byte_enable,
	input lc3b_word mem_wdata,
	input pmem_bus pmem_wdata,
	input cache_offset offset,
	output pmem_bus data_writeout
);


always_comb
begin

	data_writeout = pmem_wdata;
	
	if(mem_byte_enable[0])
		data_writeout[16*offset +: 8] = mem_wdata[7:0];
	
	if(mem_byte_enable[1])
		data_writeout[(16*offset + 8) +: 8] = mem_wdata[15:8];

end



endmodule: data_write
