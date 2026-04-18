onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top_io_tb/clk
add wave -noupdate /top_io_tb/SW
add wave -noupdate /top_io_tb/KEY
add wave -noupdate /top_io_tb/HEX0
add wave -noupdate /top_io_tb/HEX1
add wave -noupdate /top_io_tb/HEX2
add wave -noupdate /top_io_tb/HEX3
add wave -noupdate /top_io_tb/HEX4
add wave -noupdate /top_io_tb/HEX5
add wave -noupdate /top_io_tb/LED
add wave -noupdate /top_io_tb/pwm_out
add wave -noupdate /top_io_tb/DUT/ALUFN_sig
add wave -noupdate /top_io_tb/DUT/ALUout_sig
add wave -noupdate /top_io_tb/DUT/clk_sig
add wave -noupdate /top_io_tb/DUT/X_sig
add wave -noupdate /top_io_tb/DUT/Y_sig
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {999456 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 210
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
WaveRestoreZoom {999096 ps} {1000048 ps}
