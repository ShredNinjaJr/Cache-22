onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /mp3_tb/dut/cpu_datapath/pc_out
add wave -noupdate /mp3_tb/dut/imem_resp
add wave -noupdate /mp3_tb/dut/imem_read
add wave -noupdate /mp3_tb/dut/imem_rdata
add wave -noupdate /mp3_tb/dut/imem_address
add wave -noupdate /mp3_tb/dut/dmem_write
add wave -noupdate /mp3_tb/dut/L1_cache/dcache/pmem_read
add wave -noupdate /mp3_tb/dut/dmem_wdata
add wave -noupdate /mp3_tb/dut/dmem_resp
add wave -noupdate /mp3_tb/dut/dmem_read
add wave -noupdate /mp3_tb/dut/dmem_rdata
add wave -noupdate /mp3_tb/dut/dmem_byte_enable
add wave -noupdate /mp3_tb/dut/dmem_address
add wave -noupdate /mp3_tb/dut/L1_cache/arbiter/state
add wave -noupdate -expand /mp3_tb/dut/cpu_datapath/regfile/value_reg/data
add wave -noupdate /mp3_tb/dut/cpu_datapath/ir_out
add wave -noupdate /mp3_tb/dut/cpu_datapath/issue_control/adj9_out
add wave -noupdate /mp3_tb/dut/cpu_datapath/issue_control/curr_pc
add wave -noupdate /mp3_tb/dut/cpu_datapath/issue_control/instr_is_new
add wave -noupdate -expand /mp3_tb/dut/cpu_datapath/alu_RS/CDB_arbiter/RS_CDB_in
add wave -noupdate /mp3_tb/dut/cpu_datapath/alu_RS/CDB_arbiter/RS_flush
add wave -noupdate /mp3_tb/dut/cpu_datapath/alu_RS/CDB_arbiter/CDB_out
add wave -noupdate /mp3_tb/dut/cpu_datapath/alu_RS/CDB_arbiter/i
add wave -noupdate /mp3_tb/dut/cpu_datapath/alu_RS/CDB_arbiter/pri_en_valid
add wave -noupdate /mp3_tb/dut/cpu_datapath/alu_RS/CDB_arbiter/pri_en_out
add wave -noupdate /mp3_tb/dut/cpu_datapath/alu_RS/RS_decoder/ld_busy
add wave -noupdate /mp3_tb/dut/cpu_datapath/alu_RS/RS_decoder/issue_ld_Vj
add wave -noupdate /mp3_tb/dut/cpu_datapath/alu_RS/RS_decoder/issue_ld_Vk
add wave -noupdate /mp3_tb/dut/cpu_datapath/alu_RS/RS_decoder/issue_ld_Qk
add wave -noupdate /mp3_tb/dut/cpu_datapath/alu_RS/RS_decoder/issue_ld_Qj
add wave -noupdate /mp3_tb/dut/cpu_datapath/alu_RS/RS_decoder/res_station_id
add wave -noupdate /mp3_tb/dut/cpu_datapath/alu_RS/RS_decoder/RS_ld_busy
add wave -noupdate /mp3_tb/dut/cpu_datapath/alu_RS/RS_decoder/RS_issue_ld_Vj
add wave -noupdate /mp3_tb/dut/cpu_datapath/alu_RS/RS_decoder/RS_issue_ld_Vk
add wave -noupdate /mp3_tb/dut/cpu_datapath/alu_RS/RS_decoder/RS_issue_ld_Qk
add wave -noupdate /mp3_tb/dut/cpu_datapath/alu_RS/RS_decoder/RS_issue_ld_Qj
add wave -noupdate /mp3_tb/dut/cpu_datapath/alu_RS/ld_buffer_flush
add wave -noupdate /mp3_tb/dut/cpu_datapath/alu_RS/RS_flush
add wave -noupdate /mp3_tb/dut/cpu_datapath/alu_RS/RS_ld_busy
add wave -noupdate /mp3_tb/dut/cpu_datapath/alu_RS/RS_issue_ld_Vj
add wave -noupdate /mp3_tb/dut/cpu_datapath/alu_RS/RS_issue_ld_Vk
add wave -noupdate /mp3_tb/dut/cpu_datapath/alu_RS/RS_issue_ld_Qk
add wave -noupdate /mp3_tb/dut/cpu_datapath/alu_RS/RS_issue_ld_Qj
add wave -noupdate /mp3_tb/dut/cpu_datapath/alu_RS/RS_CDB_out
add wave -noupdate {/mp3_tb/dut/cpu_datapath/alu_RS/RS_generate[2]/RS/Vj_out}
add wave -noupdate {/mp3_tb/dut/cpu_datapath/alu_RS/RS_generate[2]/RS/Vk_out}
add wave -noupdate {/mp3_tb/dut/cpu_datapath/alu_RS/RS_generate[2]/RS/Qj_out}
add wave -noupdate {/mp3_tb/dut/cpu_datapath/alu_RS/RS_generate[2]/RS/Qk_out}
add wave -noupdate {/mp3_tb/dut/cpu_datapath/alu_RS/RS_generate[2]/RS/dest_out}
add wave -noupdate {/mp3_tb/dut/cpu_datapath/alu_RS/RS_generate[2]/RS/op_out}
add wave -noupdate {/mp3_tb/dut/cpu_datapath/alu_RS/RS_generate[2]/RS/Vk_valid_out}
add wave -noupdate {/mp3_tb/dut/cpu_datapath/alu_RS/RS_generate[2]/RS/Vj_valid_out}
add wave -noupdate {/mp3_tb/dut/cpu_datapath/alu_RS/RS_generate[1]/RS/Vj_out}
add wave -noupdate {/mp3_tb/dut/cpu_datapath/alu_RS/RS_generate[1]/RS/Vk_out}
add wave -noupdate {/mp3_tb/dut/cpu_datapath/alu_RS/RS_generate[1]/RS/Qj_out}
add wave -noupdate {/mp3_tb/dut/cpu_datapath/alu_RS/RS_generate[1]/RS/Qk_out}
add wave -noupdate {/mp3_tb/dut/cpu_datapath/alu_RS/RS_generate[1]/RS/dest_out}
add wave -noupdate {/mp3_tb/dut/cpu_datapath/alu_RS/RS_generate[1]/RS/op_out}
add wave -noupdate {/mp3_tb/dut/cpu_datapath/alu_RS/RS_generate[1]/RS/Vk_valid_out}
add wave -noupdate {/mp3_tb/dut/cpu_datapath/alu_RS/RS_generate[1]/RS/Vj_valid_out}
add wave -noupdate {/mp3_tb/dut/cpu_datapath/alu_RS/RS_generate[0]/RS/Vj_out}
add wave -noupdate {/mp3_tb/dut/cpu_datapath/alu_RS/RS_generate[0]/RS/Vk_out}
add wave -noupdate {/mp3_tb/dut/cpu_datapath/alu_RS/RS_generate[0]/RS/Qj_out}
add wave -noupdate {/mp3_tb/dut/cpu_datapath/alu_RS/RS_generate[0]/RS/Qk_out}
add wave -noupdate {/mp3_tb/dut/cpu_datapath/alu_RS/RS_generate[0]/RS/dest_out}
add wave -noupdate {/mp3_tb/dut/cpu_datapath/alu_RS/RS_generate[0]/RS/op_out}
add wave -noupdate {/mp3_tb/dut/cpu_datapath/alu_RS/RS_generate[0]/RS/Vk_valid_out}
add wave -noupdate {/mp3_tb/dut/cpu_datapath/alu_RS/RS_generate[0]/RS/Vj_valid_out}
add wave -noupdate /mp3_tb/dut/cpu_datapath/wr_control/data_width
add wave -noupdate /mp3_tb/dut/cpu_datapath/wr_control/tag_width
add wave -noupdate /mp3_tb/dut/cpu_datapath/wr_control/clk
add wave -noupdate /mp3_tb/dut/cpu_datapath/wr_control/valid_in
add wave -noupdate /mp3_tb/dut/cpu_datapath/wr_control/opcode_in
add wave -noupdate /mp3_tb/dut/cpu_datapath/wr_control/dest_in
add wave -noupdate /mp3_tb/dut/cpu_datapath/wr_control/value_in
add wave -noupdate /mp3_tb/dut/cpu_datapath/wr_control/predict_in
add wave -noupdate /mp3_tb/dut/cpu_datapath/wr_control/dest_a
add wave -noupdate /mp3_tb/dut/cpu_datapath/wr_control/value_out
add wave -noupdate /mp3_tb/dut/cpu_datapath/wr_control/ld_regfile_value
add wave -noupdate /mp3_tb/dut/cpu_datapath/wr_control/ld_regfile_busy
add wave -noupdate /mp3_tb/dut/cpu_datapath/wr_control/RE_out
add wave -noupdate /mp3_tb/dut/cpu_datapath/wr_control/flush
add wave -noupdate /mp3_tb/dut/cpu_datapath/wr_control/pcmux_sel
add wave -noupdate /mp3_tb/dut/cpu_datapath/wr_control/new_pc
add wave -noupdate /mp3_tb/dut/cpu_datapath/wr_control/ld_cc
add wave -noupdate /mp3_tb/dut/cpu_datapath/wr_control/gencc_out
add wave -noupdate /mp3_tb/dut/cpu_datapath/wr_control/cc_out
add wave -noupdate /mp3_tb/dut/cpu_datapath/wr_control/branch_enable
add wave -noupdate /mp3_tb/dut/cpu_datapath/wr_control/cccomp/cc_in
add wave -noupdate /mp3_tb/dut/cpu_datapath/wr_control/cccomp/dest
add wave -noupdate /mp3_tb/dut/cpu_datapath/reorder_buffer/ROB/inst_out
add wave -noupdate /mp3_tb/dut/cpu_datapath/reorder_buffer/ROB/dest_out
add wave -noupdate /mp3_tb/dut/cpu_datapath/reorder_buffer/ROB/valid_out
add wave -noupdate /mp3_tb/dut/cpu_datapath/reorder_buffer/ROB/value_out
add wave -noupdate /mp3_tb/dut/cpu_datapath/reorder_buffer/ROB/predict_out
add wave -noupdate /mp3_tb/dut/cpu_datapath/reorder_buffer/ROB/addr_out
add wave -noupdate /mp3_tb/dut/cpu_datapath/reorder_buffer/ROB/r_addr
add wave -noupdate /mp3_tb/dut/cpu_datapath/reorder_buffer/ROB/w_addr
add wave -noupdate /mp3_tb/dut/cpu_datapath/reorder_buffer/inst
add wave -noupdate /mp3_tb/dut/cpu_datapath/reorder_buffer/ld_value
add wave -noupdate /mp3_tb/dut/cpu_datapath/reorder_buffer/ld_dest
add wave -noupdate /mp3_tb/dut/cpu_datapath/reorder_buffer/ld_inst
add wave -noupdate /mp3_tb/dut/cpu_datapath/reorder_buffer/ld_valid
add wave -noupdate /mp3_tb/dut/cpu_datapath/reorder_buffer/ld_predict
add wave -noupdate /mp3_tb/dut/cpu_datapath/issue_control/rob_value_in
add wave -noupdate -expand /mp3_tb/dut/cpu_datapath/reorder_buffer/ROB/value
add wave -noupdate /mp3_tb/dut/cpu_datapath/reorder_buffer/ROB/dest
add wave -noupdate -expand /mp3_tb/dut/cpu_datapath/reorder_buffer/ROB/inst
add wave -noupdate /mp3_tb/dut/cpu_datapath/reorder_buffer/ROB/valid
add wave -noupdate /mp3_tb/dut/cpu_datapath/reorder_buffer/ROB/predict
add wave -noupdate /mp3_tb/dut/cpu_datapath/reorder_buffer/ROB/cnt
add wave -noupdate /mp3_tb/dut/cpu_datapath/wr_control/rob_empty
add wave -noupdate /mp3_tb/dut/cpu_datapath/reorder_buffer/flush
add wave -noupdate /mp3_tb/dut/cpu_datapath/reorder_buffer/ROB/full
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {113655 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 213
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 2
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {656250 ps}
