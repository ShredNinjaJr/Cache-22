onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /mp3_tb/dut/cpu_datapath/fetch_unit/pc/out
add wave -noupdate -expand /mp3_tb/dut/cpu_datapath/regfile/value_reg/data
add wave -noupdate /mp3_tb/dut/cpu_datapath/regfile/ld_busy_ic
add wave -noupdate /mp3_tb/dut/cpu_datapath/regfile/ld_busy_rob
add wave -noupdate /mp3_tb/dut/cpu_datapath/regfile/ld_rob_entry
add wave -noupdate /mp3_tb/dut/cpu_datapath/regfile/ld_value
add wave -noupdate /mp3_tb/dut/cpu_datapath/regfile/rob_entry_in
add wave -noupdate /mp3_tb/dut/cpu_datapath/regfile/value_in
add wave -noupdate /mp3_tb/dut/cpu_datapath/regfile/sr1_ic
add wave -noupdate /mp3_tb/dut/cpu_datapath/regfile/sr2_ic
add wave -noupdate /mp3_tb/dut/cpu_datapath/regfile/dest_ic
add wave -noupdate /mp3_tb/dut/cpu_datapath/regfile/sr1_rob
add wave -noupdate /mp3_tb/dut/cpu_datapath/regfile/sr2_rob
add wave -noupdate /mp3_tb/dut/cpu_datapath/regfile/dest_rob
add wave -noupdate -expand /mp3_tb/dut/cpu_datapath/regfile/sr1_out
add wave -noupdate /mp3_tb/dut/cpu_datapath/regfile/sr2_out
add wave -noupdate /mp3_tb/dut/cpu_datapath/regfile/dest_out
add wave -noupdate /mp3_tb/dut/cpu_datapath/regfile/ld_busy
add wave -noupdate /mp3_tb/dut/cpu_datapath/regfile/busy_in
add wave -noupdate /mp3_tb/dut/cpu_datapath/regfile/sr1_busy
add wave -noupdate /mp3_tb/dut/cpu_datapath/regfile/sr2_busy
add wave -noupdate /mp3_tb/dut/cpu_datapath/regfile/dest_busy
add wave -noupdate /mp3_tb/dut/cpu_datapath/C_D_B
add wave -noupdate /mp3_tb/dut/cpu_datapath/reorder_buffer/ROB/empty
add wave -noupdate /mp3_tb/dut/cpu_datapath/reorder_buffer/ROB/r_addr
add wave -noupdate /mp3_tb/dut/cpu_datapath/reorder_buffer/ROB/w_addr
add wave -noupdate -expand /mp3_tb/dut/cpu_datapath/reorder_buffer/ROB/value
add wave -noupdate -expand /mp3_tb/dut/cpu_datapath/reorder_buffer/ROB/dest
add wave -noupdate -expand /mp3_tb/dut/cpu_datapath/reorder_buffer/ROB/inst
add wave -noupdate /mp3_tb/dut/cpu_datapath/wr_control/value_in
add wave -noupdate /mp3_tb/dut/cpu_datapath/wr_control/dest_a
add wave -noupdate /mp3_tb/dut/cpu_datapath/wr_control/ld_regfile_value
add wave -noupdate /mp3_tb/dut/cpu_datapath/wr_control/ld_regfile_busy
add wave -noupdate /mp3_tb/dut/cpu_datapath/wr_control/RE_out
add wave -noupdate /mp3_tb/dut/cpu_datapath/regfile/busy_reg/data
add wave -noupdate /mp3_tb/dut/cpu_datapath/regfile/rob_entry_reg/data
add wave -noupdate /mp3_tb/dut/cpu_datapath/alu_RS/CDB_arbiter/clk
add wave -noupdate /mp3_tb/dut/cpu_datapath/alu_RS/CDB_arbiter/CDB_out
add wave -noupdate /mp3_tb/dut/cpu_datapath/alu_RS/CDB_arbiter/i
add wave -noupdate /mp3_tb/dut/cpu_datapath/alu_RS/CDB_arbiter/pri_en_valid
add wave -noupdate /mp3_tb/dut/cpu_datapath/alu_RS/CDB_arbiter/pri_en_out
add wave -noupdate -expand /mp3_tb/dut/cpu_datapath/alu_RS/RS_CDB_out
add wave -noupdate {/mp3_tb/dut/cpu_datapath/alu_RS/RS_generate[0]/RS/dest}
add wave -noupdate {/mp3_tb/dut/cpu_datapath/alu_RS/RS_generate[0]/RS/Vj_in}
add wave -noupdate {/mp3_tb/dut/cpu_datapath/alu_RS/RS_generate[0]/RS/Vk_in}
add wave -noupdate {/mp3_tb/dut/cpu_datapath/alu_RS/RS_generate[0]/RS/Qj_in}
add wave -noupdate {/mp3_tb/dut/cpu_datapath/alu_RS/RS_generate[0]/RS/Qk_in}
add wave -noupdate {/mp3_tb/dut/cpu_datapath/alu_RS/RS_generate[0]/RS/dest_in}
add wave -noupdate {/mp3_tb/dut/cpu_datapath/alu_RS/RS_generate[0]/RS/Vj_out}
add wave -noupdate {/mp3_tb/dut/cpu_datapath/alu_RS/RS_generate[0]/RS/Vk_out}
add wave -noupdate {/mp3_tb/dut/cpu_datapath/alu_RS/RS_generate[0]/RS/Qj_out}
add wave -noupdate {/mp3_tb/dut/cpu_datapath/alu_RS/RS_generate[0]/RS/Qk_out}
add wave -noupdate {/mp3_tb/dut/cpu_datapath/alu_RS/RS_generate[0]/RS/dest_out}
add wave -noupdate {/mp3_tb/dut/cpu_datapath/alu_RS/RS_generate[0]/RS/op_out}
add wave -noupdate {/mp3_tb/dut/cpu_datapath/alu_RS/RS_generate[0]/RS/aluop}
add wave -noupdate {/mp3_tb/dut/cpu_datapath/alu_RS/RS_generate[0]/RS/alu_out}
add wave -noupdate {/mp3_tb/dut/cpu_datapath/alu_RS/RS_generate[0]/RS/flush}
add wave -noupdate {/mp3_tb/dut/cpu_datapath/alu_RS/RS_generate[0]/RS/op_in}
add wave -noupdate {/mp3_tb/dut/cpu_datapath/alu_RS/RS_generate[0]/RS/issue_ld_Vj}
add wave -noupdate {/mp3_tb/dut/cpu_datapath/alu_RS/RS_generate[0]/RS/issue_ld_Vk}
add wave -noupdate {/mp3_tb/dut/cpu_datapath/alu_RS/RS_generate[0]/RS/issue_ld_Qk}
add wave -noupdate {/mp3_tb/dut/cpu_datapath/alu_RS/RS_generate[0]/RS/issue_ld_Qj}
add wave -noupdate /mp3_tb/dut/cpu_datapath/alu_RS/RS_decoder/ld_busy
add wave -noupdate /mp3_tb/dut/cpu_datapath/alu_RS/RS_decoder/issue_ld_Vj
add wave -noupdate /mp3_tb/dut/cpu_datapath/alu_RS/RS_decoder/issue_ld_Vk
add wave -noupdate /mp3_tb/dut/cpu_datapath/alu_RS/RS_decoder/issue_ld_Qk
add wave -noupdate /mp3_tb/dut/cpu_datapath/alu_RS/RS_decoder/issue_ld_Qj
add wave -noupdate /mp3_tb/dut/cpu_datapath/alu_RS/RS_decoder/res_station_id
add wave -noupdate /mp3_tb/dut/cpu_datapath/alu_RS/RS_decoder/j
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
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
WaveRestoreZoom {0 ps} {105 ns}
