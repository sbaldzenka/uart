// project     : uart_verilog
// version     : 1.0
// data        : 04.06.2026
// author      : siarhei baldzenka
// e-mail      : sbaldzenka@proton.me
// description : https://github.com/sbaldzenka/uart

`timescale 1ns/100ps

module rx_ctrl
#(
    parameter COEFF_BAUDRATE = 16'h0036
)
(
    // system signals
    input  wire       i_clk,
    input  wire       i_reset,
    // data out bus
    output reg        o_valid,
    output reg  [7:0] o_data,
    // uart interface
    input  wire       i_rx
);

    // local parameters
    localparam [3:0] S_IDLE      = 0,
                     S_START     = 1,
                     S_TAKE_BIT0 = 2,
                     S_TAKE_BIT1 = 3,
                     S_TAKE_BIT2 = 4,
                     S_TAKE_BIT3 = 5,
                     S_TAKE_BIT4 = 6,
                     S_TAKE_BIT5 = 7,
                     S_TAKE_BIT6 = 8,
                     S_TAKE_BIT7 = 9,
                     S_STOP      = 10;

    // signals
    reg        bit_done;
    reg        bit_capture;
    reg [15:0] baud_counter;
    reg [ 7:0] shift_reg;
    reg [ 3:0] state;

    // logic
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
        if (state == S_START || state == S_STOP) begin
            bit_capture <= 1'b0;
        end else begin
            bit_capture <= 1'b0;

            if (baud_counter == {1'b0, COEFF_BAUDRATE[15:1]}) begin
                bit_capture <= 1'b1;
            end
        end
    end

    always @(posedge i_clk) begin
        if (bit_capture) begin
            shift_reg <= {i_rx, shift_reg[7:1]};
        end
    end

    always @(posedge i_clk) begin
        if (state == S_STOP && bit_done) begin
            o_valid <= 1'b1;
            o_data  <= shift_reg;
        end else begin
            o_valid <= 1'b0;
            o_data  <= 'b0;
        end
    end

    always @(posedge i_clk) begin
        if (i_reset) begin
            state <= S_IDLE;
        end else begin
            case (state)
                S_IDLE: begin
                    if (!i_rx) begin
                        state <= S_START;
                    end
                end

                S_START: begin
                    if (bit_done) begin
                        state <= S_TAKE_BIT0;
                    end
                end

                S_TAKE_BIT0: begin
                    if (bit_done) begin
                        state <= S_TAKE_BIT1;
                    end
                end

                S_TAKE_BIT1: begin
                    if (bit_done) begin
                        state <= S_TAKE_BIT2;
                    end
                end

                S_TAKE_BIT2: begin
                    if (bit_done) begin
                        state <= S_TAKE_BIT3;
                    end
                end

                S_TAKE_BIT3: begin
                    if (bit_done) begin
                        state <= S_TAKE_BIT4;
                    end
                end

                S_TAKE_BIT4: begin
                    if (bit_done) begin
                        state <= S_TAKE_BIT5;
                    end
                end

                S_TAKE_BIT5: begin
                    if (bit_done) begin
                        state <= S_TAKE_BIT6;
                    end
                end

                S_TAKE_BIT6: begin
                    if (bit_done) begin
                        state <= S_TAKE_BIT7;
                    end
                end

                S_TAKE_BIT7: begin
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