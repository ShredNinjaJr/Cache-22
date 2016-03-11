import lc3b_types::*;

module add_res_station #(parameter data_width = 16, parameter tag_width = 3)
(
	input clk, flush,
	input busy_in,
	//CDBin
	//CDBout
	input [data_width-1:0] Vj, Vk,
	output logic busy_out,
);

logic [data_width - 1: 0] Vj_in, Vk_in,
logic [tag_width - 1: 0] Qj_in, Qk_in,
logic ld_op, ld_Vj, ld_Qj, ld_Vk, ld_Qk, ld_busy,
logic lc3b_opcode op_in,
logic Vk_valid_in,
logic Vj_valid_in,
	
logic [data_width - 1: 0] Vj_out, Vk_out;
logic [tag_width - 1: 0] Qj_out, Qk_out;
lc3b_opcode op_out;
logic Vk_valid_out;
logic Vj_valid_out;
lc3b_word alu_out;

always_comb
begin
	case(op_out)
		op_add: aluop = alu_add;
		op_not: aluop = alu_not;
		op_and: aluop = alu_add;
		default: $display("Unknown aluop");
	endcase
end

res_station res_station_reg (.*);

add_alu alu
(
   .aluop,
   .a(Vj_out), .b(Vk_out),
   .f(alu_out)
);

endmodule: res_station