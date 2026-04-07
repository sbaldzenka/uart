-- project     : uart_vhdl
-- date        : 16.01.2020
-- author      : siarhei baldzenka
-- e-mail      : sbaldzenka@proton.me
-- description : https://github.com/sbaldzenka/uart/uart_vhdl
--               COEFF_BAUDRATE = Fclk/Fuart

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity uart is
generic
(
    COEFF_BAUDRATE : std_logic_vector(15 downto 0) := x"0036"
);
port
(
    -- system signals
    i_clk          : in  std_logic;
    i_reset        : in  std_logic;
    -- data in bus
    i_s_axis_valid : in  std_logic;
    i_s_axis_data  : in  std_logic_vector(7 downto 0);
    o_s_axis_ready : out std_logic;
    -- data out bus
    o_m_axis_valid : out std_logic;
    o_m_axis_data  : out std_logic_vector(7 downto 0);
    -- uart interface
    o_tx           : out std_logic;
    i_rx           : in  std_logic
);
end uart;

architecture rtl of uart is

    component uart_tx_module is
    generic
    (
        COEFF_BAUDRATE : std_logic_vector(15 downto 0)
    );
    port
    (
        i_clk   : in  std_logic;
        i_reset : in  std_logic;
        i_valid : in  std_logic;
        i_data  : in  std_logic_vector(7 downto 0);
        o_ready : out std_logic;
        o_tx    : out std_logic
    );
    end component;

    component uart_rx_module is
    generic
    (
        COEFF_BAUDRATE : std_logic_vector(15 downto 0)
    );
    port
    (
        i_clk   : in  std_logic;
        i_reset : in  std_logic;
        o_valid : out std_logic;
        o_data  : out std_logic_vector(7 downto 0);
        i_rx    : in  std_logic
    );
    end component;

begin

    uart_tx_module_inst: uart_tx_module
    generic map
    (
        COEFF_BAUDRATE => COEFF_BAUDRATE
    )
    port map
    (
        i_clk   => i_clk,
        i_reset => i_reset,
        i_valid => i_s_axis_valid,
        i_data  => i_s_axis_data,
        o_ready => o_s_axis_ready,
        o_tx    => o_tx
    );

    uart_rx_module_inst: uart_rx_module
    generic map
    (
        COEFF_BAUDRATE => COEFF_BAUDRATE
    )
    port map
    (
        i_clk   => i_clk,
        i_reset => i_reset,
        o_valid => o_m_axis_valid,
        o_data  => o_m_axis_data,
        i_rx    => i_rx
    );

end rtl;