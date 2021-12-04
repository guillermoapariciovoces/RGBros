LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;


entity Segment_Decoder is
    generic(
            width : positive := 6
            );
    port(
         din : in unsigned(width-1 downto 0);
         dout1 : out unsigned(width-1 downto 0);
         dout2: out unsigned(width-1 downto 0)
            );      
end Segment_Decoder;


architecture behavioral of Segment_Decoder is

begin


end behavioral;
