import lc3b_types::*;

module write_results_control #(parameter data_width = 16, parameter tag_width = 3)
(
	input clk, 
	
	/* From ROB */
	input valid_in,
	input lc3b_opcode opcode_in,
	input lc3b_reg dest_in,
	input [data_width - 1:0] value_in,
	input predict_in,
	input rob_empty,
	input lc3b_rob_addr dest_wr_data,
	input lc3b_rob_addr rob_addr,
	input dmem_resp,
	
	/* To Regfile */
	output lc3b_reg dest_a,
	output logic[data_width - 1: 0] value_out,
	output logic ld_regfile_value,
	output logic ld_regfile_busy,
	output lc3b_reg dest_wr,
	
	/* TO ROB */
	output logic RE_out,
	
	/* TO datapath */
	output logic flush,
	
	/* To fetch unit */
	output logic  pcmux_sel,
	output lc3b_word new_pc,
	
	/* To memory */
	output logic dmem_write,
	
	/* To ld/str buffer */
	output logic ldstr_RE_out
		
);

assign dest_a = dest_in;
assign value_out = value_in;
assign new_pc = value_in;

assign dest_wr = dest_in;

logic ld_cc;
lc3b_nzp gencc_out;
lc3b_nzp cc_out;
logic branch_enable;

/* Branch logic */
gencc gencc
(
	.in(value_in),
   .out(gencc_out)
);

register #(3) cc
(
	.clk,
	.clr(1'b0),
	.load(ld_cc),
	.in(gencc_out),
	.out(cc_out)
);

cccomp cccomp (.cc_in(cc_out), .dest(dest_in), .branch_enable);




always_comb
begin
	ld_regfile_busy = 1'b0;
	ld_regfile_value = 1'b0;
	ld_cc = 0;
	RE_out = 0;
	pcmux_sel = 0;
	flush = 0;
	dmem_write = 0;
	ldstr_RE_out = 0;
	if(valid_in)
	begin
		case(opcode_in)
		op_br: begin
			/* If it is a branch, Check for misprediction and flush
			 * the datapath if the branch was mispredicted */
			 if(branch_enable != predict_in)
			 begin
				pcmux_sel = 1'b1;
				flush = 1'b1;
			 end
			 RE_out = 1'b1;
		end 
		op_add, op_and, op_not, op_shf, op_lea, op_ldr, op_ldb: begin
			ld_regfile_busy = (dest_wr_data == rob_addr);
			ld_regfile_value = 1'b1;
			ld_cc = 1'b1;
			RE_out = 1'b1;
		end
		op_jsr: begin
			ld_regfile_busy = (dest_wr_data == rob_addr);
			ld_regfile_value = 1'b1;
			RE_out = 1'b1;
		end
		op_str, op_stb: begin
			dmem_write = 1'b1;
			RE_out = dmem_resp;
			ldstr_RE_out = dmem_resp;
		end
		op_trap: begin
			pcmux_sel = 1'b1;
			flush = 1'b1;
			RE_out = 1'b1;
		end
		default: ;
		endcase
	end
end


endmodule : write_results_control
