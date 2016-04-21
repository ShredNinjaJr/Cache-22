mport lc3b_types::*;

module branch_target_buffer #(parameter num_entries = 10)
(
	input clk,
	
	/* input */
	input lc3b_word pc,
	input lc3b_word bta_in,
	input valid_in,
	input predict_in,
	
	input lc3b_word wr_addr,
	
	/* load signals */
	input ld_valid,
	input ld_tag,
	input ld_data,
	input ld_predict,
	
	/* output signals */
	output hit,
	output lc3b_word bta_out,
	output predict_out
	
);

btb_tag branch_tag;
btb_index branch_index;

assign branch_tag = pc[15:5];
assign branch_index = pc[4:1];

assign hit = (branch_tag == tag_out) & valid_out;

/* Valid array */
array #(.width(num_entries), .index_width(1)) valid_array
(
  .clk, 
  .index(branch_index), 
  .datain(valid_in), .dataout(valid_out),
  .write(ld_valid)
);

/* Tag array */
array #(.width(num_entries), .index_width($size(btb_tag))) tag_array
(
  .clk,
  .index(branch_index),
  .datain(branch_tag), .dataout(tag_out),
  .write(ld_tag)
);

/* Data array */
array  #(.width(num_entries), .index_width($size(lc3b_word))) data_array
(
  .clk,
  .index(branch_index),
  .datain(bta_in), .dataout(bta_out),
  .write(ld_data)
);

/* Prediction array */
array  #(.width(num_entries), .index_width(1)) predict_array
(
  .clk,
  .index(branch_index),
  .datain(predict_in), .dataout(predict_out),
  .write(ld_predict)
 );
 
 

endmodule: branch_target_buffer