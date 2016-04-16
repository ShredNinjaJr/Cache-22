onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /mp3_tb/dut/cache/L1_cache/icache/L1_icache_control/icache_miss_count
add wave -noupdate /mp3_tb/dut/cache/L1_cache/dcache/L1_dcache_control/dcache_miss_count
add wave -noupdate /mp3_tb/dut/cache/L2_cache/L2_control/l2_miss_count
add wave -noupdate /mp3_tb/dut/cpu_datapath/wr_control/branch_mispredict_count
add wave -noupdate /mp3_tb/dut/cpu_datapath/wr_control/branch_count
add wave -noupdate /mp3_tb/dut/cpu_datapath/fetch_unit/pc_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3103029958 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 270
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
WaveRestoreZoom {3102622304 ps} {3103606865 ps}
