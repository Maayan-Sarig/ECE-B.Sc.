onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_datapath/add_op
add wave -noupdate /tb_datapath/Ain
add wave -noupdate /tb_datapath/ALUFN
add wave -noupdate /tb_datapath/and_op
add wave -noupdate /tb_datapath/Cflag
add wave -noupdate /tb_datapath/clk
add wave -noupdate /tb_datapath/done
add wave -noupdate /tb_datapath/done_DM
add wave -noupdate /tb_datapath/done_op
add wave -noupdate /tb_datapath/done_PM
add wave -noupdate /tb_datapath/DTCM_addr_in
add wave -noupdate /tb_datapath/DTCM_addr_out
add wave -noupdate /tb_datapath/DTCM_addr_sel
add wave -noupdate /tb_datapath/DTCM_out
add wave -noupdate /tb_datapath/DTCM_tb_addr_in
add wave -noupdate /tb_datapath/DTCM_tb_addr_out
add wave -noupdate /tb_datapath/DTCM_tb_in
add wave -noupdate /tb_datapath/DTCM_tb_out
add wave -noupdate /tb_datapath/DTCM_tb_wr
add wave -noupdate /tb_datapath/DTCM_wr
add wave -noupdate /tb_datapath/Imm1_in
add wave -noupdate /tb_datapath/Imm2_in
add wave -noupdate /tb_datapath/IRin
add wave -noupdate /tb_datapath/ITCM_tb_addr_in
add wave -noupdate /tb_datapath/ITCM_tb_in
add wave -noupdate /tb_datapath/ITCM_tb_wr
add wave -noupdate /tb_datapath/jc_op
add wave -noupdate /tb_datapath/jmp_op
add wave -noupdate /tb_datapath/jnc_op
add wave -noupdate /tb_datapath/ld_op
add wave -noupdate /tb_datapath/mov_op
add wave -noupdate /tb_datapath/Nflag
add wave -noupdate /tb_datapath/or_op
add wave -noupdate /tb_datapath/PCin
add wave -noupdate /tb_datapath/PCsel
add wave -noupdate /tb_datapath/RFaddr_rd
add wave -noupdate /tb_datapath/RFaddr_wr
add wave -noupdate /tb_datapath/RFin
add wave -noupdate /tb_datapath/RFout
add wave -noupdate /tb_datapath/rst_control
add wave -noupdate /tb_datapath/st_op
add wave -noupdate /tb_datapath/sub_op
add wave -noupdate /tb_datapath/TBactive
add wave -noupdate /tb_datapath/unused_op
add wave -noupdate /tb_datapath/xor_op
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {1 ns}
