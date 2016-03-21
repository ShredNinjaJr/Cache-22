import lc3b_types::*;

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
	input lc3b_word dmem_rdata,
	
	/* To Regfile */
	output lc3b_reg dest_a,
	output logic[data_width - 1: 0] value_out,
	output logic ld_regfile_value,
	output logic ld_regfile_busy,
	
	/* TO L1 - Cache  */
	output logic dmem_read, dmem_write, 
	
	/* TO ROB */
	output logic RE_out
		
);

logic mem;

assign dest_a = dest_in;
assign value_out = (mem) ? dmem_rdata : value_in;

always_comb
begin
	ld_regfile_busy = 0;
	ld_regfile_value = 0;
	RE_out = 0;
	mem = 0;
	dmem_read = 0;
	if(valid_in)
	begin
		if(dmem_resp)
		begin
			mem = 1;
			ld_regfile_busy = 1'b1;
			ld_regfile_value = 1'b1;
			RE_out = 1'b1;
		end
		else if(opcode_in == op_ldr)
			begin
				dmem_read = 1; // Would not continue  on to  next instruction until  this  ldr is popped
			end
		else 
			begin
			ld_regfile_busy = 1'b1;
			ld_regfile_value = 1'b1;
			RE_out = 1'b1;
		end
	end	
end




endmodule : write_results_control
