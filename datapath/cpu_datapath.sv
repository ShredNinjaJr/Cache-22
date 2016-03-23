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
	output logic imem_read,
	output logic dmem_read,
	output logic dmem_write
);

CDB C_D_B;
CDB load_buffer_CDB_out;
logic flush = 0;
logic bit5;
lc3b_word ir_out, pc_out;

logic ld_buf_valid_in;

/**********************************************CHANGE PCMUX_SEL *****************************/
fetch_unit fetch_unit
(
	.clk,
	.imem_rdata, .imem_read, .imem_address, .imem_resp,
	.pcmux_sel(2'b0), .ir_out, .pc_out	
);

/* Reservation station -> Issue Control */

logic alu_RS_busy [0:2];

/* Load Buffer -> Issue Control */
logic ld_buffer_full;

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

/* Issue Control -> Load Buffer */
logic load_buf_write_enable;
lc3b_word load_buf_offset;

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

issue_control issue_control
(
	.clk,
	// Fetch -> Issue Controlj
	.instr(ir_out),
	.instr_is_new(1'b1),
	.curr_pc(pc_out),
	// CDB -> Issue Control
	.CDB_in(C_D_B),
	// Reservation Station -> Issue Control
	.alu_res1_busy(alu_RS_busy[0]), .alu_res2_busy(alu_RS_busy[1]), .alu_res3_busy(alu_RS_busy[2]),
	.ld_buffer_full(ld_buffer_full),
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

	// Issue Control -> Reservation Station
	.res_op_in,
	.res_Vj, .res_Vk,
	.res_Qj, .res_Qk, .res_dest,
	.issue_ld_busy_dest, .issue_ld_Vj, .issue_ld_Vk, 
	.issue_ld_Qk, .issue_ld_Qj, 
	.res_station_id,
	.bit5,
//	 logic  res_validJ, res_validK, // [valid J, valid K]
	// Issue Control -> Load Buffer
	.load_buf_write_enable(load_buf_write_enable),
	.load_buf_offset(load_buf_offset),
	.load_buf_valid_in(ld_buf_valid_in),
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
	.rob_sr2_read_addr

);


logic RE_out;
logic rob_valid_out;
lc3b_opcode rob_opcode_out;
lc3b_reg rob_dest_out;
lc3b_word rob_value_out;

reorder_buffer reorder_buffer
(
	.clk, .flush,
	.WE(rob_write_enable),
	.RE(RE_out),
	
	/*inputs*/
	.inst(rob_opcode_in),
	.dest(rob_dest_in),
	.value(rob_value_in),
	.predict(1'b1),
	//.addr(rob_	
	.CDB_in(C_D_B),

	.sr1_read_addr(rob_sr1_read_addr),
	.sr2_read_addr(rob_sr2_read_addr),
	
	.addr_out(rob_addr),
	
	.valid_out(rob_valid_out),
	.inst_out(rob_opcode_out),
	.dest_out(rob_dest_out),
	.value_out(rob_value_out),
//	.predict_out)
	
	.full_out(rob_full),

	.sr1_value_out(rob_sr1_value_out),
	.sr2_value_out(rob_sr2_value_out),
	.sr1_valid_out(rob_sr1_valid_out),
	.sr2_valid_out(rob_sr2_valid_out)
);


lc3b_reg rob_regfile_dest_in;
lc3b_word regfile_value_in;
logic ld_regfile_value, rob_ld_regfile_busy;



write_results_control wr_control
(
	.clk,
	.valid_in(rob_valid_out),
	.opcode_in(rob_opcode_out),
	.dest_in(rob_dest_out),
	.value_in(rob_value_out),
	
	
	/* To regfile */
	.dest_a(rob_regfile_dest_in),
	.value_out(regfile_value_in),
	.ld_regfile_value,
	.ld_regfile_busy(rob_ld_regfile_busy),
	
	/* TO ROB */
	.RE_out
);


logic ld_buffer_flush;

alu_RS_unit alu_RS
(
	.clk,
	.flush(flush),
	.op_in(res_op_in),
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


load_buffer load_buffer
(
	.clk,
	/* From Issue Control */
	.WE(load_buf_write_enable),
	.flush(flush),
	.ld_buffer_read(ld_buffer_flush),
	.Q_in(res_Qj),
	.V(res_Vj),
	.offset_in(load_buf_offset),
	.dest_in(res_dest),
	.valid_in(ld_buf_valid_in),
	.dmem_resp(dmem_resp),
	.dmem_rdata(dmem_rdata),
	
	.CDB_in(C_D_B),
	.CDB_out(load_buffer_CDB_out),
	
	.dmem_addr(dmem_address),
	.dmem_read(dmem_read),
	.full(ld_buffer_full)
);



regfile regfile
(
	.clk,

	.ld_busy_ic(ld_reg_busy_dest),
	.ld_busy_rob(rob_ld_regfile_busy),
	.ld_rob_entry(ld_reg_busy_dest),
	.ld_value(ld_regfile_value),

	.rob_entry_in(reg_rob_entry),
	.sr1_ic(sr1), .sr2_ic(sr2), .dest_ic(reg_dest),
	.value_in(regfile_value_in),

	.dest_rob(rob_regfile_dest_in),

	.sr1_out(sr1_regfile_out), .sr2_out(sr2_regfile_out), .dest_out(dest_regfile_out)
);


endmodule: cpu_datapath
