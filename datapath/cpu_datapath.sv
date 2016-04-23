import lc3b_types::*;

module cpu_datapath
(
	input clk,
	input lc3b_word imem_rdata,
	input lc3b_word dmem_rdata,
	input imem_resp,
	input dmem_resp,
	
	output lc3b_word imem_address,
	output lc3b_word dmem_address,
	output lc3b_word dmem_wdata,
	output logic imem_read,
	output logic dmem_read,
	output logic dmem_write,
	output lc3b_mem_wmask dmem_byte_enable
);

CDB C_D_B;
CDB load_buffer_CDB_out;
logic flush;
logic bit5;
lc3b_word ir_out, pc_out;

logic ld_buf_valid_in;

logic [1:0] pcmux_sel;
lc3b_word new_pc;
lc3b_word br_pc;
logic stall;

fetch_unit fetch_unit
(
	.clk, .flush, 
	.imem_rdata, .imem_read, .imem_address, .imem_resp,
	.stall,
	.pcmux_sel, .ir_out, .pc_out, .new_pc, .br_pc
	
);

/* Reservation station -> Issue Control */

logic alu_RS_busy [0:num_RS_units];

/* Load Buffer -> Issue Control */
logic ldstr_full;

/* ROB -> Issue control */
logic rob_full;
lc3b_rob_addr rob_addr;
lc3b_word rob_sr1_value_out, rob_sr2_value_out;
logic rob_sr2_valid_out, rob_sr1_valid_out;

/* Regfile -> Issue control */
regfile_t sr1_regfile_out, sr2_regfile_out, dest_regfile_out;

/* Issue Control -> Reservation Station */
lc3b_opcode res_op_in;
lc3b_word res_Vj, res_Vk;
lc3b_rob_addr res_Qk, res_Qj, res_dest;
logic issue_ld_busy_dest, issue_ld_Vj, issue_ld_Vk;
logic issue_ld_Qk, issue_ld_Qj;

/* Issue Control -> Load Store Buffer */
logic ldstr_write_enable;
lc3b_word ldstr_offset;
lc3b_rob_addr ldstr_Qsrc;
lc3b_rob_addr ldstr_Qbase;
lc3b_rob_addr ldstr_dest;
logic ldstr_Vsrc_valid_in;
logic ldstr_Vbase_valid_in;
lc3b_word ldstr_Vsrc;
lc3b_word ldstr_Vbase;

/* Issue control -> ROB */
logic rob_write_enable;
lc3b_opcode rob_opcode_in;
lc3b_reg rob_dest_in;
lc3b_word rob_value_in;

/* Issue control -> Regfile */
lc3b_reg reg_dest, sr1, sr2;
logic ld_reg_busy_dest;
lc3b_rob_addr reg_rob_entry;
lc3b_rob_addr rob_sr1_read_addr, rob_sr2_read_addr;
logic [2:0] res_station_id;

/* Branch prediction */
logic br_predict = 1'b0;

logic instr_is_new;
initial instr_is_new = 0;
always_ff@ (posedge clk)
begin
	if(~flush & ~stall)
		instr_is_new <= imem_resp;
	else if(~stall | flush)
		instr_is_new <= 0;
end

lc3b_word trap_reg;
issue_control issue_control
(
	.clk, .flush,
	// Fetch -> Issue Controlj
	.instr(ir_out),
	.instr_is_new,
	.curr_pc(pc_out),
	// CDB -> Issue Control
	.CDB_in(C_D_B),
	// Reservation Station -> Issue Control
	.alu_RS_busy,
	.ldstr_full(ldstr_full),
	// ROB -> Issue Control
	.rob_full,
	.rob_addr,
	.rob_sr2_value_out,
	.rob_sr1_value_out,
	.rob_sr1_valid_out,
	.rob_sr2_valid_out,
	// Regfile -> Issue Control
	.sr1_in(sr1_regfile_out), .sr2_in(sr2_regfile_out),
   	.dest_in(dest_regfile_out),
	
	/* prediction unit -> Issue control */
	.predict_bit(br_predict),

	// Issue Control -> Reservation Station
	.res_op_in,
	.res_Vj, .res_Vk,
	.res_Qj, .res_Qk, .res_dest,
	.issue_ld_busy_dest, .issue_ld_Vj, .issue_ld_Vk, 
	.issue_ld_Qk, .issue_ld_Qj, 
	.res_station_id,
	.bit5,
	.trap_reg,
	
	// Issue Control -> Load Buffer
	.ldstr_write_enable(ldstr_write_enable),
	.ldstr_offset(ldstr_offset),
	.ldstr_Qsrc(ldstr_Qsrc),
	.ldstr_Qbase(ldstr_Qbase),
	.ldstr_dest(ldstr_dest),
	.ldstr_Vsrc_valid_in(ldstr_Vsrc_valid_in),
	.ldstr_Vbase_valid_in(ldstr_Vbase_valid_in),
	.ldstr_Vsrc(ldstr_Vsrc),
	.ldstr_Vbase(ldstr_Vbase),

 	// Issue Control -> ROB
	.rob_write_enable,
	.rob_opcode(rob_opcode_in), 
	.rob_dest(rob_dest_in),
	.rob_value_in,
	// Issue Control -> Regfile
	.reg_dest, .sr1, .sr2,
	.ld_reg_busy_dest,
	.reg_rob_entry,
	.rob_sr1_read_addr,
	.rob_sr2_read_addr,
	
	/* Issue Control -> Fetch Unit */
	.stall, .pcmux_sel(pcmux_sel[0]), .br_pc

);


logic RE_out;
logic ldstr_RE_out;
logic rob_valid_out;
lc3b_opcode rob_opcode_out;
lc3b_reg rob_dest_out;
lc3b_word rob_value_out;
logic rob_predict_out;
logic rob_empty;
lc3b_rob_addr r_rob_addr;
reorder_buffer reorder_buffer
(
	.clk, .flush,
	.WE(rob_write_enable),
	.RE(RE_out),
	
	/*inputs*/
	.inst(rob_opcode_in),
	.dest(rob_dest_in),
	.value(rob_value_in),
	.predict(br_predict),
	//.addr(rob_	
	.CDB_in(C_D_B),

	.sr1_read_addr(rob_sr1_read_addr),
	.sr2_read_addr(rob_sr2_read_addr),
	
	.w_addr_out(rob_addr),
	.r_addr_out(r_rob_addr),
	
	.valid_out(rob_valid_out),
	.inst_out(rob_opcode_out),
	.dest_out(rob_dest_out),
	.value_out(rob_value_out),
	.predict_out(rob_predict_out),
	
	.full_out(rob_full),
	.empty_out(rob_empty),

	.sr1_value_out(rob_sr1_value_out),
	.sr2_value_out(rob_sr2_value_out),
	.sr1_valid_out(rob_sr1_valid_out),
	.sr2_valid_out(rob_sr2_valid_out)
);


lc3b_reg rob_regfile_dest_in;
lc3b_word regfile_value_in;
logic ld_regfile_value, rob_ld_regfile_busy;

lc3b_reg dest_wr;
lc3b_rob_addr dest_wr_data;

write_results_control wr_control
(
	.clk,
	.valid_in(rob_valid_out),
	.opcode_in(rob_opcode_out),
	.dest_in(rob_dest_out),
	.value_in(rob_value_out),
	.predict_in(rob_predict_out),
	.rob_empty,
	.rob_addr(r_rob_addr),
	.dmem_resp,
	.trap_reg, 
	
	/* To regfile */
	.dest_a(rob_regfile_dest_in),
	.value_out(regfile_value_in),
	.ld_regfile_value,
	.ld_regfile_busy(rob_ld_regfile_busy),
	.dest_wr,
	/* TO ROB */
	.RE_out,
	
	/* TO DATAPATH */
	.flush,
	/* To fetch Unit */
	.new_pc, .pcmux_sel(pcmux_sel[1]),
	/* TO MEMORY */
	.dmem_write,
	
	.ldstr_RE_out,
	
	/* FROM REGFILE */
	.dest_wr_data
	
);


logic ld_buffer_flush;

alu_RS_unit #(.n(num_RS_units)) alu_RS
(
	.clk,
	.flush(flush),
	.instr_in(ir_out),
	.CDB_in(C_D_B),
	.bit5,
	.load_buffer_CDB_out,
	.ld_buffer_flush,
	.res_station_id,
	.Vj(res_Vj), .Vk(res_Vk),
	.Qj(res_Qj), .Qk(res_Qk), .dest(res_dest),
	.ld_busy(issue_ld_busy_dest),
	.issue_ld_Vj, .issue_ld_Vk, .issue_ld_Qk, .issue_ld_Qj,
	.busy_out(alu_RS_busy),
	.CDB_out(C_D_B)
);



ldstr_buffer LDSTR_buffer
(
	.clk, 
	.flush(flush), 
	.WE(ldstr_write_enable),
	.ld_buffer_read(ld_buffer_flush),
	.wr_RE_out(ldstr_RE_out),
	
	
	.dmem_resp(dmem_resp), 
	.dmem_rdata(dmem_rdata),
	
	.opcode_in(res_op_in),
	
	.Qsrc(ldstr_Qsrc), 
	.Vsrc_valid_in(ldstr_Vsrc_valid_in),
	.Vsrc(ldstr_Vsrc),
	
	.Qbase(ldstr_Qbase), 	
	.Vbase_valid_in(ldstr_Vbase_valid_in),
	.Vbase(ldstr_Vbase),
	
	.offset_in(ldstr_offset),
	.dest(ldstr_dest),
	
	.CDB_in(C_D_B),
	
	.dmem_read(dmem_read), //.dmem_write(dmem_write),
	.dmem_wdata(dmem_wdata), .dmem_addr(dmem_address),
	.dmem_byte_enable(dmem_byte_enable),
	
	.full(ldstr_full),
	.CDB_out(load_buffer_CDB_out)
);

regfile regfile
(
	.clk, .flush,

	.ld_busy_ic(ld_reg_busy_dest),
	.ld_busy_rob(rob_ld_regfile_busy),
	.ld_rob_entry(ld_reg_busy_dest),
	.ld_value(ld_regfile_value),

	.rob_entry_in(reg_rob_entry),
	.sr1_ic(sr1), .sr2_ic(sr2), .dest_ic(reg_dest),
	.value_in(regfile_value_in),

	.dest_rob(rob_regfile_dest_in),
	.dest_wr, .dest_wr_out(dest_wr_data),

	.sr1_out(sr1_regfile_out), .sr2_out(sr2_regfile_out), .dest_out(dest_regfile_out)
);


endmodule: cpu_datapath
