onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top_tb/Y_i
add wave -noupdate /top_tb/X_i
add wave -noupdate /top_tb/ALUFN_i
add wave -noupdate /top_tb/ALUout_o
add wave -noupdate /top_tb/Nflag_o
add wave -noupdate /top_tb/Cflag_o
add wave -noupdate /top_tb/Zflag_o
add wave -noupdate /top_tb/Vflag_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {168818 ps} 0}
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
WaveRestoreZoom {0 ps} {1024 ns}
