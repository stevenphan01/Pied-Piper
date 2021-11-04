onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /mp4_tb/dut/arbiter/inst_pmem_resp
add wave -noupdate /mp4_tb/dut/arbiter/inst_pmem_address
add wave -noupdate /mp4_tb/dut/arbiter/inst_pmem_rdata
add wave -noupdate /mp4_tb/dut/mem_addr
add wave -noupdate /mp4_tb/dut/arbiter/inst_pmem_read
add wave -noupdate /mp4_tb/dut/mem_read
add wave -noupdate /mp4_tb/dut/arbiter/resp_o
add wave -noupdate /mp4_tb/dut/mem_resp
add wave -noupdate /mp4_tb/dut/arbiter/state
add wave -noupdate /mp4_tb/dut/arbiter/cacheline_adaptor/burst_i
add wave -noupdate /mp4_tb/dut/arbiter/cacheline_adaptor/line_o
add wave -noupdate /mp4_tb/dut/arbiter/inst_pmem_resp
add wave -noupdate /mp4_tb/dut/arbiter/inst_pmem_address
add wave -noupdate /mp4_tb/dut/arbiter/inst_pmem_rdata
add wave -noupdate /mp4_tb/dut/mem_addr
add wave -noupdate /mp4_tb/dut/datapath/clk
add wave -noupdate /mp4_tb/dut/arbiter/inst_pmem_read
add wave -noupdate /mp4_tb/dut/mem_read
add wave -noupdate /mp4_tb/dut/arbiter/resp_o
add wave -noupdate /mp4_tb/dut/mem_resp
add wave -noupdate /mp4_tb/dut/arbiter/state
add wave -noupdate -expand /mp4_tb/dut/arbiter/cacheline_adaptor/state
add wave -noupdate /mp4_tb/dut/mem_addr
add wave -noupdate /mp4_tb/dut/arbiter/cacheline_adaptor/address_i
add wave -noupdate /mp4_tb/dut/arbiter/cacheline_adaptor/address_o
add wave -noupdate /mp4_tb/dut/mem_rdata
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {570000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 377
configure wave -valuecolwidth 185
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
configure wave -timelineunits ns
update
WaveRestoreZoom {416010 ps} {713162 ps}
