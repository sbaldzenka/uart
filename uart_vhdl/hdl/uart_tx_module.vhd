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

entity uart_tx_module is
generic
(
    COEFF_BAUDRATE : std_logic_vector(15 downto 0)
);
port
(
    -- system signals
    i_clk   : in  std_logic;
    i_reset : in  std_logic;
    -- data in bus
    i_valid : in  std_logic;
    i_data  : in  std_logic_vector(7 downto 0);
    o_ready : out std_logic;
    -- uart interface
    o_tx    : out std_logic
);
end uart_tx_module;

architecture rtl of uart_tx_module is

    -- types
    type states is
    (
        S_IDLE,
        S_START,
        S_SEND_BIT0,
        S_SEND_BIT1,
        S_SEND_BIT2,
        S_SEND_BIT3,
        S_SEND_BIT4,
        S_SEND_BIT5,
        S_SEND_BIT6,
        S_SEND_BIT7,
        S_STOP
    );

    -- signals
    signal buffer_word : std_logic_vector( 7 downto 0);
    signal shift_reg   : std_logic_vector( 7 downto 0);
    signal counter     : std_logic_vector(15 downto 0);
    signal time_ok     : std_logic;
    signal state       : states;

begin

    READY_SIGNAL: process(i_clk)
    begin
        if rising_edge(i_clk) then
            if (state = S_IDLE) then
                o_ready <= '1';

                if (i_valid = '1') then
                    o_ready <= '0';
                end if;
            end if;
        end if;
    end process;

    LOAD_TO_BUFFER: process(i_clk)
    begin
        if rising_edge(i_clk) then
            if (i_reset = '1') then
                buffer_word <= x"00";
            elsif (i_valid = '1') then
                buffer_word <= i_data;
            end if;
        end if;
    end process;

    PERIOD_GENERATOR: process(i_clk)
    begin
        if rising_edge(i_clk) then
            if (state = S_IDLE) then
                counter <= x"0000";
                time_ok <= '0';
            else
                counter <= counter + '1';

                if (counter = COEFF_BAUDRATE-1) then
                    counter <= x"0000";
                    time_ok <= '1';
                else
                    time_ok <= '0';
                end if; 
            end if;
        end if;
    end process;

    SHIFT_REGISTER: process(i_clk)
    begin
        if rising_edge(i_clk) then
            if (i_reset = '1') then
                shift_reg <= x"00";
            elsif (time_ok = '1') then
                if (state = S_START) then
                    shift_reg <= buffer_word;
                else
                    shift_reg <= '0' & shift_reg(7 downto 1);
                end if;
            end if;
        end if;
    end process;

    UART_TX: process(i_clk)
    begin
        if rising_edge(i_clk) then
            if (state = S_IDLE) then
                o_tx <= '1';
            else
                if (time_ok = '1') then
                    if (state = S_START) then
                        o_tx <= '0';
                    elsif (state = S_STOP) then
                        o_tx <= '1';
                    else
                        o_tx <= shift_reg(0);
                    end if;
                end if;
            end if;
        end if;
    end process;

    FSM: process(i_clk)
    begin
        if rising_edge(i_clk) then
            if (i_reset = '1') then
                state <= S_IDLE;
            else
                case state is
                    when S_IDLE =>
                        if (i_valid = '1') then
                            state <= S_START;
                        end if;
                    when S_START =>
                        if (time_ok = '1') then
                            state <= S_SEND_BIT0;
                        end if;
                    when S_SEND_BIT0 =>
                        if (time_ok = '1') then
                            state <= S_SEND_BIT1;
                        end if;
                    when S_SEND_BIT1 =>
                        if (time_ok = '1') then
                            state <= S_SEND_BIT2;
                        end if;
                    when S_SEND_BIT2 =>
                        if (time_ok = '1') then
                            state <= S_SEND_BIT3;
                        end if;
                    when S_SEND_BIT3 =>
                        if (time_ok = '1') then
                            state <= S_SEND_BIT4;
                        end if;
                    when S_SEND_BIT4 =>
                        if (time_ok = '1') then
                            state <= S_SEND_BIT5;
                        end if;
                    when S_SEND_BIT5 =>
                        if (time_ok = '1') then
                            state <= S_SEND_BIT6;
                        end if;
                    when S_SEND_BIT6 =>
                        if (time_ok = '1') then
                            state <= S_SEND_BIT7;
                        end if;
                    when S_SEND_BIT7 =>
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