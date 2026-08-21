/*
---------------------------------------------------------------------------------------

MIT License

Copyright (c) 2026 Siarhei Baldzenka

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

---------------------------------------------------------------------------------------

project     : axis_uart_verilog
version     : 1.2
data        : 04.06.2026
author      : siarhei baldzenka
e-mail      : sbaldzenka@proton.me
description : https://github.com/sbaldzenka/axis_uart

---------------------------------------------------------------------------------------
*/

`timescale 1ns/100ps

module axis_uart
#(
    parameter COEFF_BAUDRATE = 16'h0036
)
(
    // system signals
    input  wire       i_clk,
    input  wire       i_reset,
    // data in bus
    input  wire       i_s_axis_valid,
    input  wire [7:0] i_s_axis_data,
    output wire       o_s_axis_ready,
    // data out bus
    output wire       o_m_axis_valid,
    output wire [7:0] o_m_axis_data,
    // uart interface
    output wire       o_tx,
    input  wire       i_rx
);

    tx_ctrl
    #(
        .COEFF_BAUDRATE ( COEFF_BAUDRATE )
    )
    tx_ctrl_inst
    (
        .i_clk   ( i_clk          ),
        .i_reset ( i_reset        ),
        .i_valid ( i_s_axis_valid ),
        .i_data  ( i_s_axis_data  ),
        .o_ready ( o_s_axis_ready ),
        .o_tx    ( o_tx           )
    );

    rx_ctrl
    #(
        .COEFF_BAUDRATE ( COEFF_BAUDRATE )
    )
    rx_ctrl_inst
    (
        .i_clk   ( i_clk          ),
        .i_reset ( i_reset        ),
        .o_valid ( o_m_axis_valid ),
        .o_data  ( o_m_axis_data  ),
        .i_rx    ( i_rx           )
    );

endmodule