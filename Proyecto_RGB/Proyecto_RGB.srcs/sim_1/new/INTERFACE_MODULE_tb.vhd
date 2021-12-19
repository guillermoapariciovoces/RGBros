----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.12.2021 14:14:28
-- Design Name: 
-- Module Name: INTERFACE_MODULE_tb - Behavioral
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

entity INTERFACE_MODULE_tb is
--  Port ( );
end INTERFACE_MODULE_tb;

architecture Behavioral of INTERFACE_MODULE_tb is
-- Component Declaration for the Unit Under Test (UUT)
component INTERFACE_MODULE
 generic(
            width : positive := 8       --Tamaño de palabra de los valores
    );
port (
         clk   : in std_logic;                                    --Clock
         reset_n : in std_logic;                                --Reset (negado)
         red_in : in std_logic_vector(width-1 downto 0);        --Entrada de componente rojo (byte)
         green_in : in std_logic_vector(width-1 downto 0);      --Entrada de componente verde (byte)
         blue_in : in std_logic_vector(width-1 downto 0);       --Entrada de componente azul (byte)
         color_select : in std_logic_vector(2 downto 0);            --Color seleccionado -> Importante, en formato ONE HOT (r,g,b)
         -- r->(1 0 0), g->(0 1 0), b->(0 0 1)
         anode : out std_logic_vector (7 downto 0);             --Selección de ánodo en la placa -> Importante NEGADO
         segment : out std_logic_vector (6 downto 0)            --Control común de segmentos del display
    );
  end component;
  
  --Inputs
  signal reset_n      : std_logic;
  signal clk          : std_logic;
  signal clk2          : std_logic;
  signal red_in       : std_logic_vector(7 downto 0);
  signal green_in     : std_logic_vector(7 downto 0);
  signal blue_in      : std_logic_vector(7 downto 0);
  signal color_select : std_logic_vector(2 downto 0);

  --Outputs
  signal anode      : std_logic_vector(7 downto 0);
  signal segment    : std_logic_vector(6 downto 0);
  
  -- Clock period definitions
  constant clk_period: time := 1 ns;
  constant DELAY: time := 0.1 * CLK_PERIOD;
  
begin

-- Instantiate the Unit Under Test (UUT)
  uut: INTERFACE_MODULE
    port map (
      RESET_n         => reset_n,
      CLK             => clk,
      red_in          => red_in,
      green_in        => green_in,
      blue_in         => blue_in,
      color_select    => color_select,
      anode           => anode,
      segment         => segment
    );
    
    -- Clock process definitions
  clk_process :process
  begin
    clk <= '0';
    wait for 0.5 * clk_period;
    clk <= '1';
    wait for 0.5 * clk_period;
  end process;
   clk_process_2 :process
  begin
    clk2 <= '0';
    wait for 0.5 * clk_period * 100000000;
    clk2 <= '1';
    wait for 0.5 * clk_period * 100000000;
  end process;
-- Stimulus process
  stim_proc: process
  begin
  
  reset_n <= '0', '1' after DELAY;
  wait until reset_n = '1';

color_select <="010";
green_in <= "00100101";

wait;
    assert false
      report "[SUCCESS]: simulation finished."
      severity failure;
    end process;
end Behavioral;
