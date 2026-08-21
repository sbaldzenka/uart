-- project     : axis_uart_vhdl
-- date        : 16.01.2020
-- version     : 1.2
-- author      : siarhei baldzenka
-- e-mail      : sbaldzenka@proton.me
-- description : https://github.com/sbaldzenka/axis_uart

vlib work
vmap work work

vcom -93 ../tb/axis_uart_tb.vhd

vcom -93 ../hdl/axis_uart.vhd
vcom -93 ../hdl/tx_manager.vhd
vcom -93 ../hdl/rx_manager.vhd

vsim -t 1ps -voptargs=+acc=lprn -lib work axis_uart_tb

do waves_test.do
view wave
run 1 ms