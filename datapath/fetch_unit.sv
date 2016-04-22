import lc3b_types::*;

module fetch_unit
(
	input clk, flush,
	input lc3b_word imem_rdata,
	input imem_resp,
	input [1:0] pcmux_sel,
	input lc3b_word new_pc, br_pc, 
	input stall, 
	
	output lc3b_word instr_pc_out,
	output imem_read,
	output lc3b_word imem_address,
	output lc3b_word ir_out,
	output lc3b_word pc_out
);

lc3b_word pc_plus2_out;

logic load_pc, load_ir;
assign load_pc = (pcmux_sel == 2'b0) ? (imem_resp & ~stall) : (flush | ~stall);
assign load_ir = load_pc;
assign imem_address = pc_out; 
assign imem_read = ~stall;
lc3b_word pcmux_out;

plus2 plus2 (.in(pc_out), .out(pc_plus2_out));

mux4 pcmux
(
	.sel(pcmux_sel),
	.a(pc_plus2_out),
	.b(br_pc),
	.c(new_pc), .d(new_pc),
	.f(pcmux_out)
);

register pc
(
	.clk, .clr(1'b0),
	.load(load_pc),
	.in(pcmux_out),
	.out(pc_out)
);

register old_pc
(
	.clk, .clr(1'b0),
	.load(load_pc),
	.in(pc_out),
	.out(instr_pc_out)
);

register ir
(
	.clk, .clr(1'b0),
	.load(load_ir),
	.out(ir_out),
	.in(imem_rdata)
);







endmodule:fetch_unit

