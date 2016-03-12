import lc3b_types::*;

module alu_res_station #(parameter data_width = 16, parameter tag_width = 3)
(
	input clk, flush,
	input busy_in,
	input lc3b_word instr,
	input lc3b_opcode op_in,
	input CDB CDB_in,
	//CDBout
	input [data_width-1:0] Vj, Vk,
	input [tag_width-1:0] Qj, Qk,
	input ld_busy, issue_ld_Vj, issue_ld_Vk, issue_ld_Qk, issue_ld_Qj,
	output logic busy_out,
	output logic done,
	output lc3b_word CDB_data_out
);

logic [data_width - 1: 0] Vj_in, Vk_in;
logic [tag_width - 1: 0] Qj_in, Qk_in;
assign Qj_in = Qj;
assign Qk_in = Qk;


logic ld_op, ld_Vj, ld_Qj, ld_Vk, ld_Qk;
assign ld_Qk = issue_ld_Qk;
assign ld_Qj = issue_ld_Qj;
assign ld_op = ld_busy;

logic Vk_valid_in = 1;
logic Vj_valid_in = 1;
	
logic [data_width - 1: 0] Vj_out, Vk_out;
logic [tag_width - 1: 0] Qj_out, Qk_out;
lc3b_opcode op_out;
logic Vk_valid_out;
logic Vj_valid_out;

mux2 #(.width(data_width)) Vk_mux (.sel(busy_out), .a(Vk) ,.b(CDB_in.data), .f(Vk_in));

assign ld_Vk = (busy_out) ? ((Qk == CDB_in.tag) & CDB_in.valid) : issue_ld_Vk;

mux2 #(.width(data_width)) Vj_mux (.sel(busy_out), .a(Vj) ,.b(CDB_in.data), .f(Vj_in));

assign ld_Vj = (busy_out) ? ((Qj == CDB_in.tag) & CDB_in.valid) : issue_ld_Vj;


res_station res_station_reg (.*);

assign done = (Vk_valid_out & Vj_valid_out);


logic A,D;	/* bit 5 and 4 of instr, used for SHF */
always_ff@(posedge clk)
begin
	if(ld_op)
	begin
		A <= instr[5];
		D <= instr[4];
	end
end


lc3b_aluop aluop;
lc3b_word alu_out;
assign CDB_data_out = alu_out;
alu_logic alu_logic (.op(op_out), .A, .D, .aluop);

alu alu
(
   .aluop,
   .a(Vj_out), .b(Vk_out),
   .f(alu_out)
);

endmodule: alu_res_station