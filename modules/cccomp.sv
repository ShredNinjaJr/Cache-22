
import lc3b_types::*;

module cccomp
(
	input lc3b_nzp cc_in,
	input lc3b_reg dest,
	output logic branch_enable
);

always_comb
begin
	branch_enable = (cc_in[2]&dest[2])|(cc_in[1]&dest[1])|(cc_in[0]&dest[0]);
end

endmodule:cccomp
