module mux8 #(parameter width = 16)
(
	input [2:0] sel,
	input [width-1:0] a,b,c,d,e,f,g,h,
	output logic [width-1:0] i
);

always_comb
begin
	case (sel)
	3'b000: i = a;
	3'b001: i = b;
	3'b010: i = c;
	3'b011: i = d;
	3'b100: i = e;
	3'b101: i = f;
	3'b110: i = g;
	3'b111: i = h;
	endcase
end



endmodule: mux8


