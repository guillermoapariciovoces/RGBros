LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

entity Letter_Decoder is
    port(
        letter : in std_logic_vector(3 DOWNTO 0);   --Importante, en formato ONE HOT
        code : out unsigned(6 DOWNTO 0)
        );
end Letter_Decoder;


architecture Dataflow of Letter_Decoder is
begin
    WITH letter SELECT
        code <= "0000101" WHEN "000",
                "1111011" WHEN "000",
                "0011111" WHEN "001",
                "1111111" WHEN others;
end architecture dataflow;
