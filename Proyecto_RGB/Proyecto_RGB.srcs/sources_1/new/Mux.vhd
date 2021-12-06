library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.ALL;

package mux_pkg is
        subtype vec_t is std_logic_vector(inputs-1 downto 0);
        type arr_tt is array(width-1 downto 0) of vec_t;
end package;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.ALL;
use work.mux_pkg.all;

entity Mux_hot is
    generic(
            inputs : positive := 3;
            width : positive := 8
    );
    port(
        input : in arr_tt;  --OJO, que puede no funcionar la el array
        --input2 : in unsigned(width-1 downto 0);
        --input3 : in unsigned(width-1 downto 0);
        selector : in std_logic_vector (inputs-1 downto 0);
        output: out std_logic_vector(width-1 downto 0)
    );
end Mux_hot;

architecture behavioral of Mux_hot is
begin
    
    output_for: for i in inputs-1 downto 0 generate
        output <= input(i) when selector(i) = '1';
    end generate;

end behavioral;