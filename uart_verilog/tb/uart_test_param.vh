// project     : uart_verilog
// version     : 1.0
// data        : 04.06.2026
// author      : siarhei baldzenka
// e-mail      : sbaldzenka@proton.me
// description : https://github.com/sbaldzenka/uart/uart_verilog

`ifndef UART_TEST_PARAM_VH
`define UART_TEST_PARAM_VH


    // !UNCOMMENT THE REQUIRED PARAMETER
    //---------------------------------------------------------

    `define PERIOD_CLK 10.000 // 100 MHz

    `define TRANSACTIONS 100

    // COEFF_BAUDRATE for Fclk = 100 MHz
    // [ --> COEFF_BAUDRATE = Fclk/Fuart ]
    //---------------------------------------------------------
    `define COEFF_BAUDRATE 16'h28B0 // 9600
    //`define COEFF_BAUDRATE 16'h0364 // 115200
    //`define COEFF_BAUDRATE 16'h006C // 921600

`endif