onerror {resume}
add list -width 14 /addsub_tb/x
add list /addsub_tb/y
add list /addsub_tb/s
add list /addsub_tb/ALUFN
add list /addsub_tb/cout
configure list -usestrobe 0
configure list -strobestart {0 ps} -strobeperiod {0 ps}
configure list -usesignaltrigger 1
configure list -delta collapse
configure list -signalnamewidth 0
configure list -datasetprefix 0
configure list -namelimit 5
