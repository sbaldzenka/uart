# axis_uart

> **version: 1.2**

UART IP-core with AXI4-Stream interface for FPGA projects.

Folders:
- **axis_uart_vhdl** - uart on vhdl;
  - **hdl** - vhdl files;
  - **sim** - script files for modelsim/questasim;
  - **tb** - vhdl testbench.
- **axis_uart_verilog** - uart on verilog;
  - **hdl** - verilog files;
  - **sim** - script files for modelsim/questasim;
  - **tb** - verilog testbench.

:exclamation: To set the UART baudrate, you must specify COEFF_BAUDRATE in the top project file (**axis_uart.vhd** or **axis_uart.v**).
### COEFF_BAUDRATE = i_clk / uart_baudrate.
> For example: COEFF_BAUDRATE = 50000000 Hz / 9600 = 5208 dec = 1458 hex
