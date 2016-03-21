import lc3b_types::*;

module RS_decoder
(
	input ld_busy, issue_ld_Vj, issue_ld_Vk, issue_ld_Qk, issue_ld_Qj,
	input [2:0] res_station_id,
	
	/* RS wires */
	output logic RS_ld_busy [0:`NUM],
	output logic RS_issue_ld_Vj[0:`NUM],
	output logic RS_issue_ld_Vk[0:`NUM],
	output logic RS_issue_ld_Qk[0:`NUM],
	output logic RS_issue_ld_Qj[0:`NUM]
);

byte unsigned j;
logic [2:0] i;

always_comb
begin
	i = 0;
	for(j = 0; j <= `NUM; j++)
	begin
		RS_ld_busy[j] = 0;
		RS_issue_ld_Vj[j] = 0;
		RS_issue_ld_Vk[j] = 0;
		RS_issue_ld_Qj[j] = 0;
		RS_issue_ld_Qk[j] = 0;
	end
		
	case(res_station_id)
	3'b0, 3'b1, 3'b10: begin
		i = res_station_id;
		RS_ld_busy[i] = ld_busy;
		RS_issue_ld_Vj[i] = issue_ld_Vj;
		RS_issue_ld_Vk[i] = issue_ld_Vk;
		RS_issue_ld_Qj[i] = issue_ld_Qj;
		RS_issue_ld_Qk[i] = issue_ld_Qk;
	end
	default: ;
	endcase
end




endmodule:RS_decoder 
