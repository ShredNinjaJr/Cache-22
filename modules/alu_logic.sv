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
		op_add: begin
			if(A == 0)
			begin
				case({instr[4], instr[3]})
					2'b00: aluop = alu_add;
					2'b01: aluop = alu_sub;
					2'b10: aluop = alu_or;
					2'b11: aluop = alu_nor;
				endcase
			end
			else aluop = alu_add;
		end
		op_and: begin
			if( A == 0)
			begin
				case({instr[4], instr[3]})
					2'b00: aluop = alu_and;
					2'b01: aluop = alu_nand;
					2'b10: aluop = alu_xor;
					2'b11: aluop = alu_xnor;
				endcase
			end
			else aluop = alu_and;
		end

		op_not: aluop = alu_not;

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
