----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.12.2021 13:59:05
-- Design Name: 
-- Module Name: BCD_Decoder_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
use ieee.std_logic_arith.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity BCD_Decoder_tb is
--  Port ( );
end BCD_Decoder_tb;

architecture Behavioral of BCD_Decoder_tb is
-- Component Declaration for the Unit Under Test (UUT)
component BCD_Decoder

 port(
        code_bin_in   : in std_logic_vector (7 downto 0);
        code_bcd1_out : out std_logic_vector (3 downto 0);
        code_bcd2_out : out std_logic_vector (3 downto 0);
        code_bcd3_out : out std_logic_vector (3 downto 0)
        );
  end component;
  
  --Inputs
  signal code_bin_in     : std_logic_vector (7 downto 0);

  --Outputs
  signal code_bcd1_out   : std_logic_vector (3 downto 0);
  signal code_bcd2_out   : std_logic_vector (3 downto 0);
  signal code_bcd3_out   : std_logic_vector (3 downto 0);
  
  constant DELAY: time := 1ns;
  
begin
-- Instantiate the Unit Under Test (UUT)
  uut: BCD_Decoder 
    port map (
      code_bin_in        => code_bin_in,
      code_bcd1_out            => code_bcd1_out,
      code_bcd2_out            => code_bcd2_out,
      code_bcd3_out            => code_bcd3_out
    );
    
-- Stimulus process
  stim_proc: process
  begin

code_bin_in <= "00110011"; --Decimal 051
wait for DELAY;
    assert code_bcd1_out = X"1" and code_bcd2_out = X"5" and code_bcd3_out = X"0"
      report "[FAILED]: el valor de salida no es correcto"
      severity failure;
      
code_bin_in <= "00011011"; --Decimal 027
wait for DELAY;
    assert code_bcd1_out = X"7" and code_bcd2_out = X"2" and code_bcd3_out = X"0"
      report "[FAILED]: el valor de salida no es correcto"
      severity failure;

    assert false
      report "[SUCCESS]: simulation finished."
      severity failure;
  end process;

end Behavioral;
