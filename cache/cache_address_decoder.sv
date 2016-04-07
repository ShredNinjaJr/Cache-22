import lc3b_types::*;

module L1_cache_address_decoder #(parameter tag_size, parameter index_size, parameter offset_size)
( 
	input lc3b_word mem_address,
	output logic [tag_size-1:0] tag,
	output logic [index_size-1:0] index,
	output logic [offset_size-1:0] offset
);


assign tag = mem_address [15:7];
assign index = mem_address [6:4];
assign offset = mem_address [3:1];


endmodule : L1_cache_address_decoder