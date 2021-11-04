onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /mp4_tb/f
add wave -noupdate /mp4_tb/dut/datapath/pc_reg/clk
add wave -noupdate /mp4_tb/dut/datapath/pc_reg/rst
add wave -noupdate /mp4_tb/dut/datapath/pc_reg/load
add wave -noupdate /mp4_tb/dut/datapath/pc_reg/in
add wave -noupdate /mp4_tb/dut/datapath/pc_reg/out
add wave -noupdate /mp4_tb/dut/datapath/pc_reg/data
add wave -noupdate /mp4_tb/dut/datapath/regfile/clk
add wave -noupdate /mp4_tb/dut/datapath/regfile/rst
add wave -noupdate /mp4_tb/dut/datapath/regfile/load
add wave -noupdate /mp4_tb/dut/datapath/regfile/in
add wave -noupdate /mp4_tb/dut/datapath/regfile/src_a
add wave -noupdate /mp4_tb/dut/datapath/regfile/src_b
add wave -noupdate /mp4_tb/dut/datapath/regfile/dest
add wave -noupdate /mp4_tb/dut/datapath/regfile/reg_a
add wave -noupdate /mp4_tb/dut/datapath/regfile/reg_b
add wave -noupdate /mp4_tb/dut/datapath/regfile/data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2020414218 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 269
configure wave -valuecolwidth 100
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
WaveRestoreZoom {2020414171 ps} {2020414849 ps}
