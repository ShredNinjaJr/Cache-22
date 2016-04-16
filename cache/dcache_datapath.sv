import lc3b_types::*;

module dcache_datapath
(
 input clk,
 input lc3b_word mem_address,
 output lc3b_word pmem_address,
 output lc3b_word mem_rdata,
 input pmem_L1_bus pmem_rdata,
 output logic cache_hit,
 input valid_in,
 input datain_mux_sel,
 input mem_write, write_enable, mem_read, cache_allocate,
 input dirty_datain,
 input pmem_address_sel,
 output pmem_L1_bus pmem_wdata,
 output logic dirtyout,
 input lc3b_word mem_wdata,
 input lc3b_mem_wmask mem_byte_enable,
 
 input addr_reg_load,
 input evict_allocate
);


/* wires */
dcache_tag tag;
dcache_index index;
dcache_offset offset;

pmem_L1_bus datain_mux_out;
pmem_L1_bus data0_out, data1_out;
dcache_tag tag0_out, tag1_out;
logic valid0_out, valid1_out;
lc3b_word write_d0_out, write_d1_out;

logic way_match;
dcache_tag tag_mux_out;

logic [$size(dcache_offset) : 0] temp_offset = 0;

/* Write decoder */
logic write_decoder_out0, write_decoder_out1;
logic lru_dataout;

write_decoder write_decoder 
(
	.allocate(cache_allocate), .way_match, .lru_dataout,
       	.enable(write_enable), 
	.out0(write_decoder_out0), .out1(write_decoder_out1)
);

lc3b_word pmem_addr_reg;

always_ff @(posedge clk)
begin
	if(addr_reg_load)
		pmem_addr_reg <= mem_address;
end

mux2 #(.width($size(lc3b_word))) pmem_addr_mux 
(
	.sel(pmem_address_sel), 
	.a(pmem_addr_reg), .b({tag_mux_out, index, temp_offset}), 
	.f(pmem_address)
);

mux2 #(.width($size(dcache_tag))) tag_mux
(
	.sel(lru_dataout),
	.a(tag0_out), .b(tag1_out),
	.f(tag_mux_out)
);
/* Decode address */
L1_cache_address_decoder #(.tag_size($size(dcache_tag)),.index_size($size(dcache_index)), 
						.offset_size($size(dcache_offset)))address_decoder(.*, .mem_address((evict_allocate) ? pmem_addr_reg: mem_address));


pmem_L1_bus data_writeout;
/* Data array */
data_write data_write_module
(
	.*
);

mux2 #(.width($size(pmem_L1_bus))) datain_mux (.sel(datain_mux_sel), .a(pmem_rdata), .b(data_writeout), .f(datain_mux_out));

array  #(.width($size(pmem_L1_bus)), .index_width($size(dcache_index))) data_array0
(
  .clk, .index, 
  .datain(datain_mux_out), .dataout(data0_out),
  .write(write_decoder_out0)
 );
 
 array #(.width($size(pmem_L1_bus)), .index_width($size(dcache_index))) data_array1
(
  .clk, .index, 
  .datain(datain_mux_out), .dataout(data1_out),
  .write(write_decoder_out1)
);


word_decoder #(.offset_size($size(dcache_offset))) wd0(.offset, .datain(data0_out), .dataout(write_d0_out));
word_decoder #(.offset_size($size(dcache_offset))) wd1(.offset, .datain(data1_out), .dataout(write_d1_out));

mux2 mem_rdatamux (.sel (way_match),.b(write_d1_out), .a(write_d0_out), .f(mem_rdata));

/* Tag array */
array #(.width($size(tag)), .index_width($size(dcache_index))) tag_array0
(
  .clk, .index, 
  .datain(tag), .dataout(tag0_out),
  .write(write_decoder_out0)
);

array #(.width($size(tag)), .index_width($size(dcache_index))) tag_array1
(
  .clk, .index, 
  .datain(tag), .dataout(tag1_out),
  .write(write_decoder_out1)
);


/* Valid array */
array #(.width(1), .index_width($size(dcache_index))) valid_array0
(
  .clk, .index, 
  .datain(valid_in), .dataout(valid0_out),
  .write(write_decoder_out0)
);

array #(.width(1), .index_width($size(dcache_index))) valid_array1
(
  .clk, .index, 
  .datain(valid_in), .dataout(valid1_out),
  .write(write_decoder_out1)
);


/*Cache hit detection */
logic encoder_in0, encoder_in1;
assign encoder_in0 = (valid0_out & (tag0_out == tag));
assign encoder_in1 =(valid1_out & (tag1_out == tag));
assign cache_hit = encoder_in0 | encoder_in1 ;

encoder2 way_encoder (.in0(encoder_in0), .in1(encoder_in1), .out(way_match));

logic d_lru_write, q_lru_write;
assign d_lru_write = cache_hit & (mem_read | mem_write);

/* LRU replacement */
/* lru of 1 indicates 1 is LRU*/
array #(.width(1), .index_width($size(dcache_index))) lru_array
(
  .clk, .index, 
  .datain(~way_match), .dataout(lru_dataout),
  .write((d_lru_write & ~q_lru_write))
);

logic dirty1_out, dirty0_out;

/* Dirty Arrays */
array #(.width(1), .index_width($size(dcache_index))) dirty_array0
(
	.clk, .index,
	.datain(dirty_datain), .dataout(dirty0_out),
	.write(write_decoder_out0)
);
array #(.width(1), .index_width($size(dcache_index))) dirty_array1
(
	.clk, .index,
	.datain(dirty_datain), .dataout(dirty1_out),
	.write(write_decoder_out1)
);

mux2 #(.width(1)) dirty_mux
(
	.a(dirty0_out), .b(dirty1_out),
	.f(dirtyout),
	.sel(lru_dataout)
);

mux2 #(.width($size(pmem_L1_bus))) pmem_mux
(
	.a(data0_out), .b(data1_out),
	.f(pmem_wdata),
	.sel((cache_hit)? way_match : lru_dataout)
);

always_ff @(posedge clk)
begin
	q_lru_write <= d_lru_write;
end


endmodule: dcache_datapath
