import lc3b_types::*;

module alu
(
    input lc3b_aluop aluop,
    input lc3b_word a, b,
    output lc3b_word f
);

always_comb
begin
    case (aluop)
        alu_add: f = a + b;
        alu_and: f = a & b;
        alu_not: f = ~a;
        alu_pass: f = a;
        alu_sll: f = a << b[3:0];
        alu_srl: f = a >> b[3:0];
        alu_sra: f = $signed(a) >>> b[3:0];
        default: $display("Unknown aluop");
    endcase
end

endmodule : alu
