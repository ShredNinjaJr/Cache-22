import lc3b_types::*;

module alu_RS_unit #(parameter data_width = 16, parameter tag_width = 3, parameter n = 2)
(
	input clk, flush,
	input lc3b_word instr_in,
	input bit5,
	input CDB CDB_in,
	//CDBout
	input [data_width-1:0] Vj, Vk,
	input [tag_width-1:0] Qj, Qk, dest,
	input ld_busy, issue_ld_Vj, issue_ld_Vk, issue_ld_Qk, issue_ld_Qj,
	input [2:0] res_station_id,
	input CDB load_buffer_CDB_out,
	
	output logic busy_out[0:n],
	output CDB CDB_out,
	output logic ld_buffer_flush
);


/* Decoder unit */

RS_decoder RS_decoder (.*);

/* RS wires */
logic RS_flush   [0:n+1];
assign ld_buffer_flush = RS_flush[n+1];
logic RS_ld_busy [0:n];
logic RS_issue_ld_Vj[0:n];
logic RS_issue_ld_Vk[0:n];
logic RS_issue_ld_Qk[0:n];
logic RS_issue_ld_Qj[0:n];

CDB RS_CDB_out[0:n+1];
assign RS_CDB_out[n+1] = load_buffer_CDB_out;

/* Generate the RS */
genvar i;
generate for(i = 0; i <= n; i++)
begin: RS_generate
	alu_res_station RS
	(
		.clk,
		.flush(RS_flush[i] | flush),
		.instr_in,
		.CDB_in,
		.bit5,
		.Vj, .Vk, .Qj, .Qk, .dest,
		.ld_busy(RS_ld_busy[i]),
		.issue_ld_Vj(RS_issue_ld_Vj[i]),
		.issue_ld_Vk(RS_issue_ld_Vk[i]),
		.issue_ld_Qj(RS_issue_ld_Qj[i]),
		.issue_ld_Qk(RS_issue_ld_Qk[i]),
		.CDB_out(RS_CDB_out[i]),
		.busy_out(busy_out[i])
	);
end
endgenerate


CDB_arbiter #(.n($size(RS_CDB_out) - 1)) CDB_arbiter
(
	.clk,
	.RS_CDB_in(RS_CDB_out),
	.flush(flush),
	
	.RS_flush(RS_flush),
	.CDB_out(CDB_out)
);




endmodule: alu_RS_unit
