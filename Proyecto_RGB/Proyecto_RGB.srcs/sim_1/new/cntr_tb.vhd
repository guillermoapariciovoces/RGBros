library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
 
entity cntr_tb is
end cntr_tb;
 
architecture behavior of cntr_tb is 

  -- Component Declaration for the Unit Under Test (UUT)
  component Counter
    generic (
      width : positive := 8;
      mod_count : positive := 50
    );
    port(
          clk : in std_logic;                                   --Clock
          clr_n : in std_logic;                                 --Clear (negado)
          ce : in std_logic;                                    --Chip Enable
          up : in std_logic;                                    --Count Up (o Down)
          load_n : in std_logic;                                --Carga datos
          data_in : in std_logic_vector(width-1 downto 0);      --Valor a cargar
          code : out std_logic_vector(width-1 downto 0);        --Valor a sacar
          ov : out std_logic                                    --Indicador de Overflow
    );
  end component;

  --Inputs
  signal clr_n   : std_logic;
  signal clk     : std_logic;
  signal up      : std_logic;
  signal ce      : std_logic;
  signal load_n  : std_logic;
  signal data_in : std_logic_vector(7 downto 0) := "00001111";

  --Outputs
  signal ov    : std_logic;
  signal code  : std_logic_vector(7 downto 0);

  -- Clock period definitions
  constant CLK_PERIOD: time := 10 ns;
  constant DELAY: time := 0.1 * CLK_PERIOD;

begin
 
	-- Instanciación de Unit Under Test (UUT)
  uut: Counter
    generic map (
      WIDTH => 8
    )
    port map (
      CLR_N   => clr_n,
      CLK     => clk,
      UP      => up,
      CE      => ce,
      LOAD_N  => load_n,
      data_in => data_in ,
      ov      => ov,
      code    => code
    );

  -- Definición de Clock process
  clk_process :process
  begin
    clk <= '0';
    wait for 0.5 * CLK_PERIOD;
    clk <= '1';
    wait for 0.5 * CLK_PERIOD;
  end process;

  -- Definición de Stimulus process
--  clr_n  <= '0' after 0.25 * CLK_PERIOD, '1' after 0.75 * CLK_PERIOD;
--  load_n <= '0' after 0.25 * CLK_PERIOD, '1' after 1.75 * CLK_PERIOD;
--  up     <= '0' after 0.25 * CLK_PERIOD, '1' after 7.25 * CLK_PERIOD;
--  ce     <= '0' after 0.25 * CLK_PERIOD, '1' after 7.25 * CLK_PERIOD,
--            '0' after 8.25 * CLK_PERIOD;

  stim_proc: process
  begin
  ce <= '0', '1' after DELAY;
  up <= '1';
  clr_n <= '0', '1' after DELAY;
  
    -- Comprobar CLR_N
    wait until clr_n = '0';
    wait for DELAY;
    assert to_integer(unsigned(code)) = 0
      report "[FAILED]: CLR_N malfunction."
      severity failure;
    wait until clk = '1';
    wait for DELAY;
    assert to_integer(unsigned(code)) = 1
      report "[FAILED]: CLR_N malfunction."
      severity failure;

    -- Comprobar LOAD_N
    load_n <= '0';
    wait until clk = '1';
    wait for DELAY;
    assert to_integer(unsigned(code)) = 15
      report "[FAILED]: LOAD_N malfunction."
      severity failure;
--    wait until clk = '1';
--    wait for DELAY;
--    assert to_integer(unsigned(code)) = 32
--      report "[FAILED]: LOAD_N malfunction."
--      severity failure;

    -- Comprobar countup
    load_n <= '1';
    up <= '1';
    clr_n <= '0', '1' after DELAY;
    wait until clr_n = '1';
    
    for i in 1 to 100 loop
        wait until clk = '1';
        wait for DELAY;
        
        assert to_integer(unsigned(code)) = i mod 50
        report "[FAILED]: countdown malfunction."
        severity failure;
    end loop;
    
--    for i in 4 downto 1 loop
--      wait until clk = '1';
--      wait for DELAY;
--      assert ov = '0' and to_integer(unsigned(code)) = i
--        report "[FAILED]: countdown malfunction."
--        severity failure;
--    end loop;
    
    
    --Comprobar OV
    assert ov = '1'
        report "[FAILED]: countdown malfunction."
        severity failure;    


    -- Comprobar CE
    ce <= '0';
    wait until clk = '1';
    wait for DELAY;
for i in 1 to 4 loop
        wait until clk = '1';
        wait for DELAY;
        
        assert to_integer(unsigned(code)) = 0
        report "[FAILED]: CE malfunction."
        severity failure;
    end loop;

    -- Comprobar countdown
    ce <= '1';
    up <= '0';
for i in 99 downto 1 loop
        wait until clk = '1';
        wait for DELAY;
        
        assert to_integer(unsigned(code)) = i mod 50
        report "[FAILED]: countdown malfunction."
        severity failure;
    end loop;    

    -- Fin de simulación
    assert false
      report "[SUCCESS]: Simulation finished."
      severity failure;

  end process;

end;