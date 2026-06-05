// project     : uart_verilog
// version     : 1.0
// data        : 04.06.2026
// author      : siarhei baldzenka
// e-mail      : sbaldzenka@proton.me
// description : https://github.com/sbaldzenka/uart

`timescale 1ns/100ps

`include "uart_test_param.vh"

module uart_tb
#(
    // simulation parameters
    parameter PERIOD_CLK     = `PERIOD_CLK,
    // uart parameters
    parameter COEFF_BAUDRATE = `COEFF_BAUDRATE
);

    // variables
    integer index;

    // signals
    reg       clk;
    reg       reset;

    reg       s_axis_valid;
    reg [7:0] s_axis_data;
    wire      s_axis_ready;

    wire       m_axis_valid;
    wire [7:0] m_axis_data;

    wire       tx;
    wire       rx;

    reg  [7:0] tx_word;
    reg  [7:0] tx_word_ff;
    reg  [7:0] rx_word;

    // logic
    initial begin
        #0   $display("!------------- simulation is started.");
             index = 0;

             clk   = 1'b0;
             reset = 1'b1;
        #200 reset = 1'b0;
    end

    always #(PERIOD_CLK / 2) clk = ~clk;

    assign rx = tx;

    always @(posedge clk) begin
        if (reset) begin
            s_axis_valid <= 1'b0;
            s_axis_data  <= 'b0;
        end else begin
            if (s_axis_ready) begin
                s_axis_valid <= 1'b1;
                s_axis_data  <= s_axis_data + 1'b1;
            end else begin
                s_axis_valid <= 1'b0;
            end
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            tx_word <= 'b0;
        end else begin
            tx_word_ff <= tx_word;

            if (s_axis_valid && s_axis_ready) begin
                tx_word <= s_axis_data;
            end
        end
    end

    always @(*) begin
        if (reset) begin
            rx_word <= 'b0;
        end else begin
            if (m_axis_valid) begin
                rx_word <= m_axis_data;
            end
        end
    end

    always @(posedge clk) begin
        if (m_axis_valid) begin
            if (tx_word_ff == rx_word) begin
                $display("transaction %d is done!", index);
                index = index + 1;

                if (index == `TRANSACTIONS) begin
                    $display("!------------- simulation is finished.");
                    $finish;
                end
            end else begin
                $display("error!");
                $display("!------------- simulation is finished.");
                $finish;
            end
        end
    end

    uart
    #(
        .COEFF_BAUDRATE ( COEFF_BAUDRATE )
    )
    DUT_inst
    (
        .i_clk          ( clk          ),
        .i_reset        ( reset        ),
        .i_s_axis_valid ( s_axis_valid ),
        .i_s_axis_data  ( s_axis_data  ),
        .o_s_axis_ready ( s_axis_ready ),
        .o_m_axis_valid ( m_axis_valid ),
        .o_m_axis_data  ( m_axis_data  ),
        .o_tx           ( tx           ),
        .i_rx           ( rx           )
    );

endmodule
