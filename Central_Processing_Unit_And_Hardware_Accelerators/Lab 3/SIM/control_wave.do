onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_control/add_op
add wave -noupdate /tb_control/Ain
add wave -noupdate /tb_control/ALUFN
add wave -noupdate /tb_control/ALUFN_size
add wave -noupdate /tb_control/and_op
add wave -noupdate /tb_control/Cflag
add wave -noupdate /tb_control/clk
add wave -noupdate /tb_control/done
add wave -noupdate /tb_control/done_op
add wave -noupdate /tb_control/DTCM_addr_in
add wave -noupdate /tb_control/DTCM_addr_out
add wave -noupdate /tb_control/DTCM_addr_sel
add wave -noupdate /tb_control/DTCM_out
add wave -noupdate /tb_control/DTCM_wr
add wave -noupdate /tb_control/ena
add wave -noupdate /tb_control/Imm1_in
add wave -noupdate /tb_control/Imm2_in
add wave -noupdate /tb_control/IRin
add wave -noupdate /tb_control/jc_op
add wave -noupdate /tb_control/jmp_op
add wave -noupdate /tb_control/jnc_op
add wave -noupdate /tb_control/ld_op
add wave -noupdate /tb_control/mov_op
add wave -noupdate /tb_control/mux_size
add wave -noupdate /tb_control/Nflag
add wave -noupdate /tb_control/or_op
add wave -noupdate /tb_control/PCin
add wave -noupdate /tb_control/PCsel
add wave -noupdate /tb_control/RFaddr_rd
add wave -noupdate /tb_control/RFaddr_wr
add wave -noupdate /tb_control/RFin
add wave -noupdate /tb_control/RFout
add wave -noupdate /tb_control/rst
add wave -noupdate /tb_control/rst_control
add wave -noupdate /tb_control/st_op
add wave -noupdate /tb_control/sub_op
add wave -noupdate /tb_control/unused_op
add wave -noupdate /tb_control/xor_op
add wave -noupdate /tb_control/Zflag
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1998737 ps} 0}
quietly wave cursor active 1
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
WaveRestoreZoom {1998585 ps} {2000075 ps}
