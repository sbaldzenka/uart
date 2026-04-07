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

entity uart_rx_module is
generic
(
    COEFF_BAUDRATE : std_logic_vector(15 downto 0)
);
port
(
    -- system signals
    i_clk   : in  std_logic;
    i_reset : in  std_logic;
    -- data out bus
    o_valid : out std_logic;
    o_data  : out std_logic_vector(7 downto 0);
    -- uart interface
    i_rx    : in  std_logic
);
end uart_rx_module;

architecture rtl of uart_rx_module is

    -- types
    type states is
    (
        S_IDLE,
        S_START,
        S_TAKE_BIT0,
        S_TAKE_BIT1,
        S_TAKE_BIT2,
        S_TAKE_BIT3,
        S_TAKE_BIT4,
        S_TAKE_BIT5,
        S_TAKE_BIT6,
        S_TAKE_BIT7,
        S_STOP
    );

    -- signals
    signal counter     : std_logic_vector(15 downto 0);
    signal time_ok     : std_logic;
    signal get_value   : std_logic;
    signal buffer_word : std_logic_vector( 7 downto 0);
    signal div_coeff   : std_logic_vector(15 downto 0);
    signal state       : states;

begin

    div_coeff <= '0' & COEFF_BAUDRATE(15 downto 1);

    PERIOD_GENERATOR: process(i_clk)
    begin
        if rising_edge(i_clk) then
            if (state = S_IDLE) then
                counter   <= x"0000";
                time_ok   <= '0';
                get_value <= '0';
            else
                counter <= counter + '1';

                if (counter = COEFF_BAUDRATE-1) then
                    counter <= x"0000";
                    time_ok <= '1';
                elsif (counter = div_coeff) then 
                    get_value <= '1';
                else
                    time_ok   <= '0';
                    get_value <= '0';
                end if;
            end if;
        end if;
    end process;

    LOAD_TO_BUFFER: process(i_clk)
    begin
        if rising_edge(i_clk) then
            if (state = S_IDLE) then
                buffer_word <= x"00";
            elsif (get_value = '1') then
                buffer_word <= i_rx & buffer_word(7 downto 1);
            end if;
        end if;
    end process;

    BUS_DATA_OUT_CONTROL: process(i_clk)
    begin
        if rising_edge(i_clk) then
            o_valid <= '0';
            o_data  <= (others => '0');

            if (state = S_STOP and get_value = '1') then
                o_valid <= '1';
                o_data  <= buffer_word;
            end if;
        end if;
    end process;

    FSM: process(i_clk)
    begin
        if rising_edge(i_clk) then
            if (i_reset = '1') then
                state   <= S_IDLE;
            else
                case state is
                    when S_IDLE =>
                        if (i_rx = '0') then
                            state <= S_START;
                        end if;
                    when S_START =>
                        if (time_ok = '1') then
                            state <= S_TAKE_BIT0;
                        end if;
                    when S_TAKE_BIT0 =>
                        if (time_ok = '1') then
                            state <= S_TAKE_BIT1;
                        end if;
                    when S_TAKE_BIT1 =>
                        if (time_ok = '1') then
                            state <= S_TAKE_BIT2;
                        end if;
                    when S_TAKE_BIT2 =>
                        if (time_ok = '1') then
                            state <= S_TAKE_BIT3;
                        end if;
                    when S_TAKE_BIT3 =>
                        if (time_ok = '1') then
                            state <= S_TAKE_BIT4;
                        end if;
                    when S_TAKE_BIT4 =>
                        if (time_ok = '1') then
                            state <= S_TAKE_BIT5;
                        end if;
                    when S_TAKE_BIT5 =>
                        if (time_ok = '1') then
                            state <= S_TAKE_BIT6;
                        end if;
                    when S_TAKE_BIT6 =>
                        if (time_ok = '1') then
                            state <= S_TAKE_BIT7;
                        end if;
                    when S_TAKE_BIT7 =>
                        if (time_ok = '1') then
                            state <= S_STOP;
                        end if;
                    when S_STOP =>
                        if (time_ok = '1') then
                            state <= S_IDLE;
                        end if;
                    when others => null;
                end case;
            end if;
        end if;
    end process;

end rtl;