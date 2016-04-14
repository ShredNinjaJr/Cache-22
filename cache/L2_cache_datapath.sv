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
 input pmem_L1_bus mem_wdata
);


/* wires */
L2cache_tag tag;
L2cache_index index;
//dcache_offset offset;

pmem_bus datain_mux_out;
pmem_bus data0_out, data1_out;
L2cache_tag tag0_out, tag1_out;
logic valid0_out, valid1_out;

logic way_match;
L2cache_tag tag_mux_out;

assign tag = mem_address[15 -: $size(tag)];
assign index = mem_address[(15 - $size(tag)) -: $size(index)];


/* Write decoder */
logic write_decoder_out0, write_decoder_out1;
logic lru_dataout;

write_decoder write_decoder 
(
	.allocate(cache_allocate), .way_match, .lru_dataout,
       	.enable(write_enable), 
	.out0(write_decoder_out0), .out1(write_decoder_out1)
);


mux2 #(.width($size(lc3b_word))) pmem_addr_mux 
(
	.sel(pmem_address_sel), 
	.a(mem_address), .b({tag_mux_out, index, 4'b0}), 
	.f(pmem_address)
);

mux2 #(.width($size(L2cache_tag))) tag_mux
(
	.sel(lru_dataout),
	.a(tag0_out), .b(tag1_out),
	.f(tag_mux_out)
);



pmem_bus data_writeout;
assign data_writeout = mem_wdata;

mux2 #(.width($size(pmem_bus))) datain_mux (.sel(datain_mux_sel), .a(pmem_rdata), .b(data_writeout), .f(datain_mux_out));

array  #(.width($size(pmem_bus)), .index_width($size(L2cache_index))) data_array0
(
  .clk, .index, 
  .datain(datain_mux_out), .dataout(data0_out),
  .write(write_decoder_out0)
 );
 
 array #(.width($size(pmem_bus)), .index_width($size(L2cache_index))) data_array1
(
  .clk, .index, 
  .datain(datain_mux_out), .dataout(data1_out),
  .write(write_decoder_out1)
);


mux2 #(.width($size(pmem_bus))) mem_rdatamux (.sel (way_match),.b(data1_out), .a(data0_out), .f(mem_rdata));

/* Tag array */
array #(.width($size(tag)), .index_width($size(L2cache_index))) tag_array0
(
  .clk, .index, 
  .datain(tag), .dataout(tag0_out),
  .write(write_decoder_out0)
);

array #(.width($size(tag)), .index_width($size(L2cache_index))) tag_array1
(
  .clk, .index, 
  .datain(tag), .dataout(tag1_out),
  .write(write_decoder_out1)
);


/* Valid array */
array #(.width(1), .index_width($size(L2cache_index))) valid_array0
(
  .clk, .index, 
  .datain(valid_in), .dataout(valid0_out),
  .write(write_decoder_out0)
);

array #(.width(1), .index_width($size(L2cache_index))) valid_array1
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
array #(.width(1), .index_width($size(L2cache_index))) lru_array
(
  .clk, .index, 
  .datain(~way_match), .dataout(lru_dataout),
  .write((d_lru_write & ~q_lru_write))
);

logic dirty1_out, dirty0_out;

/* Dirty Arrays */
array #(.width(1), .index_width($size(L2cache_index))) dirty_array0
(
	.clk, .index,
	.datain(dirty_datain), .dataout(dirty0_out),
	.write(write_decoder_out0)
);
array #(.width(1), .index_width($size(L2cache_index))) dirty_array1
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

mux2 #(.width($size(pmem_bus))) pmem_mux
(
	.a(data0_out), .b(data1_out),
	.f(pmem_wdata),
	.sel((cache_hit)? way_match : lru_dataout)
);

always_ff @(posedge clk)
begin
	q_lru_write <= d_lru_write;
end


endmodule: L2_cache_datapath
