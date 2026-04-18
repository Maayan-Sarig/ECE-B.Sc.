onerror {resume}
add list -width 13 /top_tb/Y_i
add list /top_tb/X_i
add list /top_tb/ALUFN_i
add list /top_tb/ALUout_o
add list /top_tb/Nflag_o
add list /top_tb/Cflag_o
add list /top_tb/Zflag_o
add list /top_tb/Vflag_o
configure list -usestrobe 0
configure list -strobestart {0 ps} -strobeperiod {0 ps}
configure list -usesignaltrigger 1
configure list -delta collapse
configure list -signalnamewidth 0
configure list -datasetprefix 0
configure list -namelimit 5
