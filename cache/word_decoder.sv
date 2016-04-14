import lc3b_types::*;

/* A giant mux */
module word_decoder #(parameter offset_size)
(
	input [offset_size-1:0] offset,
	input pmem_L1_bus datain,
	output lc3b_word dataout
);

always_comb
begin
	dataout = datain[16*(offset) +:16 ];
end



endmodule: word_decoder

