import lc3b_types::*;

module L2_cache_address_decoder 
( 
	input lc3b_word mem_address,
	output L2cache_tag tag,
	output L2cache_index index,
	output L2cache_offset offset
);


assign tag = mem_address[15 -: $size(tag)];
assign index = mem_address[(15 - $size(tag)) -: $size(index)];
assign offset = mem_address[5];


endmodule : L2_cache_address_decoder