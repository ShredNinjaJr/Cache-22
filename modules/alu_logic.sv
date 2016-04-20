import lc3b_types::*;

module alu_logic
(
	input lc3b_word instr,
	output lc3b_aluop aluop
);

lc3b_opcode op;
assign op = lc3b_opcode'(instr[15:12]);

logic A;
assign A = instr[5];
logic D;
assign D = instr[4];

always_comb
begin
	
	case(op)
		op_add: aluop = alu_add;
		op_not: aluop = alu_not;
		op_and: aluop = alu_and;
		op_shf: begin
			if(D == 0)
				aluop = alu_sll;
			else 
			if(A == 0)
				aluop = alu_srl;
			else
				aluop = alu_sra;
		end
		default: 
		begin
			aluop = alu_pass;
		//	$display("Unknown aluop");
		end
	endcase
end

endmodule: alu_logic 
