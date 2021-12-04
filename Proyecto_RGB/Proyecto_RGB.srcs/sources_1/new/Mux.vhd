library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.ALL;

entity Mux_hot is
    generic(
            inputs : positive := 3;
            width : positive := 8
    );
    port(
        input1 : in unsigned(width-1 downto 0);
        input2 : in unsigned(width-1 downto 0);
        input3 : in unsigned(width-1 downto 0);
        selector : in std_logic_vector (inputs-1 downto 0);
        output: out unsigned(width-1 downto 0)
    );
end Mux_hot;

architecture behavioral of Mux_hot is
begin
    with selector select
        output <= input1 when "100",
                  input2 when "010",
                  input3 when "001",
                  (others => '0') when others;
end behavioral;