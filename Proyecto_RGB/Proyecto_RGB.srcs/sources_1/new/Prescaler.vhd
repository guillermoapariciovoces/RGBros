library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_arith.ALL;

entity Prescaler is
    generic(
            reduction : positive := 100000
            );
    port(
        clk_in : in std_logic;
        reset_n : in std_logic;
        clk_out : out std_logic
    );
end Prescaler;


architecture behavioral of Prescaler is
    signal ret : positive := 1;         --Retención de los tiempos de reloj
    signal clk_out_i : std_logic := '0';
begin
    process(clk_in, reset_n)
    begin
        if reset_n = '0' then
            ret <= 1;
            clk_out_i <= '0';
        elsif rising_edge(clk_in) then
            ret <= ret + 1;
            if (ret = reduction) then
                clk_out_i <= NOT clk_out_i;
                ret <= 1;
            end if;
        end if;
    end process;
clk_out <= clk_out_i;
end behavioral;
