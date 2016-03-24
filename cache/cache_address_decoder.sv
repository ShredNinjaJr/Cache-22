import lc3b_types::*;
import L1_cache_types::*;


module cache_address_decoder
( 
	input lc3b_word mem_address,
	output cache_tag tag,
	output cache_index index,
	output cache_offset offset
);


assign tag = mem_address [15:7];
assign index = mem_address [6:4];
assign offset = mem_address [3:1];


endmodule : cache_address_decoder