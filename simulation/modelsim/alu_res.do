onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /alu_res_testbench/rs/CDB_out
add wave -noupdate /alu_res_testbench/rs/Vj_out
add wave -noupdate /alu_res_testbench/rs/Vk_out
add wave -noupdate /alu_res_testbench/rs/Qj_out
add wave -noupdate /alu_res_testbench/rs/Qk_out
add wave -noupdate /alu_res_testbench/rs/dest_out
add wave -noupdate /alu_res_testbench/rs/op_out
add wave -noupdate /alu_res_testbench/rs/Vk_valid_out
add wave -noupdate /alu_res_testbench/rs/Vj_valid_out
add wave -noupdate /alu_res_testbench/rs/alu_out
add wave -noupdate /alu_res_testbench/rs/res_station_reg/Vk/load
add wave -noupdate /alu_res_testbench/rs/res_station_reg/Vk/clr
add wave -noupdate /alu_res_testbench/rs/res_station_reg/Vk/in
add wave -noupdate /alu_res_testbench/rs/res_station_reg/Vk/out
add wave -noupdate /alu_res_testbench/rs/res_station_reg/Vk/data
add wave -noupdate /alu_res_testbench/rs/res_station_reg/Vj_valid/load
add wave -noupdate /alu_res_testbench/rs/res_station_reg/Vj_valid/clr
add wave -noupdate /alu_res_testbench/rs/res_station_reg/Vj_valid/in
add wave -noupdate /alu_res_testbench/rs/res_station_reg/Vj_valid/out
add wave -noupdate /alu_res_testbench/rs/res_station_reg/Vj_valid/data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {16000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 223
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
configure wave -timelineunits ns
update
WaveRestoreZoom {15989 ps} {16051 ps}
