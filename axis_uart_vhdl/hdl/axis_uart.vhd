---------------------------------------------------------------------------------------
--
-- MIT License
--
-- Copyright (c) 2026 Siarhei Baldzenka
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--
-- ---------------------------------------------------------------------------------------
--
-- project     : axis_uart_vhdl
-- date        : 16.01.2020
-- version     : 1.2
-- author      : siarhei baldzenka
-- e-mail      : sbaldzenka@proton.me
-- description : https://github.com/sbaldzenka/axis_uart
--               COEFF_BAUDRATE = Fclk/Fuart
--
---------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity axis_uart is
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
end axis_uart;

architecture rtl of axis_uart is

    component tx_manager is
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

    component rx_manager is
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

    tx_manager_inst: tx_manager
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

    rx_manager_inst: rx_manager
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