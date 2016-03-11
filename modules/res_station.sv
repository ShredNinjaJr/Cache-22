import lc3b_types::*;

module res_station #(parameter data_width = 16, parameter tag_width = 3)
(
	input clk, 
	input ld_op, ld_Vj, ld_Qj, ld_Vk, ld_Qk, ld_A, ld_busy, ld_v,
	input [data_width - 1: 0] Vj_in, Vk_in, A_in,
	input [tag_width - 1: 0] Qj_in, Qk_in,
	input lc3b_opcode op_in,
	input busy_in,
	input valid_in,
	
	output logic [data_width - 1: 0] Vj_out, Vk_out, A_out,
	output logic [tag_width - 1: 0] Qj_out, Qk_out,
	output logic lc3b_opcode op_out,
	output logic busy_out,
	output logic valid_out
	
);

logic busy;
logic lc3b_opcode op;

logic [tag_width-1:0] Qj;
logic [data_width-1:0] Vj;

logic [tag_width-1:0] Qk;
logic [data_width-1:0] Vk;

logic [data_width-1:0] A;
logic valid;

assign busy_out = busy;
assign op_out = op;

assign Qj_out = Qj;
assign Vj_out = Vj;

assign Qk_out = Qk;
assign Vk_out = Vk;

assign A_out = A;
assign valid_out = valid;

always_ff @ (posedge clk)
begin
	if(flush)
		begin
			op = 0;
			busy = 0;
			Qj = 0;
			Vj = 0;
			Qk = 0;
			Vk = 0;
			A = 0;
			valid = 0;
		end
	else 
		begin
			if(ld_op)
				op = op_in;
			if(ld_busy)
				busy = busy_in;
			if(ld_Qj)
				Qj = Qj_in;
			if(ld_Vj)
				Vj = Vj_in;
			if(ld_Q_k)
				Qk = Qk_in;
			if(ld_Vk)
				Vk = Vk_in;
			if(ld_A)
				A = A_in;
			if(ld_v)
				valid = valid_in;
		end
end

endmodule: res_station