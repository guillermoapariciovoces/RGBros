library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Master_Slave_tb is
end Master_Slave_tb;

architecture tb of Master_Slave_tb is

  component TOP is
    port (
      CLK         : in  std_logic; --Reloj
      RST_N       : in  std_logic; --Reset Negado asincrono
      BUTTON      : in std_logic_vector(3 downto 0);  --Botones de selección 
     -- ROJO        : out std_logic_vector(7 downto 0); --Salida valor de Verde (R)
     -- VERDE       : out std_logic_vector(7 downto 0); --Salida valor de Verde (G)
     -- AZUL        : out std_logic_vector(7 downto 0); --Salida valor de Azul (B)
      Color_Select: out std_logic_vector(2 downto 0) --Color seleccionado 
    );
  end component;

  signal clk          : std_logic := '0';
  signal rst_n        : std_logic;
  signal button       : std_logic_vector(3 downto 0);
 -- signal rojo         : std_logic_vector(7 downto 0);
 -- signal verde        : std_logic_vector(7 downto 0);
 -- signal azul         : std_logic_vector(7 downto 0);
  signal color_select : std_logic_vector(2 downto 0);

  constant CLK_PERIOD : time := 10 ns; 
 
begin
  dut: TOP
    port map (
      CLK     => clk,
      RST_N   => rst_n,
      BUTTON => button ,
     -- ROJO    => rojo,
     -- VERDE   => verde,
     -- AZUL   => azul,
      Color_Select => color_select
    );

  clk <= not clk after 0.5 * CLK_PERIOD;
  rst_n <= '0' after 0.25 * CLK_PERIOD, '1' after 0.75 * CLK_PERIOD;

  stimuli : process
  begin
    -- Wait till reset end
    wait until rst_n = '1';

    -- Trigger sequence
    wait until clk = '1';
    button(2) <= '1';
    button(0) <= '1';
    wait until clk = '1';
    button(2) <= '0';
    button(3) <= '1';
    button(0) <= '0';
    wait until clk = '1';
    button(3) <= '0';
    button(2) <= '1';
    button(0) <= '1';
    wait until clk = '1';
    button(2) <= '0';
    button(3) <= '1';
    button(0) <= '0';
    wait until clk = '1';
    button(3) <= '0';
    button(2) <= '1';
    button(0) <= '1';
    wait until clk = '1';
    button(2) <= '0';
    button(0) <= '0';

    -- Wait till sequence end or timeout
    wait until color_select  = "000" for 100 * CLK_PERIOD;

    -- Extend simulation for another 2 clock cycles
    for i in 1 to 2 loop
      wait until clk = '1';
    end loop;

  	assert false
  	report "[SUCCESS]: Simulation finished."
  	severity failure ;
  end process;
end tb;
