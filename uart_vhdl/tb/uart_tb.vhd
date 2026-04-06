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

entity uart_tb is
generic
(
    COEFF_BAUDRATE : std_logic_vector(15 downto 0):= x"0036"
);
end uart_tb;

architecture rtl of uart_tb is

    component uart
    generic
    (
        COEFF_BAUDRATE : std_logic_vector(15 downto 0)
    );
    port
    (
        i_clk          : in  std_logic;
        i_reset        : in  std_logic;
        i_s_axis_valid : in  std_logic;
        i_s_axis_data  : in  std_logic_vector(7 downto 0);
        o_s_axis_ready : out std_logic;
        o_m_axis_valid : out std_logic;
        o_m_axis_data  : out std_logic_vector(7 downto 0);
        o_tx           : out std_logic;
        i_rx           : in  std_logic
    );
    end component;

    -- constants
    constant clk_period   : time := 20 ns; --50 MHz

    -- signals
    signal clk            : std_logic;
    signal reset          : std_logic;
    signal s_axis_valid   : std_logic;
    signal s_axis_data    : std_logic_vector(7 downto 0);
    signal s_axis_ready   : std_logic;
    signal m_axis_valid   : std_logic;
    signal m_axis_data    : std_logic_vector(7 downto 0);
    signal tx             : std_logic;
    signal rx             : std_logic;
    signal transmission   : std_logic;
    signal word_gen_pulse : std_logic;
    signal word_gen       : std_logic_vector(7 downto 0);
    signal data_tx        : std_logic_vector(7 downto 0);
    signal data_rx        : std_logic_vector(7 downto 0);

begin

    DUT_inst: uart
    generic map
    (
        COEFF_BAUDRATE => COEFF_BAUDRATE
    )
    port map 
    (
        i_clk          => clk,
        i_reset        => reset,
        i_s_axis_valid => s_axis_valid,
        i_s_axis_data  => s_axis_data,
        o_s_axis_ready => s_axis_ready,
        o_m_axis_valid => m_axis_valid,
        o_m_axis_data  => m_axis_data,
        o_tx           => tx,
        i_rx           => rx
    );

    CLK_GENERATE: process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    RESET_GENERATE: process
    begin
        reset <= '1';
        wait for 100 us;
        reset <= '0';
        wait;
    end process;

    TRANSMISSION_FLAG_GENERATE: process
    begin
        transmission <= '0';
        wait for 200 us;
        transmission <= '1';
        wait for 700 us;
        transmission <= '0';
        wait;
    end process;

    WORD_GENERATE: process(clk)
    begin
        if rising_edge(clk) then
            if (reset = '1') then
                word_gen_pulse <= '0';
                s_axis_data    <= (others => '0');
                word_gen       <= (others => '0');
            elsif (s_axis_ready = '1' and transmission = '1') then
                word_gen       <= word_gen + '1';
                word_gen_pulse <= '1';
                s_axis_data    <= word_gen;
            else
                word_gen_pulse <= '0';
            end if;

            if (word_gen_pulse = '1' and s_axis_ready = '0') then
                word_gen <= word_gen - '1';
            end if;
        end if;
    end process;

    rx           <= tx;
    s_axis_valid <= s_axis_ready and word_gen_pulse;

    DATA_COMP: process(clk)
    begin
        if rising_edge(clk) then
            if (reset = '1') then
                data_tx <= (others => '0');
            elsif (s_axis_valid = '1') then
                data_tx <= s_axis_data;
            end if;

            if (reset = '1') then
                data_rx <= (others => '0');
            elsif (m_axis_valid = '1') then
                data_rx <= m_axis_data;
            end if;
        end if;
    end process;

end rtl;