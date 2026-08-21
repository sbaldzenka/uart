-- project     : axis_uart_verilog
-- version     : 1.2
-- data        : 04.06.2026
-- author      : siarhei baldzenka
-- e-mail      : sbaldzenka@proton.me
-- description : https://github.com/sbaldzenka/axis_uart

-- Waves
add wave -noupdate -divider testbench
add wave -noupdate -format Logic -radix UNSIGNED -group {testbench} /axis_uart_tb/*

add wave -noupdate -divider uart_core
add wave -noupdate -format Logic -radix UNSIGNED -group {axis_uart} /axis_uart_tb/DUT_inst/*

add wave -noupdate -divider tx_ctrl
add wave -noupdate -format Logic -radix UNSIGNED -group {tx_ctrl} /axis_uart_tb/DUT_inst/tx_ctrl_inst/*

add wave -noupdate -divider rx_ctrl
add wave -noupdate -format Logic -radix UNSIGNED -group {rx_ctrl} /axis_uart_tb/DUT_inst/rx_ctrl_inst/*

-- Toggle leaf names command
config wave -signalnamewidth 1