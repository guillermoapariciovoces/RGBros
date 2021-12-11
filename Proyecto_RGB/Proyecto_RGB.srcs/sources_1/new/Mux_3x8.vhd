library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_arith.ALL;


entity Mux_3x8 is
    generic(
            inputs : positive := 3;
            width : positive := 8
    );
    port(
        input1 : in std_logic_vector (width-1 downto 0);
        input2 : in std_logic_vector (width-1 downto 0);
        input3 : in std_logic_vector (width-1 downto 0);
        selector : in std_logic_vector (inputs-1 downto 0);
        output: out std_logic_vector(width-1 downto 0)
    );
end Mux_3x8;


architecture behavioral of Mux_3x8 is
begin
    
    with selector select
        output <= input1 when "1--",
                  input2 when "01-",
                  input3 when "001",
                  "11111111" when others;

end behavioral;