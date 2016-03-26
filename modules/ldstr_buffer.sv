import lc3b_types::*;

module ldstr_buffer #(parameter data_width = 16, parameter tag_width = 3, parameter n = 7)
(
	input clk, flush, WE, ld_mem_val,
	input lc3b_opcode opcode_in,
	
	input Vsrc_valid_in, Vbase_valid_in,
	input [data_width-1:0] Vbase, Vsrc,
	input [tag_width-1:0] Qbase, Qsrc, dest,
	input CDB CDB_in,
	
	output logic full,
	output CDB CDB_out,
	output logic ld_buffer_flush
);

/* Decoder unit */
ldstr_decoder LD_STR_decoder (.*);

/* RS wires */
logic RS_flush[0:n];
logic issue_WE[0:n];
logic issue_ld_mem_val[0:n];
logic r_addr;

logic Vsrc_valid_output[0:n];
logic Vbase_valid_output[0:n];

lc3b_word datamem_addr[0:n];
logic datamem_write[0:n]; 
logic datamem_read[0:n];
lc3b_word datamem_wdata[0:n];


CDB RS_CDB_out[0:n];

/* Generate the RS */
genvar i;
generate for(i = 0; i <= n; i++)
begin: RS_generate
	cdb_ld_str_res_station RS
	(
		.clk,
		.flush(RS_flush[i] | flush),
		.WE(issue_WE[i]),
		.ld_mem_val(issue_ld_mem_val[i]),
		.opcode_in,
		.CDB_in,
		.Vsrc_valid_in,
		.Vbase_valid_in,
		.Vbase, .Vsrc, .mem_val_in,
		.Qbase, .Qsrc, .dest,
		.Vsrc_valid_out(Vsrc_valid_output[i]),
		.Vbase_valid_out(Vbase_valid_output[i]),
		.CDB_out(RS_CDB_out[i]),
		.dmem_addr(datamem_addr[i]),
		.dmem_write(datamem_write[i]), 
		.dmem_read(datamem_read[i]),
		.dmem_wdata(datamem_wdata[i])
			
	);
end
endgenerate

assign mem_val_in = dmem_rdata;

always_comb
	begin
		dmem_wdata = datamem_write[r_addr];
		dmem_addr = datamem_addr[r_addr];
		dmem_write = datamem_write[r_addr];
		dmem_read = datamem_read[r_addr];
	end


CDB_arbiter #(.n($size(RS_CDB_out) - 1)) CDB_arbiter
(
	.clk,
	.RS_CDB_in(RS_CDB_out),
	
	.RS_flush(RS_flush),
	.CDB_out(CDB_out)
);

endmodule: ldstr_buffer