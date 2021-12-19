--------------------------------------------------------------------------------
-- Company: 
library IEEE;
use IEEE.std_logic_1164.all;

entity FSM_MASTER_2_0_tb is
end FSM_MASTER_2_0_tb;

architecture behavior of FSM_MASTER_2_0_tb is 

  -- Component Declaration for the Unit Under Test (UUT)
  component FSM_MASTER_2_0

port (
        reset_n     : in std_logic; --Reset Negado asincrono
        clk         : in std_logic; --Reloj
        button      : in std_logic_vector(3 downto 0);  --Botones de selección 
   -- Orden: arriba (aumentar valor), abajo (decrementar valor), izda(B->G->R), dcha(R->G->B)
   -- Suponemos 3                      2                            1            0
        RED         : out std_logic_vector(1 downto 0); --Salida valor de Rojo (R)
        GREEN       : out std_logic_vector(1 downto 0); --Salida valor de verde (G)
        BLUE        : out std_logic_vector(1 downto 0); --Salida valor de Azul (B)
        Color_Select: out std_logic_vector(2 downto 0)--Color actual en seleccion (R, G, B)
        
    );
  end component;

  --Inputs
  signal reset_n   : std_logic;
  signal clk       : std_logic;
  signal button    : std_logic_vector(3 downto 0);

  --Outputs
  signal red              : std_logic_vector(1 downto 0);
  signal green            : std_logic_vector(1 downto 0);
  signal blue             : std_logic_vector(1 downto 0);
  signal color_select     : std_logic_vector(2 downto 0);
  
  -- Clock period definitions
  constant clk_period: time := 10 ns;
  constant DELAY: time := 0.1 * CLK_PERIOD;

begin
  -- Instantiate the Unit Under Test (UUT)
  uut: FSM_MASTER_2_0
    port map (
      RESET_n        => reset_n,
      CLK            => clk,
      BUTTON         => button,
      red           => red,
      green          => green,
      blue           => blue,
      Color_Select   => color_select
    );

  -- Clock process definitions
  clk_process :process
  begin
    clk <= '0';
    wait for 0.5 * clk_period;
    clk <= '1';
    wait for 0.5 * clk_period;
  end process;

  --reset_n <= '1' after 0.25 * clk_period, '0' after 0.75 * clk_period;

  -- Stimulus process
  stim_proc: process
  begin
  
  reset_n <= '0', '1' after DELAY;
  wait until reset_n = '1';
  --Comprobación de Color_Select/STATES
    button(3) <= '1';
    wait for clk_period;
    button(3) <= '0';
    assert color_select = "010"
      report "[FAILED]: el valor de Color_Select no es correcto"
      severity failure;
    
    button(0) <= '1';
    wait for clk_period;
    button(0) <= '0';
    assert green = "11"
      report "[FAILED]: error en CHIP Enable y UP"
      severity failure;
    wait for clk_period;
    
        button(1) <= '1';
    wait for clk_period;
    button(1) <= '0';
    assert green = "10"
      report "[FAILED]: error en CHIP Enable y UP(down)"
      severity failure;
    wait for clk_period;
    
button(3) <= '1';
    wait for clk_period;
    button(3) <= '0';
    assert color_select = "001"
      report "[FAILED]: el valor de Color_Select no es correcto"
      severity failure;

button(3) <= '1';
    wait for clk_period;
    button(3) <= '0';
    assert color_select = "100"
      report "[FAILED]: el valor de Color_Select no es correcto"
      severity failure;
      

    assert false
      report "[SUCCESS]: simulation finished."
      severity failure;
  end process;
end;
