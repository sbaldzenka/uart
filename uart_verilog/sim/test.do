-- project     : uart_verilog
-- version     : 1.1
-- data        : 04.06.2026
-- author      : siarhei baldzenka
-- e-mail      : sbaldzenka@proton.me
-- description : https://github.com/sbaldzenka/uart

vlib work
vmap work work

vlog ../tb/uart_tb.v

vlog ../hdl/uart.v
vlog ../hdl/tx_ctrl.v
vlog ../hdl/rx_ctrl.v

vsim -t 1ps -voptargs=+acc=lprn -lib work uart_tb

do waves_test.do
view wave
run 1000 ms