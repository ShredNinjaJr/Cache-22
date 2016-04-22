import lc3b_types::*;

module ldstr_buffer #(parameter data_width = 16, parameter tag_width = 3, parameter n = 3)
(
	input clk, flush, WE, ld_buffer_read, wr_RE_out,
	input lc3b_opcode opcode_in,
	
	input dmem_resp, 
	input lc3b_word dmem_rdata,

	input Vsrc_valid_in, Vbase_valid_in,
	input [data_width-1:0] Vbase, Vsrc, offset_in,
	input [tag_width-1:0] Qbase, Qsrc, dest,
	input CDB CDB_in,
	
	output dmem_read,
	output lc3b_word dmem_wdata, dmem_addr,
	output lc3b_mem_wmask dmem_byte_enable,
	
	output logic full,
	output CDB CDB_out
);

lc3b_word mem_val_in;

/* Decoder unit */
ldstr_decoder #(.n(n)) LD_STR_decoder (.*);

/* RS wires */
logic issue_WE[0:n];
logic issue_flush[0:n];
logic issue_ld_mem_val[0:n];
logic RE;
logic [1:0] r_addr_out;

logic Vsrc_valid_output[0:n];
logic Vbase_valid_output[0:n];

lc3b_word datamem_addr[0:n];
logic datamem_write[0:n]; 
logic datamem_read[0:n];
lc3b_word datamem_wdata[0:n];
lc3b_mem_wmask datamem_byte_enable[0:n];

CDB LD_STR_CDB_out[0:n];

/* Generate the RS */
genvar i;
generate for(i = 0; i <= n; i++)
begin: RS_generate
	cdb_ld_str_res_station RS
	(
		.clk,
		.flush(issue_flush[i] | flush),
		.WE(issue_WE[i]),
		.ld_mem_val(issue_ld_mem_val[i]),
		.opcode_in,
		.CDB_in,
		.Vsrc_valid_in,
		.Vbase_valid_in,
		.Vbase, .Vsrc, .mem_val_in, .offset_in,
		.Qbase, .Qsrc, .dest,
		.Vsrc_valid_out(Vsrc_valid_output[i]),
		.Vbase_valid_out(Vbase_valid_output[i]),
		.CDB_out(LD_STR_CDB_out[i]),
		.dmem_addr(datamem_addr[i]),
		.dmem_write(datamem_write[i]), 
		.dmem_read(datamem_read[i]),
		.dmem_wdata(datamem_wdata[i]),
		.dmem_byte_enable(datamem_byte_enable[i])
	);
end
endgenerate

assign mem_val_in = dmem_rdata;
assign RE = ld_buffer_read | wr_RE_out;
		
assign dmem_read = datamem_read[r_addr_out];		
assign dmem_wdata = datamem_wdata[r_addr_out];
assign dmem_addr = datamem_addr[r_addr_out];
assign dmem_byte_enable = datamem_byte_enable[r_addr_out];
assign CDB_out = LD_STR_CDB_out[r_addr_out];

endmodule: ldstr_buffer