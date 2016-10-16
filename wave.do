onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /datapath_tb/DUT/regfile/R2/clk
add wave -noupdate /datapath_tb/DUT/regfile/R2/load
add wave -noupdate /datapath_tb/DUT/regfile/R2/in
add wave -noupdate /datapath_tb/DUT/regfile/R2/out
add wave -noupdate /datapath_tb/DUT/regfile/R2/new_mem
add wave -noupdate -divider R2
add wave -noupdate /datapath_tb/DUT/regfile/R3/clk
add wave -noupdate /datapath_tb/DUT/regfile/R3/load
add wave -noupdate /datapath_tb/DUT/regfile/R3/in
add wave -noupdate /datapath_tb/DUT/regfile/R3/out
add wave -noupdate /datapath_tb/DUT/regfile/R3/new_mem
add wave -noupdate -divider R3
add wave -noupdate /datapath_tb/DUT/datapath_out
add wave -noupdate -divider {Datapath out}
add wave -noupdate /datapath_tb/DUT/regfile/blockone/in
add wave -noupdate /datapath_tb/DUT/regfile/blockone/out
add wave -noupdate /datapath_tb/DUT/readnum
add wave -noupdate /datapath_tb/DUT/regfile/mux/outone
add wave -noupdate /datapath_tb/DUT/regfile/mux/choose
add wave -noupdate /datapath_tb/DUT/regfile/mux/in2
add wave -noupdate /datapath_tb/DUT/A/clk
add wave -noupdate /datapath_tb/DUT/A/load
add wave -noupdate /datapath_tb/DUT/A/in
add wave -noupdate /datapath_tb/DUT/A/out
add wave -noupdate /datapath_tb/DUT/A/new_mem
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {6 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 266
configure wave -valuecolwidth 199
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
WaveRestoreZoom {0 ps} {61 ps}
