LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
use ieee.std_logic_arith.ALL;



entity BCD_Decoder is
    port(
        code_bin_in : in std_logic_vector (7 downto 0);
        code_bcd1_out : out std_logic_vector (3 downto 0);
        code_bcd2_out : out std_logic_vector (3 downto 0);
        code_bcd3_out : out std_logic_vector (3 downto 0)
        );
end entity;


architecture behavioral of BCD_Decoder is 
begin
    process(code_bin_in)
        variable binx : std_logic_vector(7 downto 0) ;
        variable bcd : std_logic_vector(11 downto 0) ;
    begin
    bcd := (others => '0');
    binx := code_bin_in(7 downto 0);

    for i in binx'range loop
        if bcd(3 downto 0) > "0100" then
          bcd(3 downto 0) := std_logic_vector(bcd(3 downto 0) + "0011"); 

        end if ;
        if bcd(7 downto 4) > "0100" then
           bcd(7 downto 4) := std_logic_vector(bcd(7 downto 4) + "0011");   
        end if ;
        bcd := bcd(10 downto 0) & binx(7) ; 
        binx := binx(6 downto 0) & '0' ; 
    end loop ;

    code_bcd3_out <= bcd(11 downto 8) ;
    code_bcd2_out <= bcd(7  downto 4) ;
    code_bcd1_out <= bcd(3  downto 0) ;
end process ;
end architecture;
