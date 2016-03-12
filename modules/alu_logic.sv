module alu_logic
(
	input lc3b_opcode op,
	input A, D,
	output lc3b_aluop aluop
);


always_comb
begin
	
	case(op)
		op_add: aluop = alu_add;
		op_not: aluop = alu_not;
		op_and: aluop = alu_add;
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
			$display("Unknown aluop");
		end
	endcase
end

endmodule: alu_logic 
