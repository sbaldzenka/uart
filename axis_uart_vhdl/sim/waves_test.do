-- project     : axis_uart_vhdl
-- date        : 16.01.2020
-- version     : 1.2
-- author      : siarhei baldzenka
-- e-mail      : sbaldzenka@proton.me
-- description : https://github.com/sbaldzenka/axis_uart

-- Waves
add wave -noupdate -divider testbench
add wave -noupdate -format Logic -radix UNSIGNED -group {testbench} /axis_uart_tb/*

add wave -noupdate -divider axis_uart
add wave -noupdate -format Logic -radix UNSIGNED -group {axis_uart} /axis_uart_tb/DUT_inst/*

add wave -noupdate -divider tx_manager
add wave -noupdate -format Logic -radix UNSIGNED -group {tx_manager} /axis_uart_tb/DUT_inst/tx_manager_inst/*

add wave -noupdate -divider rx_manager
add wave -noupdate -format Logic -radix UNSIGNED -group {rx_manager} /axis_uart_tb/DUT_inst/rx_manager_inst/*

-- Toggle leaf names command
config wave -signalnamewidth 1