// project     : uart_verilog
// version     : 1.0
// data        : 04.06.2026
// author      : siarhei baldzenka
// e-mail      : sbaldzenka@proton.me
// description : https://github.com/sbaldzenka/uart

`timescale 1ns/100ps

module uart
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