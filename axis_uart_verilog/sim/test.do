-- project     : axis_uart_verilog
-- version     : 1.2
-- data        : 04.06.2026
-- author      : siarhei baldzenka
-- e-mail      : sbaldzenka@proton.me
-- description : https://github.com/sbaldzenka/axis_uart

vlib work
vmap work work

vlog ../tb/axis_uart_tb.v

vlog ../hdl/axis_uart.v
vlog ../hdl/tx_ctrl.v
vlog ../hdl/rx_ctrl.v

vsim -t 1ps -voptargs=+acc=lprn -lib work axis_uart_tb

do waves_test.do
view wave
run 1000 ms