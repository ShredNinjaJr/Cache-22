 import lc3b_types::*;

module mul_div_res_station #(parameter data_width = 16, parameter tag_width = 3)
(
	input clk, flush,
	input lc3b_word instr_in,
	input CDB CDB_in,
	//CDBout
	input [data_width-1:0] Vj, Vk,
	input [tag_width-1:0] Qj, Qk, dest,
	input ld_busy, issue_ld_Vj, issue_ld_Vk, issue_ld_Qk, issue_ld_Qj,
	output logic busy_out,
	output CDB CDB_out
);

logic [data_width - 1: 0] Vj_in, Vk_in;
logic [tag_width - 1: 0] Qj_in, Qk_in, dest_in;
assign Qj_in = Qj;
assign Qk_in = Qk;
assign dest_in = dest;

logic ld_op, ld_Vj, ld_Qj, ld_Vk, ld_Qk, ld_dest;
assign ld_Qk = issue_ld_Qk;
assign ld_Qj = issue_ld_Qj;
assign ld_op = ld_busy;
assign ld_dest = ld_busy;

logic Vk_valid_in = 1;
logic Vj_valid_in = 1;
logic busy_in = 1;
	
logic [data_width - 1: 0] Vj_out, Vk_out;
logic [tag_width - 1: 0] Qj_out, Qk_out, dest_out;
lc3b_word instr_out;
logic Vk_valid_out;
logic Vj_valid_out;

/* Mux input of the Vk and Vj fields  based on busy bit*/

/* If Busy, get input from CDB, if not get from manual input*/
mux2 #(.width(data_width)) Vk_mux (.sel(busy_out), .a(Vk) ,.b(CDB_in.data), .f(Vk_in));
mux2 #(.width(data_width)) Vj_mux (.sel(busy_out), .a(Vj) ,.b(CDB_in.data), .f(Vj_in));

/* Based on busy bit of  reservation station set load based from CDB or manual input */
/* If Busy, set ld based if CDB value is appropriate, if not get from manual input*/
assign ld_Vj = (busy_out) ? ((Qj_out == CDB_in.tag) & CDB_in.valid & ~Vj_valid_out) : issue_ld_Vj;
assign ld_Vk = (busy_out) ? ((Qk_out == CDB_in.tag) & CDB_in.valid & ~Vk_valid_out) : issue_ld_Vk;

res_station res_station_reg (.*);

/* If both Vk and Vj are  valid then  execution of instruction is done, therefore CDB.valid is set high*/


assign CDB_out.tag = dest_out;

lc3b_word multiplier_out, divider_out;

multiplier multiplier
(
	.aclr(flush),
	.clken((Vk_valid_out & Vj_valid_out)),
	.clock(clk),
	.dataa(Vj_out[7:0]),
	.datab(Vk_out[7:0]),
	.result(multiplier_out)
);

divider divider 
(
	.aclr(flush),
	.clken((Vk_valid_out & Vj_valid_out)),
	.clock(clk),
	.numer(Vj_out),
	.denom(Vk_out),
	.quotient(divider_out)
);


enum int unsigned { IDLE, COMPUTE} state, next_state;
int unsigned counter;
initial counter = 0;
initial state = IDLE;

always_ff @(posedge clk)
begin
	state <= next_state;
	
	if(instr_out[5])
	begin
		if(counter == num_div_cycles)
			CDB_out.data <= divider_out;
	end
	else
	begin
		if(counter == num_mult_cycles)
			CDB_out.data <= multiplier_out;
	end
	
	if(state == COMPUTE)
		counter <= counter + 1;
	if(state == IDLE)
		counter <= 0;
	
end

always_comb 
begin: next_state_logic
	next_state = state;
	case(state)
	IDLE:
		if(Vk_valid_out & Vj_valid_out)
			next_state = COMPUTE;
	
	COMPUTE: begin
		if(flush)
			next_state = IDLE;
	end
	endcase
end


always_comb
begin
	case(state)
	IDLE: CDB_out.valid = 0;
	COMPUTE: begin
		if(instr_out[5])
		begin
			CDB_out.valid = (counter > num_div_cycles);
		end
		else
		begin
			CDB_out.valid = (counter > num_mult_cycles);
		end
	end
	endcase
	
end
endmodule: mul_div_res_station
