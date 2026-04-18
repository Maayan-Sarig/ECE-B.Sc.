onerror {resume}
add list -width 15 /tb_shifter/x
add list /tb_shifter/y
add list /tb_shifter/res
add list /tb_shifter/ALUFN
add list /tb_shifter/cout
configure list -usestrobe 0
configure list -strobestart {0 ps} -strobeperiod {0 ps}
configure list -usesignaltrigger 1
configure list -delta collapse
configure list -signalnamewidth 0
configure list -datasetprefix 0
configure list -namelimit 5
