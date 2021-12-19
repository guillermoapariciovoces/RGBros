----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.12.2021 13:45:26
-- Design Name: 
-- Module Name: Ciclo_tb - Behavioral
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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Ciclo_tb is
--  Port ( );
end Ciclo_tb;

architecture Behavioral of Ciclo_tb is
-- Component Declaration for the Unit Under Test (UUT)
component Ciclo

port (
        clk : in std_logic;
        reset_n : in std_logic;
        hots : out std_logic_vector(2 downto 0)
    );
  end component;
  
  --Inputs
  signal reset_n   : std_logic;
  signal clk       : std_logic;

  --Outputs
  signal hots      : std_logic_vector(2 downto 0);
  
  -- Clock period definitions
  constant clk_period: time := 10 ns;
  constant DELAY: time := 0.1 * CLK_PERIOD;
  
begin
-- Instantiate the Unit Under Test (UUT)
  uut: Ciclo
    port map (
      RESET_n        => reset_n,
      CLK            => clk,
      hots           => hots
    );
    
    -- Clock process definitions
  clk_process :process
  begin
    clk <= '0';
    wait for 0.5 * clk_period;
    clk <= '1';
    wait for 0.5 * clk_period;
  end process;
-- Stimulus process
  stim_proc: process
  begin
  
  reset_n <= '0', '1' after DELAY;
  wait until reset_n = '1';

wait for clk_period;
wait for DELAY;
    assert hots = "010"
      report "[FAILED]: el valor de HOTS no es correcto"
      severity failure;
      
 wait for clk_period;
 wait for DELAY;
    assert hots = "001"
      report "[FAILED]: el valor de HOTS no es correcto"
      severity failure;
      
 wait for clk_period;
 wait for DELAY;
    assert hots = "100"
      report "[FAILED]: el valor de HOTS no es correcto"
      severity failure;

    assert false
      report "[SUCCESS]: simulation finished."
      severity failure;
  end process;

end Behavioral;
