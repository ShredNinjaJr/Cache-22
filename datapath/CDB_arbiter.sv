import lc3b_types::*;

module CDB_arbiter #(parameter n = 2)
(
	input clk,
	input CDB RS_CDB_in[0:n],
	
	output logic RS_flush[0:n],
	output CDB CDB_out
);

byte unsigned i; /* Loop variable */
logic pri_en_valid;
logic [2:0] pri_en_out;

initial
begin
	CDB_out = 0;
end
/* priority encoder to determine who gets the bus */
priority_encoder pri_en
(
  .binary_out(pri_en_out) , //  3 bit binary output
  .in({4'b0,RS_CDB_in[3].valid, RS_CDB_in[2].valid, RS_CDB_in[1].valid, RS_CDB_in[0].valid}) , //  8-bit input 
  .enable(1'b1),
  .V(pri_en_valid)			/* Valid output */
);
always_ff@(posedge clk)
begin
	CDB_out <= 0;

	if(pri_en_valid)
	begin
		case(pri_en_out)
		3'b0, 3'b1, 3'b10, 3'b11:begin
		CDB_out <= RS_CDB_in[pri_en_out];
		end
		default:	CDB_out <= 0;
		endcase
	end
	else
	begin
		CDB_out <= 0;
	end
end

always_comb
begin
	for(i = 0; i <= n; i++)
		RS_flush[i] = 0;
	
	if(pri_en_valid)
	begin
		case(pri_en_out)
		3'b0, 3'b1, 3'b10, 3'b11:begin
		RS_flush[pri_en_out] = 1'b1;
		end
		default:	;
		endcase
	end
end



endmodule: CDB_arbiter
