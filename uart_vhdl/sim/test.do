-- project     : uart_vhdl
-- date        : 16.01.2020
-- version     : 1.0
-- author      : siarhei baldzenka
-- e-mail      : sbaldzenka@proton.me
-- description : https://github.com/sbaldzenka/uart

vlib work
vmap work work

vcom -93 ../tb/uart_tb.vhd

vcom -93 ../hdl/uart.vhd
vcom -93 ../hdl/uart_tx_module.vhd
vcom -93 ../hdl/uart_rx_module.vhd

vsim -t 1ps -voptargs=+acc=lprn -lib work uart_tb

do waves_test.do
view wave
run 1 ms