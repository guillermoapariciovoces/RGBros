library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity Ciclo is
    generic(
            outputs : positive := 3
            );
    port(
        clk : in std_logic;
        reset_n : in std_logic;
        hots : out std_logic_vector(outputs-1 downto 0)
    );
end Ciclo;

architecture behavioral of Ciclo is
    signal hots_i : std_logic_vector(outputs-1 downto 0) := ('1', others => '0');
begin

    process(clk,reset_n)
    variable aux : std_logic;
    begin
        if reset_n = '0' then
            hots_i <= ('1', others => '0');
        end if;
        if rising_edge(clk) then
                hots_i <= hots_i(0) & hots(outputs-1 downto 1);
        end if;
    end process;
    
    hots <= hots_i;
    
end behavioral;