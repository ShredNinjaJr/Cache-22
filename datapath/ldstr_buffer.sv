import lc3b_types::*;

module ldstr_buffer #(parameter data_width = 16, parameter tag_width = 3, parameter n = 7)
(
	input clk, flush, WE, ld_buffer_read,
	input lc3b_opcode opcode_in,
	
	input dmem_resp, 
	input lc3b_word dmem_rdata,

	input Vsrc_valid_in, Vbase_valid_in,
	input [data_width-1:0] Vbase, Vsrc, offset_in,
	input [tag_width-1:0] Qbase, Qsrc, dest,
	input CDB CDB_in,
	
	output dmem_read, dmem_write,
	output lc3b_word dmem_wdata, dmem_addr,
	
	output logic full,
	output CDB CDB_out
);

lc3b_word mem_val_in;



/* Decoder unit */
ldstr_decoder LD_STR_decoder (.*);

/* RS wires */
logic issue_WE[0:n];
logic issue_ld_mem_val[0:n];
logic RE;
logic [tag_width-1:0] r_addr_out;

logic Vsrc_valid_output[0:n];
logic Vbase_valid_output[0:n];

lc3b_word datamem_addr[0:n];
logic datamem_write[0:n]; 
logic datamem_read[0:n];
lc3b_word datamem_wdata[0:n];

CDB LD_STR_CDB_out[0:n];

/* Generate the RS */
genvar i;
generate for(i = 0; i <= n; i++)
begin: RS_generate
	cdb_ld_str_res_station RS
	(
		.clk,
		.flush(flush),
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
		.dmem_wdata(datamem_wdata[i])
			
	);
end
endgenerate

assign mem_val_in = dmem_rdata;
assign RE = ld_buffer_read;

assign dmem_write = (r_addr_out == 0) ? datamem_write[0] : (r_addr_out == 1) ? datamem_write[1] : (r_addr_out == 2) ? datamem_write[2] : (r_addr_out == 3) ? datamem_write[3] :
								(r_addr_out == 4) ? datamem_write[4] : (r_addr_out == 5) ? datamem_write[5] : (r_addr_out == 6) ? datamem_write[6] : datamem_write[7];
								
assign dmem_read = (r_addr_out == 0) ? datamem_read[0] : (r_addr_out == 1) ? datamem_read[1] : (r_addr_out == 2) ? datamem_read[2] : (r_addr_out == 3) ? datamem_read[3] :
								(r_addr_out == 4) ? datamem_read[4] : (r_addr_out == 5) ? datamem_read[5] : (r_addr_out == 6) ? datamem_read[6] : datamem_read[7];
								
always_comb
	begin
		dmem_wdata = datamem_write[r_addr_out];
		dmem_addr = datamem_addr[r_addr_out];
	
		CDB_out = LD_STR_CDB_out[r_addr_out];
	end

endmodule: ldstr_buffer