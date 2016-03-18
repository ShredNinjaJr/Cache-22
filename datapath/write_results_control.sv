
module write_results_control #(parameter data_width = 16, parameter tag_width = 3)
(
	input clk, 
	
	/* From ROB */
	input valid_in,
	input lc3b_opcode opcode_in,
	input lc3b_reg dest_in,
	input [data_width - 1:0] value_in,
	
	/* From L1 - Cache */
	input dmem_resp,
	
	/* To Regfile */
	output lc3b_reg dest_a,
	output [data_width - 1: 0] value_out,
	output ld_regfile_value,
	output ld_regfile_busy,
	
	/* TO L1 - Cache  */
	output dmem_read, dmem_write,
	
	/* TO ROB */
	output RE_out
		
);

assign dest_a = dest_in;
assign value_out = value_in;

always_comb
begin
	ld_regfile_busy = 0;
	ld_regfile_value = 0;
	RE_out = 0;
	if(valid_in)
	begin
		ld_regfile_busy = 1'b1;
		ld_regfile_value = 1'b1;
		RE_out = 1'b1;
	end
	
end



endmodule : write_results_control
