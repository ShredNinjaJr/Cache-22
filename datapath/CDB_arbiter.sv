import lc3b_types::*;

module CDB_arbiter
(
	input clk,
	input CDB RS_CDB_in[0:`NUM],
	
	output logic RS_flush[0:`NUM],
	output CDB CDB_out
);

byte unsigned i; /* Loop variable */
logic pri_en_valid;
logic [2:0] pri_en_out;

/* priority encoder to determine who gets the bus */
priority_encoder pri_en
(
  .binary_out(pri_en_out) , //  3 bit binary output
  .in({RS_CDB_in[0], RS_CDB_in[1], RS_CDB_in[2], 5'b0}) , //  8-bit input 
  .enable(1'b1),
  .V(pri_en_valid)			/* Valid output */
);
always_ff@(posedge clk)
begin
	
	if(pri_en_valid)
	begin
		case(pri_en_out)
		3'b0, 3'b1, 3'b10:begin
		CDB_out <= RS_CDB_in[pri_en_out];
		RS_flush[pri_en_out] <= 1;
		end
		default:begin
		CDB_out <= 0;
		for(i = 0; i <= `NUM; i++)
			RS_flush[i] <= 0;
		end
		endcase
		
	end
	else
	begin
		CDB_out <= 0;
		for(i = 0; i <= `NUM; i++)
			RS_flush[i] <= 0;
	end
end

always_comb
begin
	;
end



endmodule: CDB_arbiter
