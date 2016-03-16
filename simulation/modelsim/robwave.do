onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /rob_testbench/clk
add wave -noupdate -radix hexadecimal /rob_testbench/WE
add wave -noupdate -radix hexadecimal /rob_testbench/RE
add wave -noupdate -radix hexadecimal /rob_testbench/flush
add wave -noupdate -radix hexadecimal /rob_testbench/ld_value
add wave -noupdate -radix hexadecimal /rob_testbench/ld_busy
add wave -noupdate -radix hexadecimal /rob_testbench/ld_tag
add wave -noupdate -radix hexadecimal /rob_testbench/ld_inst
add wave -noupdate -radix hexadecimal /rob_testbench/ld_valid
add wave -noupdate -radix hexadecimal /rob_testbench/ld_predict
add wave -noupdate -radix hexadecimal /rob_testbench/value_in
add wave -noupdate -radix hexadecimal /rob_testbench/tag_in
add wave -noupdate -radix hexadecimal /rob_testbench/inst_in
add wave -noupdate -radix hexadecimal /rob_testbench/busy_in
add wave -noupdate -radix hexadecimal /rob_testbench/valid_in
add wave -noupdate -radix hexadecimal /rob_testbench/predict_in
add wave -noupdate -radix hexadecimal /rob_testbench/value_out
add wave -noupdate -radix hexadecimal /rob_testbench/tag_out
add wave -noupdate -radix hexadecimal /rob_testbench/inst_out
add wave -noupdate -radix hexadecimal /rob_testbench/busy_out
add wave -noupdate -radix hexadecimal /rob_testbench/valid_out
add wave -noupdate -radix hexadecimal /rob_testbench/predict_out
add wave -noupdate -radix hexadecimal /rob_testbench/addr_in
add wave -noupdate -radix hexadecimal /rob_testbench/ROB/r_addr
add wave -noupdate -radix hexadecimal /rob_testbench/ROB/w_addr
add wave -noupdate /rob_testbench/ROB/empty
add wave -noupdate /rob_testbench/ROB/full
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {12252 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 212
configure wave -valuecolwidth 79
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {0 ps} {247187 ps}
