
import lc3b_types::*;

module icache_datapath
(
 input clk,
 input mem_read, 
 input lc3b_word mem_address,
 output lc3b_word mem_rdata,
 output lc3b_word pmem_address, 
 input pmem_bus pmem_rdata,
 
 output logic cache_hit,
 input write_enable 
);


/* wires */
icache_tag tag;
icache_index index;
icache_offset offset;

pmem_bus data_out;
icache_tag tag_out;
logic valid_out;

assign pmem_address = mem_address;
/* Decode address */
L1_cache_address_decoder #(.tag_size($size(icache_tag)),.index_size($size(icache_index)), 
						.offset_size($size(icache_offset)))address_decoder(.*);



array  #(.width($size(pmem_bus)), .index_width($size(icache_index))) data_array
(
  .clk, .index, 
  .datain(pmem_rdata), .dataout(data_out),
  .write(write_enable)
 );
 
word_decoder  #(.offset_size($size(icache_offset))) 
		wd(.offset, .datain(data_out), .dataout(mem_rdata));

/* Tag array */
array #(.width($size(tag)), .index_width($size(icache_index))) tag_array
(
  .clk, .index, 
  .datain(tag), .dataout(tag_out),
  .write(write_enable)
);


array #(.width(1), .index_width($size(icache_index))) valid_array
(
  .clk, .index, 
  .datain(1'b1), .dataout(valid_out),
  .write(write_enable)
);


/*Cache hit detection */
assign cache_hit = valid_out & (tag_out == tag);


endmodule: icache_datapath
