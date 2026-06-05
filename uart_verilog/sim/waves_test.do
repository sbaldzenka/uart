-- project     : uart_verilog
-- version     : 1.0
-- data        : 04.06.2026
-- author      : siarhei baldzenka
-- e-mail      : sbaldzenka@proton.me
-- description : https://github.com/sbaldzenka/uart


add wave -noupdate -divider testbench
add wave -noupdate -format Logic -radix UNSIGNED -group {testbench} /uart_tb/*

add wave -noupdate -divider uart_core
add wave -noupdate -format Logic -radix UNSIGNED -group {uart} /uart_tb/DUT_inst/*

add wave -noupdate -divider tx_ctrl
add wave -noupdate -format Logic -radix UNSIGNED -group {tx_ctrl} /uart_tb/DUT_inst/tx_ctrl_inst/*

add wave -noupdate -divider rx_ctrl
add wave -noupdate -format Logic -radix UNSIGNED -group {rx_ctrl} /uart_tb/DUT_inst/rx_ctrl_inst/*

TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1611 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps