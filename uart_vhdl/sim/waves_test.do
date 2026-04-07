-- project     : uart_vhdl
-- date        : 16.01.2020
-- author      : siarhei baldzenka
-- e-mail      : sbaldzenka@proton.me
-- description : https://github.com/sbaldzenka/uart/uart_vhdl

add wave -noupdate -divider testbench
add wave -noupdate -format Logic -radix UNSIGNED -group {testbench} /uart_tb/*

add wave -noupdate -divider uart_core
add wave -noupdate -format Logic -radix UNSIGNED -group {uart} /uart_tb/DUT_inst/*

add wave -noupdate -divider tx_module
add wave -noupdate -format Logic -radix UNSIGNED -group {tx_module} /uart_tb/DUT_inst/uart_tx_module_inst/*

add wave -noupdate -divider rx_module
add wave -noupdate -format Logic -radix UNSIGNED -group {rx_module} /uart_tb/DUT_inst/uart_rx_module_inst/*

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