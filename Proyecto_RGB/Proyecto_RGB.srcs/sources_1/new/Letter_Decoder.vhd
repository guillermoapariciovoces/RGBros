LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

entity Letter_Decoder is
    port(
        letter_hot_in : in std_logic_vector(2 downto 0);   --Importante, en formato ONE HOT
        leter_7s_out : out std_logic_vector(6 DOWNTO 0)
        );
end Letter_Decoder;


architecture Dataflow of Letter_Decoder is
begin
    WITH letter_hot_in SELECT
        leter_7s_out <= "1111010" WHEN "100",
                "0000100" WHEN "010",
                "1100000" WHEN "001",
                "0000000" WHEN others;
end architecture dataflow;
