onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /mp4_tb/f
add wave -noupdate /mp4_tb/f
add wave -noupdate /mp4_tb/f
add wave -noupdate /mp4_tb/dut/datapath/inst_read_dp
add wave -noupdate /mp4_tb/dut/datapath/data_read_dp
add wave -noupdate /mp4_tb/dut/arbiter/state
add wave -noupdate /mp4_tb/dut/instr_cache/control/state
add wave -noupdate /mp4_tb/dut/data_cache/control/state
add wave -noupdate /mp4_tb/dut/datapath/hdu/inst_read
add wave -noupdate /mp4_tb/dut/data_addr_dp
add wave -noupdate /mp4_tb/dut/data_rdata_dp
add wave -noupdate /mp4_tb/dut/datapath/data_write_dp
add wave -noupdate /mp4_tb/dut/datapath/pc_out
add wave -noupdate -expand -group hazard_state /mp4_tb/dut/datapath/hdu/br_en
add wave -noupdate -expand -group hazard_state /mp4_tb/dut/datapath/hdu/inst_resp_dp
add wave -noupdate -expand -group hazard_state /mp4_tb/dut/datapath/hdu/dmem_read
add wave -noupdate -expand -group hazard_state /mp4_tb/dut/datapath/hdu/data_resp_dp
add wave -noupdate /mp4_tb/dut/datapath/clk
add wave -noupdate /mp4_tb/dut/datapath/EX_MEM_i
add wave -noupdate /mp4_tb/dut/datapath/MEM_WB_i
add wave -noupdate -expand /mp4_tb/dut/datapath/regfile/data
add wave -noupdate -expand -subitemconfig {/mp4_tb/dut/datapath/EX_MEM_o.ControlWord -expand} /mp4_tb/dut/datapath/EX_MEM_o
add wave -noupdate -subitemconfig {/mp4_tb/dut/datapath/MEM_WB_o.ControlWord -expand /mp4_tb/dut/datapath/MEM_WB_o.DataWord -expand} /mp4_tb/dut/datapath/MEM_WB_o
add wave -noupdate /mp4_tb/dut/data_cache/datapath/DM_cache/data
add wave -noupdate /mp4_tb/dut/datapath/fu/dest_ex_mem
add wave -noupdate /mp4_tb/dut/datapath/fu/dest_mem_wb
add wave -noupdate /mp4_tb/dut/datapath/fu/src1
add wave -noupdate /mp4_tb/dut/datapath/fu/src2
add wave -noupdate /mp4_tb/dut/datapath/fu/data_ex_mem
add wave -noupdate /mp4_tb/dut/datapath/fu/data_mem_wb
add wave -noupdate /mp4_tb/dut/datapath/fu/data_mdr
add wave -noupdate /mp4_tb/dut/datapath/fu/ld_regfile_ex_mem
add wave -noupdate /mp4_tb/dut/datapath/fu/ld_regfile_mem_wb
add wave -noupdate /mp4_tb/dut/datapath/fu/dmem_read
add wave -noupdate /mp4_tb/dut/datapath/fu/alumux1_sel
add wave -noupdate /mp4_tb/dut/datapath/fu/alumux2_sel
add wave -noupdate /mp4_tb/dut/datapath/fu/cmpmux2_sel
add wave -noupdate /mp4_tb/dut/datapath/fu/ex_mem_forwarding_out1
add wave -noupdate /mp4_tb/dut/datapath/fu/mem_wb_forwarding_out1
add wave -noupdate /mp4_tb/dut/datapath/fu/ex_mem_forwarding_out2
add wave -noupdate /mp4_tb/dut/datapath/fu/mem_wb_forwarding_out2
add wave -noupdate /mp4_tb/dut/datapath/fu/ex_mem_forwarding_cmp1out
add wave -noupdate /mp4_tb/dut/datapath/fu/mem_wb_forwarding_cmp1out
add wave -noupdate /mp4_tb/dut/datapath/fu/ex_mem_forwarding_cmp2out
add wave -noupdate /mp4_tb/dut/datapath/fu/mem_wb_forwarding_cmp2out
add wave -noupdate /mp4_tb/dut/datapath/fu/forwarding_load1
add wave -noupdate /mp4_tb/dut/datapath/fu/forwarding_load2
add wave -noupdate /mp4_tb/dut/datapath/fu/forwarding_cmp1_load
add wave -noupdate /mp4_tb/dut/datapath/fu/forwarding_cmp2_load
add wave -noupdate /mp4_tb/dut/datapath/fu/forwarding_mux1
add wave -noupdate /mp4_tb/dut/datapath/fu/forwarding_mux2
add wave -noupdate /mp4_tb/dut/datapath/fu/forwarding_cmp1mux
add wave -noupdate /mp4_tb/dut/datapath/fu/forwarding_cmp2mux
add wave -noupdate /mp4_tb/dut/datapath/alumux1_out
add wave -noupdate /mp4_tb/dut/datapath/alumux2_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1386991 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 405
configure wave -valuecolwidth 121
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
WaveRestoreZoom {1343099 ps} {1443010 ps}
