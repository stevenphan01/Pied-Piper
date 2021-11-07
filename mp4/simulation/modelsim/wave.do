onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /mp4_tb/f
add wave -noupdate /mp4_tb/f
add wave -noupdate /mp4_tb/dut/datapath/hdu/load_pc
add wave -noupdate /mp4_tb/dut/datapath/inst_read_dp
add wave -noupdate /mp4_tb/dut/datapath/data_read_dp
add wave -noupdate /mp4_tb/dut/arbiter/state
add wave -noupdate /mp4_tb/dut/instr_cache/control/state
add wave -noupdate /mp4_tb/dut/data_cache/control/state
add wave -noupdate /mp4_tb/dut/datapath/hdu/inst_read
add wave -noupdate /mp4_tb/dut/data_addr_dp
add wave -noupdate /mp4_tb/dut/data_rdata_dp
add wave -noupdate -expand -group hazard_state /mp4_tb/dut/datapath/hdu/br_en
add wave -noupdate -expand -group hazard_state /mp4_tb/dut/datapath/hdu/inst_resp_dp
add wave -noupdate -expand -group hazard_state /mp4_tb/dut/datapath/hdu/dmem_read
add wave -noupdate -expand -group hazard_state /mp4_tb/dut/datapath/hdu/data_resp_dp
add wave -noupdate /mp4_tb/dut/datapath/clk
add wave -noupdate -subitemconfig {/mp4_tb/dut/datapath/IF_ID_i.ControlWord -expand} /mp4_tb/dut/datapath/IF_ID_i
add wave -noupdate -subitemconfig {/mp4_tb/dut/datapath/ID_EX_i.ControlWord -expand} /mp4_tb/dut/datapath/ID_EX_i
add wave -noupdate -subitemconfig {/mp4_tb/dut/datapath/EX_MEM_i.ControlWord -expand} /mp4_tb/dut/datapath/EX_MEM_i
add wave -noupdate -subitemconfig {/mp4_tb/dut/datapath/MEM_WB_i.ControlWord -expand} /mp4_tb/dut/datapath/MEM_WB_i
add wave -noupdate /mp4_tb/dut/datapath/EX_MEM_i.DataWord.alu_out
add wave -noupdate /mp4_tb/dut/datapath/regfile/load
add wave -noupdate /mp4_tb/dut/datapath/pc_out
add wave -noupdate -expand /mp4_tb/dut/datapath/regfile/data
add wave -noupdate /mp4_tb/dut/instr_cache/datapath/DM_cache/data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {8272307103 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 357
configure wave -valuecolwidth 114
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
WaveRestoreZoom {8271975871 ps} {8272396007 ps}
