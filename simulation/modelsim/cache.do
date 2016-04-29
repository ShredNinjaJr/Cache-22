onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /mp3_tb/clk
add wave -noupdate /mp3_tb/pmem_resp
add wave -noupdate /mp3_tb/pmem_read
add wave -noupdate /mp3_tb/pmem_write
add wave -noupdate /mp3_tb/pmem_address
add wave -noupdate /mp3_tb/pmem_rdata
add wave -noupdate /mp3_tb/pmem_wdata
add wave -noupdate /mp3_tb/dut/imem_resp
add wave -noupdate /mp3_tb/dut/imem_read
add wave -noupdate /mp3_tb/dut/imem_rdata
add wave -noupdate /mp3_tb/dut/imem_address
add wave -noupdate /mp3_tb/dut/dmem_write
add wave -noupdate /mp3_tb/dut/dmem_wdata
add wave -noupdate /mp3_tb/dut/dmem_resp
add wave -noupdate /mp3_tb/dut/dmem_read
add wave -noupdate /mp3_tb/dut/dmem_rdata
add wave -noupdate /mp3_tb/dut/dmem_byte_enable
add wave -noupdate /mp3_tb/dut/dmem_address
add wave -noupdate /mp3_tb/dut/cache/L2_cache/datapath/tag_array0/data
add wave -noupdate /mp3_tb/dut/cache/L2_cache/datapath/tag_array1/data
add wave -noupdate /mp3_tb/dut/cache/L2_cache/datapath/data_array0/data
add wave -noupdate /mp3_tb/dut/cache/L2_cache/datapath/data_array1/data
add wave -noupdate /mp3_tb/dut/cache/L1_cache/arbiter/state
add wave -noupdate /mp3_tb/dut/cache/L1_cache/icache/cache_control/state
add wave -noupdate /mp3_tb/dut/cache/L1_cache/dcache/cache_control/state
add wave -noupdate /mp3_tb/dut/cache/L2_cache/control/state
add wave -noupdate /mp3_tb/dut/cache/L2_mem_write
add wave -noupdate /mp3_tb/dut/cache/L2_mem_wdata
add wave -noupdate /mp3_tb/dut/cache/L2_mem_resp
add wave -noupdate /mp3_tb/dut/cache/L2_mem_read
add wave -noupdate /mp3_tb/dut/cache/L2_mem_rdata
add wave -noupdate /mp3_tb/dut/cache/L2_mem_address
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
