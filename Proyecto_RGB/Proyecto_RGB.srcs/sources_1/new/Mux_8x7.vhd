library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_arith.ALL;


entity Mux_8x7 is
    generic(
            inputs : positive := 8;
            width : positive := 7
    );
    port(
        input1 : in std_logic_vector (width-1 downto 0);
        input2 : in std_logic_vector (width-1 downto 0);
        input3 : in std_logic_vector (width-1 downto 0);
        input4 : in std_logic_vector (width-1 downto 0);
        input5 : in std_logic_vector (width-1 downto 0);
        input6 : in std_logic_vector (width-1 downto 0);
        input7 : in std_logic_vector (width-1 downto 0);
        input8 : in std_logic_vector (width-1 downto 0);
        selector : in std_logic_vector (inputs-1 downto 0);
        output: out std_logic_vector(width-1 downto 0)
    );
end Mux_8x7;


architecture behavioral of Mux_8x7 is
begin
    
    with selector select
        output <= input1 when "10000000",
                  input2 when "01000000",
                  input3 when "00100000",
                  input4 when "00010000",
                  input5 when "00001000",
                  input6 when "00000100",
                  input7 when "00000010",
                  input8 when "00000001",
                  "1111111" when others;

end behavioral;
