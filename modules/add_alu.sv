import lc3b_types::*;

module add_alu
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
        default: begin
				f = a;
				$display("Unknown aluop");
		  end
    endcase
end

endmodule : add_alu
