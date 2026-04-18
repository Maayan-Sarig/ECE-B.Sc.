onerror {resume}
add list -width 21 /tb_datapath/add_op
add list /tb_datapath/Ain
add list /tb_datapath/ALUFN
add list /tb_datapath/and_op
add list /tb_datapath/Cflag
add list /tb_datapath/clk
add list /tb_datapath/done
add list /tb_datapath/done_DM
add list /tb_datapath/done_op
add list /tb_datapath/done_PM
add list /tb_datapath/DTCM_addr_in
add list /tb_datapath/DTCM_addr_out
add list /tb_datapath/DTCM_addr_sel
add list /tb_datapath/DTCM_out
add list /tb_datapath/DTCM_tb_addr_in
add list /tb_datapath/DTCM_tb_addr_out
add list /tb_datapath/DTCM_tb_in
add list /tb_datapath/DTCM_tb_out
add list /tb_datapath/DTCM_tb_wr
add list /tb_datapath/DTCM_wr
add list /tb_datapath/Imm1_in
add list /tb_datapath/Imm2_in
add list /tb_datapath/IRin
add list /tb_datapath/ITCM_tb_addr_in
add list /tb_datapath/ITCM_tb_in
add list /tb_datapath/ITCM_tb_wr
add list /tb_datapath/jc_op
add list /tb_datapath/jmp_op
add list /tb_datapath/jnc_op
add list /tb_datapath/ld_op
add list /tb_datapath/mov_op
add list /tb_datapath/Nflag
add list /tb_datapath/or_op
add list /tb_datapath/PCin
add list /tb_datapath/PCsel
add list /tb_datapath/RFaddr_rd
add list /tb_datapath/RFaddr_wr
add list /tb_datapath/RFin
add list /tb_datapath/RFout
add list /tb_datapath/rst_control
add list /tb_datapath/st_op
add list /tb_datapath/sub_op
add list /tb_datapath/TBactive
add list /tb_datapath/unused_op
add list /tb_datapath/xor_op
configure list -usestrobe 0
configure list -strobestart {0 ps} -strobeperiod {0 ps}
configure list -usesignaltrigger 1
configure list -delta all
configure list -signalnamewidth 0
configure list -datasetprefix 0
configure list -namelimit 5
