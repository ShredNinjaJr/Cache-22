import lc3b_types::*;

module alu
(
    input lc3b_aluop aluop,
    input lc3b_word a, b,
    output lc3b_word f
);

always_comb
begin
	 f = a;
    case (aluop)
        alu_add: f = a + b;
        alu_and: f = a & b;
        alu_not: f = ~a;
        alu_pass: f = a;
        alu_sll: f = a << b[3:0];
        alu_srl: f = a >> b[3:0];
        alu_sra: f = $signed(a) >>> b[3:0];
		  alu_nand: f = ~(a & b);
		  alu_xor: f = a ^ b;
		  alu_xnor: f = ~(a ^ b);
		  alu_or: f = a | b;
		  alu_nor: f = ~(a | b);
		  alu_sub: f = a - b;

        default: $display("Unknown aluop");
    endcase
end

endmodule : alu
