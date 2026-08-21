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

module tx_ctrl
#(
    parameter COEFF_BAUDRATE = 16'h0036
)
(
    // system signals
    input  wire       i_clk,
    input  wire       i_reset,
    // data in bus
    input  wire       i_valid,
    input  wire [7:0] i_data,
    output wire       o_ready,
    // uart interface
    output reg        o_tx
);

    // local parameters
    localparam [3:0] S_IDLE      = 0,
                     S_START     = 1,
                     S_SEND_BIT0 = 2,
                     S_SEND_BIT1 = 3,
                     S_SEND_BIT2 = 4,
                     S_SEND_BIT3 = 5,
                     S_SEND_BIT4 = 6,
                     S_SEND_BIT5 = 7,
                     S_SEND_BIT6 = 8,
                     S_SEND_BIT7 = 9,
                     S_STOP      = 10;

    // signals
    reg        bit_done;
    reg [15:0] baud_counter;
    reg [ 7:0] buffer;
    reg [ 7:0] shift_reg;
    reg [ 3:0] state;

    // logic
    assign o_ready = (state == S_IDLE) ? 1'b1 : 1'b0;

    always @(posedge i_clk) begin
        if (baud_counter == COEFF_BAUDRATE-1'b1) begin
            bit_done <= 1'b1;
        end else begin
            bit_done <= 1'b0;
        end
    end

    always @(posedge i_clk) begin
        if (state == S_IDLE) begin
            baud_counter <= 'b0;
        end else begin
            baud_counter <= baud_counter + 1'b1;

            if (baud_counter == COEFF_BAUDRATE-1'b1) begin
                baud_counter <= 'b0;
            end
        end
    end

    always @(posedge i_clk) begin
        if (i_valid && o_ready) begin
            buffer <= i_data;
        end
    end

    always @(posedge i_clk) begin
        if (bit_done) begin
            if (state == S_START) begin
                shift_reg <= buffer;
            end else begin
                shift_reg <= {1'b1, shift_reg[7:1]};
            end
        end
    end

    always @(posedge i_clk) begin
        if (state == S_IDLE) begin
            o_tx <= 1'b1;
        end else if (state == S_START) begin
            o_tx <= 1'b0;
        end else if (state == S_STOP) begin
            o_tx <= 1'b1;
        end else begin
            o_tx <= shift_reg[0];
        end
    end

    always @(posedge i_clk) begin
        if (i_reset) begin
            state <= S_IDLE;
        end else begin
            case (state)
                S_IDLE: begin
                    if (i_valid) begin
                        state <= S_START;
                    end
                end

                S_START: begin
                    if (bit_done) begin
                        state <= S_SEND_BIT0;
                    end
                end

                S_SEND_BIT0: begin
                    if (bit_done) begin
                        state <= S_SEND_BIT1;
                    end
                end

                S_SEND_BIT1: begin
                    if (bit_done) begin
                        state <= S_SEND_BIT2;
                    end
                end

                S_SEND_BIT2: begin
                    if (bit_done) begin
                        state <= S_SEND_BIT3;
                    end
                end

                S_SEND_BIT3: begin
                    if (bit_done) begin
                        state <= S_SEND_BIT4;
                    end
                end

                S_SEND_BIT4: begin
                    if (bit_done) begin
                        state <= S_SEND_BIT5;
                    end
                end

                S_SEND_BIT5: begin
                    if (bit_done) begin
                        state <= S_SEND_BIT6;
                    end
                end

                S_SEND_BIT6: begin
                    if (bit_done) begin
                        state <= S_SEND_BIT7;
                    end
                end

                S_SEND_BIT7: begin
                    if (bit_done) begin
                        state <= S_STOP;
                    end
                end

                S_STOP: begin
                    if (bit_done) begin
                        state <= S_IDLE;
                    end
                end

                default: begin
                    state <= S_IDLE;
                end
            endcase
        end
    end

endmodule