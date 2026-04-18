onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top_tb/clk
add wave -noupdate /top_tb/dataMemLocation
add wave -noupdate /top_tb/dataMemResult
add wave -noupdate /top_tb/dept
add wave -noupdate /top_tb/done
add wave -noupdate /top_tb/done_DM
add wave -noupdate /top_tb/done_PM
add wave -noupdate /top_tb/DTCM_tb_addr_in
add wave -noupdate /top_tb/DTCM_tb_addr_out
add wave -noupdate /top_tb/DTCM_tb_in
add wave -noupdate /top_tb/DTCM_tb_out
add wave -noupdate /top_tb/DTCM_tb_wr
add wave -noupdate /top_tb/ena
add wave -noupdate /top_tb/immediate_long_size
add wave -noupdate /top_tb/immediate_short_size
add wave -noupdate /top_tb/ITCM_tb_addr_in
add wave -noupdate /top_tb/ITCM_tb_in
add wave -noupdate /top_tb/ITCM_tb_wr
add wave -noupdate /top_tb/memory_size
add wave -noupdate /top_tb/mux_size
add wave -noupdate /top_tb/progMemLocation
add wave -noupdate /top_tb/rst
add wave -noupdate /top_tb/TBactive
add wave -noupdate /top_tb/word_size
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
WaveRestoreZoom {999050 ps} {1000050 ps}
