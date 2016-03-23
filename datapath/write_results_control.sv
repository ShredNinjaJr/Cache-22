import lc3b_types::*;

module write_results_control #(parameter data_width = 16, parameter tag_width = 3)
(
	input clk, 
	
	/* From ROB */
	input valid_in,
	input lc3b_opcode opcode_in,
	input lc3b_reg dest_in,
	input [data_width - 1:0] value_in,
	
	/* To Regfile */
	output lc3b_reg dest_a,
	output logic[data_width - 1: 0] value_out,
	output logic ld_regfile_value,
	output logic ld_regfile_busy,
	
	/* TO ROB */
	output logic RE_out
		
);

assign dest_a = dest_in;
assign value_out = value_in;

always_comb
begin
	ld_regfile_busy = 1'b00;
	ld_regfile_value = 1'b00;
	RE_out = 0;
	if(valid_in)
		begin
			ld_regfile_busy = 1'b1;
			ld_regfile_value = 1'b1;
			RE_out = 1'b1;
		end
end


endmodule : write_results_control
