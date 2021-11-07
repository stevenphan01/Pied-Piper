onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /mp4_tb/f
add wave -noupdate /mp4_tb/dut/datapath/clk
add wave -noupdate -expand -group data_harzard /mp4_tb/dut/datapath/hdu/dmem_read
add wave -noupdate -expand -group data_harzard /mp4_tb/dut/datapath/hdu/data_resp_dp
add wave -noupdate -expand -group control_hazard /mp4_tb/dut/datapath/hdu/br_en
add wave -noupdate -expand -group control_hazard /mp4_tb/dut/datapath/hdu/jump_en
add wave -noupdate -expand -group control_hazard /mp4_tb/dut/datapath/hdu/inst_resp_dp
add wave -noupdate /mp4_tb/dut/instr_cache/control/state
add wave -noupdate /mp4_tb/dut/datapath/hdu/inst_read
add wave -noupdate -radix binary /mp4_tb/dut/inst_rdata_dp
add wave -noupdate /mp4_tb/dut/datapath/hdu/inst_resp_dp
add wave -noupdate /mp4_tb/dut/datapath/inst_addr_dp
add wave -noupdate /mp4_tb/dut/data_rdata_dp
add wave -noupdate /mp4_tb/dut/datapath/pc_out
add wave -noupdate /mp4_tb/dut/datapath/hdu/load_pc
add wave -noupdate /mp4_tb/dut/datapath/IF_ID_o
add wave -noupdate /mp4_tb/dut/datapath/ID_EX_o
add wave -noupdate /mp4_tb/dut/datapath/EX_MEM_i.DataWord.alu_out
add wave -noupdate /mp4_tb/dut/datapath/EX_MEM_o
add wave -noupdate /mp4_tb/dut/datapath/MEM_WB_o
add wave -noupdate /mp4_tb/dut/datapath/regfile/data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {991112 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 316
configure wave -valuecolwidth 272
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
WaveRestoreZoom {956484 ps} {1021033 ps}
