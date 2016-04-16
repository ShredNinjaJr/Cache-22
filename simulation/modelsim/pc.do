onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /mp3_tb/dut/cache/L1_cache/icache/L1_icache_control/icache_miss_count
add wave -noupdate /mp3_tb/dut/cache/L1_cache/dcache/L1_dcache_control/dcache_miss_count
add wave -noupdate /mp3_tb/dut/cache/L2_cache/L2_control/l2_miss_count
add wave -noupdate /mp3_tb/dut/cpu_datapath/wr_control/branch_mispredict_count
add wave -noupdate /mp3_tb/dut/cpu_datapath/wr_control/branch_count
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
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
WaveRestoreZoom {199050 ps} {200050 ps}
