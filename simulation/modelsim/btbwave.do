onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand /mp3_tb/dut/cpu_datapath/regfile/value_reg/data
add wave -noupdate /mp3_tb/dut/cpu_datapath/wr_control/valid_in
add wave -noupdate /mp3_tb/dut/cpu_datapath/wr_control/opcode_in
add wave -noupdate /mp3_tb/dut/cpu_datapath/wr_control/dest_in
add wave -noupdate /mp3_tb/dut/cpu_datapath/wr_control/value_in
add wave -noupdate /mp3_tb/dut/cpu_datapath/wr_control/predict_in
add wave -noupdate /mp3_tb/dut/cpu_datapath/wr_control/new_pc
add wave -noupdate /mp3_tb/dut/cpu_datapath/wr_control/branch_enable
add wave -noupdate /mp3_tb/dut/cpu_datapath/wr_control/cccomp/cc_in
add wave -noupdate /mp3_tb/dut/cpu_datapath/wr_control/cccomp/dest
add wave -noupdate /mp3_tb/dut/cpu_datapath/reorder_buffer/ROB/inst_out
add wave -noupdate /mp3_tb/dut/cpu_datapath/reorder_buffer/ROB/dest_out
add wave -noupdate /mp3_tb/dut/cpu_datapath/reorder_buffer/ROB/valid_out
add wave -noupdate /mp3_tb/dut/cpu_datapath/reorder_buffer/ROB/value_out
add wave -noupdate /mp3_tb/dut/cpu_datapath/reorder_buffer/ROB/predict_out
add wave -noupdate /mp3_tb/dut/cpu_datapath/reorder_buffer/orig_pc_out
add wave -noupdate /mp3_tb/dut/cpu_datapath/fetch_unit/pcmux_sel
add wave -noupdate /mp3_tb/dut/cpu_datapath/fetch_unit/hit
add wave -noupdate /mp3_tb/dut/cpu_datapath/BTB/hit
add wave -noupdate /mp3_tb/dut/cpu_datapath/fetch_unit/pc/data
add wave -noupdate /mp3_tb/dut/cpu_datapath/BTB/pc
add wave -noupdate /mp3_tb/dut/cpu_datapath/issue_control/instruction_pc
add wave -noupdate /mp3_tb/dut/cpu_datapath/issue_control/opcode
add wave -noupdate /mp3_tb/dut/cpu_datapath/issue_control/rob_write_enable
add wave -noupdate /mp3_tb/dut/cpu_datapath/issue_control/btb_hit
add wave -noupdate /mp3_tb/dut/cpu_datapath/issue_control/btb_predict
add wave -noupdate /mp3_tb/dut/cpu_datapath/issue_control/predict_bit
add wave -noupdate /mp3_tb/dut/cpu_datapath/issue_control/branch_stall
add wave -noupdate /mp3_tb/dut/cpu_datapath/BTB/branch_tag
add wave -noupdate /mp3_tb/dut/cpu_datapath/BTB/branch_index
add wave -noupdate /mp3_tb/dut/cpu_datapath/BTB/valid_array/data
add wave -noupdate /mp3_tb/dut/cpu_datapath/BTB/tag_array/data
add wave -noupdate /mp3_tb/dut/cpu_datapath/BTB/data_array/data
add wave -noupdate /mp3_tb/dut/cpu_datapath/BTB/predict_array/data
add wave -noupdate /mp3_tb/dut/cpu_datapath/predict_unit/BHT/bht
add wave -noupdate /mp3_tb/dut/cpu_datapath/predict_unit/PHT/pht
add wave -noupdate /mp3_tb/dut/cpu_datapath/predict_unit/new_pc
add wave -noupdate /mp3_tb/dut/cpu_datapath/predict_unit/pred_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2065000 ps} 0}
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
WaveRestoreZoom {0 ps} {4210816 ps}
