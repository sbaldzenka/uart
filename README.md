# uart

UART IP-core for FPGA projects.

Folders:
- **uart_vhdl** - uart on vhdl;
 - **hdl** - vhdl files;
 - **sim** - script files for modelsim/questasim;
 - **tb** - testbench.

To set the UART baudrate, you must specify COEFF_BAUDRATE in the top project file (**uart.vhd**).
### COEFF_BAUDRATE = i_clk/uart_baudrate.
> For example COEFF_BAUDRATE = 50000000 Hz / 9600 = 5208 dec = 1458 hex
