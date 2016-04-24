import lc3b_types::*;

module L2_cache_datapath
(
 input clk,
 input lc3b_word mem_address,
 output lc3b_word pmem_address,
 output pmem_L1_bus mem_rdata,
 input pmem_bus pmem_rdata,
 output logic cache_hit,
 input valid_in,
 input datain_mux_sel,
 input mem_write, write_enable, mem_read, cache_allocate,
 input dirty_datain,
 input pmem_address_sel,
 output pmem_bus pmem_wdata,
 output logic dirtyout,
 input pmem_L1_bus mem_wdata,
 input addr_reg_load,
 input evict_allocate
);


/* wires */
L2cache_tag tag;
L2cache_index index;
//dcache_offset offset;

pmem_bus datain_mux_out;
pmem_bus data0_out, data1_out, data2_out, data3_out;
L2cache_tag tag0_out, tag1_out, tag2_out, tag3_out;
logic valid0_out, valid1_out, valid2_out, valid3_out;

logic [1:0] way_match;
logic [1:0] lru_dataout;
logic [2:0] lru_datain, lru_data;

L2cache_tag tag_mux_out;
lc3b_word pmem_addr_reg;


assign tag = (evict_allocate) ? pmem_addr_reg[15 -: $size(tag)] : (mem_address[15 -: $size(tag)]);
assign index = (evict_allocate) ? pmem_addr_reg[(15 - $size(tag)) -: $size(index)]: (mem_address[(15 - $size(tag)) -: $size(index)]);


/* Write decoder */
logic write_decoder_out0, write_decoder_out1, write_decoder_out2, write_decoder_out3;


L2_write_decoder write_decoder 
(
	.allocate(cache_allocate), .way_match, .lru_d(lru_data),
       	.enable(write_enable), 
	.out0(write_decoder_out0), .out1(write_decoder_out1), .out2(write_decoder_out2), .out3(write_decoder_out3)
);




always_ff @(posedge clk)
begin
	if(addr_reg_load)
		pmem_addr_reg <= mem_address;
end

mux2 #(.width($size(lc3b_word))) pmem_addr_mux 
(
	.sel(pmem_address_sel), 
	.a(pmem_addr_reg), .b({tag_mux_out, index, 4'b0}), 
	.f(pmem_address)
);

mux4 #(.width($size(L2cache_tag))) tag_mux
(
	.sel(lru_dataout),
	.a(tag0_out), .b(tag1_out), .c(tag2_out), .d(tag3_out),
	.f(tag_mux_out)
);



pmem_bus data_writeout;
assign data_writeout = mem_wdata;

mux2 #(.width($size(pmem_bus))) datain_mux (.sel(datain_mux_sel), .a(pmem_rdata), .b(data_writeout), .f(datain_mux_out));

l2_array  #(.width($size(pmem_bus)), .index_width($size(L2cache_index))) data_l2_array0
(
  .clk, .index, 
  .datain(datain_mux_out), .dataout(data0_out),
  .write(write_decoder_out0)
 );
 
 l2_array #(.width($size(pmem_bus)), .index_width($size(L2cache_index))) data_l2_array1
(
  .clk, .index, 
  .datain(datain_mux_out), .dataout(data1_out),
  .write(write_decoder_out1)
);

l2_array  #(.width($size(pmem_bus)), .index_width($size(L2cache_index))) data_l2_array2
(
  .clk, .index, 
  .datain(datain_mux_out), .dataout(data2_out),
  .write(write_decoder_out2)
 );
 
 l2_array #(.width($size(pmem_bus)), .index_width($size(L2cache_index))) data_l2_array3
(
  .clk, .index, 
  .datain(datain_mux_out), .dataout(data3_out),
  .write(write_decoder_out3)
);

mux4 #(.width($size(pmem_bus))) mem_rdatamux 
(
	.sel (way_match),
	.b(data1_out), .a(data0_out), .c(data2_out), .d(data3_out),
	.f(mem_rdata)
);

/* Tag l2_array */
l2_array #(.width($size(tag)), .index_width($size(L2cache_index))) tag_l2_array0
(
  .clk, .index, 
  .datain(tag), .dataout(tag0_out),
  .write(write_decoder_out0)
);

l2_array #(.width($size(tag)), .index_width($size(L2cache_index))) tag_l2_array1
(
  .clk, .index, 
  .datain(tag), .dataout(tag1_out),
  .write(write_decoder_out1)
);

l2_array #(.width($size(tag)), .index_width($size(L2cache_index))) tag_l2_array2
(
  .clk, .index, 
  .datain(tag), .dataout(tag2_out),
  .write(write_decoder_out2)
);

l2_array #(.width($size(tag)), .index_width($size(L2cache_index))) tag_l2_array3
(
  .clk, .index, 
  .datain(tag), .dataout(tag3_out),
  .write(write_decoder_out3)
);


/* Valid l2_array */
l2_array #(.width(1), .index_width($size(L2cache_index))) valid_l2_array0
(
  .clk, .index, 
  .datain(valid_in), .dataout(valid0_out),
  .write(write_decoder_out0)
);

l2_array #(.width(1), .index_width($size(L2cache_index))) valid_l2_array1
(
  .clk, .index, 
  .datain(valid_in), .dataout(valid1_out),
  .write(write_decoder_out1)
);

l2_array #(.width(1), .index_width($size(L2cache_index))) valid_l2_array2
(
  .clk, .index, 
  .datain(valid_in), .dataout(valid2_out),
  .write(write_decoder_out2)
);

l2_array #(.width(1), .index_width($size(L2cache_index))) valid_l2_array3
(
  .clk, .index, 
  .datain(valid_in), .dataout(valid3_out),
  .write(write_decoder_out3)
);


/*Cache hit detection */
logic encoder_in0, encoder_in1, encoder_in2, encoder_in3;
assign encoder_in0 = (valid0_out & (tag0_out == tag));
assign encoder_in1 =(valid1_out & (tag1_out == tag));
assign encoder_in2 = (valid2_out & (tag2_out == tag));
assign encoder_in3 =(valid3_out & (tag3_out == tag));
assign cache_hit = encoder_in0 | encoder_in1 | encoder_in2| encoder_in3;

encoder4 way_encoder 
(
	.in0(encoder_in0), .in1(encoder_in1), .in2(encoder_in2), .in3(encoder_in3),
	.out(way_match)
);

logic d_lru_write, q_lru_write;
assign d_lru_write = cache_hit & (mem_read | mem_write) & evict_allocate;

/* LRU replacement */
/* lru of 1 indicates 1 is LRU*/
L2_lru_update lru_update (.*);

l2_array #(.width(3), .index_width($size(L2cache_index))) lru_l2_array
(
  .clk, .index, 
  .datain(lru_datain), .dataout(lru_data),
  .write((d_lru_write & ~q_lru_write))
);

logic dirty0_out, dirty1_out, dirty2_out, dirty3_out;

/* Dirty l2_arrays */
l2_array #(.width(1), .index_width($size(L2cache_index))) dirty_l2_array0
(
	.clk, .index,
	.datain(dirty_datain), .dataout(dirty0_out),
	.write(write_decoder_out0)
);
l2_array #(.width(1), .index_width($size(L2cache_index))) dirty_l2_array1
(
	.clk, .index,
	.datain(dirty_datain), .dataout(dirty1_out),
	.write(write_decoder_out1)
);

l2_array #(.width(1), .index_width($size(L2cache_index))) dirty_l2_array2
(
	.clk, .index,
	.datain(dirty_datain), .dataout(dirty2_out),
	.write(write_decoder_out2)
);
l2_array #(.width(1), .index_width($size(L2cache_index))) dirty_l2_array3
(
	.clk, .index,
	.datain(dirty_datain), .dataout(dirty3_out),
	.write(write_decoder_out3)
);

mux4 #(.width(1)) dirty_mux
(
	.a(dirty0_out), .b(dirty1_out), .c(dirty2_out), .d(dirty3_out),
	.f(dirtyout),
	.sel(lru_dataout)
);

mux4 #(.width($size(pmem_bus))) pmem_mux
(
	.a(data0_out), .b(data1_out), .c(data2_out), .d(data3_out),
	.f(pmem_wdata),
	.sel((cache_hit)? way_match : lru_dataout)
);

always_ff @(posedge clk)
begin
	q_lru_write <= d_lru_write;
end


endmodule: L2_cache_datapath
