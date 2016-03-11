import lc3b_types::*;

module shf_alu
(
    input lc3b_aluop aluop,
    input lc3b_word a, b,
    output lc3b_word f
);

always_comb
begin
    case (aluop)
        alu_sll: f = a << b;
        alu_srl: f = a >> b;
        alu_sra: f = $signed(a) >>> b;
        default: $display("Unknown aluop");
    endcase
end

endmodule : shf_alu
