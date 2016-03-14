import lc3b_types::*;

module gencc
(
    input logic[15:0] in,
    output logic[2:0] out
);

always_comb
begin

    if (in[15] == 1'b1)
        out = 3'b100;
    else if (|in)
        out = 3'b001;
    else
        out = 3'b010;

end

endmodule : gencc
