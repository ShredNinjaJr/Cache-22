import lc3b_types::*;
import L1_cache_types::*;

/* A giant mux */
module word_decoder 
(
	input cache_offset offset,
	input pmem_bus datain,
	output lc3b_word dataout
);

always_comb
begin
	dataout = datain[16*(offset) +:16 ];
end



endmodule: word_decoder

