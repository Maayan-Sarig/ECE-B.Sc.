onerror {resume}
add list -width 20 /tb_control/add_op
add list /tb_control/Ain
add list /tb_control/ALUFN
add list /tb_control/ALUFN_size
add list /tb_control/and_op
add list /tb_control/Cflag
add list /tb_control/clk
add list /tb_control/done
add list /tb_control/done_op
add list /tb_control/DTCM_addr_in
add list /tb_control/DTCM_addr_out
add list /tb_control/DTCM_addr_sel
add list /tb_control/DTCM_out
add list /tb_control/DTCM_wr
add list /tb_control/ena
add list /tb_control/Imm1_in
add list /tb_control/Imm2_in
add list /tb_control/IRin
add list /tb_control/jc_op
add list /tb_control/jmp_op
add list /tb_control/jnc_op
add list /tb_control/ld_op
add list /tb_control/mov_op
add list /tb_control/mux_size
add list /tb_control/Nflag
add list /tb_control/or_op
add list /tb_control/PCin
add list /tb_control/PCsel
add list /tb_control/RFaddr_rd
add list /tb_control/RFaddr_wr
add list /tb_control/RFin
add list /tb_control/RFout
add list /tb_control/rst
add list /tb_control/rst_control
add list /tb_control/st_op
add list /tb_control/sub_op
add list /tb_control/unused_op
add list /tb_control/xor_op
add list /tb_control/Zflag
configure list -usestrobe 0
configure list -strobestart {0 ps} -strobeperiod {0 ps}
configure list -usesignaltrigger 1
configure list -delta all
configure list -signalnamewidth 0
configure list -datasetprefix 0
configure list -namelimit 5
