import lc3b_types::*;

module fetch_unit
(
	input clk,
	input lc3b_word imem_rdata,
	input imem_resp,
	input [1:0] pcmux_sel,
	output imem_read,
	output imem_address,
	output lc3b_word ir_out,
	output lc3b_word pc_out
);

lc3b_word pc_out, pc_plus2_out;

logic load_pc, load_ir;
assign load_pc = imem_resp;
assign load_ir = imem_resp;
assign imem_address = pc_out; 
assign imem_read = 1;
lc3b_word pcmux_out;

plus2 plus2 (.in(pc_out), .out(pc_plus2_out));

mux4 pcmux
(
	.sel(pcmux_sel),
	.a(pc_plus2_out),

	.f(pcmux_out)
);

register pc
(
	.clk,
	.load(load_pc),
	.in(pcmux_out),
	.out(pc_out)
);

register ir
(
	.clk,
	.load(load_ir),
	.out(ir_out),
	.in(imem_rdata)
);







endmodule:fetch_unit

