----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.12.2021 13:42:28
-- Design Name: 
-- Module Name: FSM_Slave - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

entity FSM_Slave is
generic(
    width : positive := 8
 ); 
  Port ( 
        reset_n     : in  std_logic; --Reset Negado asincrono
        clk         : in  std_logic; --Reloj
        START       : in  std_logic; --Señal de inicio
        REGIST_IN   : in  std_logic_vector(width-1 downto 0); --Entrada de valor de registro a modificar
        CHANGE      : in  std_logic_vector(1 downto 0); -- 01 decrementar, 10 aumentar
        DONE        : out std_logic; --Señal de finalizacion del proceso
        REGIST_OUT  : out std_logic_vector(width-1 downto 0) --Salida del valor modificado
  );
end FSM_Slave;

architecture Behavioral of FSM_Slave is
type STATES is (S0, LOAD, WORKING, FINISHED);
    signal current_state: STATES := S0;
    signal next_state: STATES;
    
    signal ce: std_logic;
    
    COMPONENT Counter
    GENERIC(
            width : positive := 8;
            mod_count : positive := 50
            );
    PORT(
        clk : in std_logic;                           --Clock
        clr_n : in std_logic;                         --Clear (negado)
        ce : in std_logic;                            --Chip Enable
        up : in std_logic;                            --Count Up (o Down)
        load_n : in std_logic;                        --Carga datos
        data_in : in std_logic_vector(width-1 downto 0);     --Valor a cargar
        code : out std_logic_vector(width-1 downto 0);        --Valor a sacar
        ov : out std_logic                            --Indicador de Overflow
        );
    END COMPONENT;
begin
Inst_counter: Counter PORT MAP(
        clk => clk,
        clr_n => reset_n,
        ce => ce,
        up => change(1),
        load_n => '1',
        data_in => REGIST_IN,
        code => REGIST_OUT
        );      
state_register: process (reset_n, CLK)
    begin                                   --Proceso encargado de avance de estados con cada golpe de reloj
    if reset_n = '0' then
        current_state <= S0;
    elsif rising_edge(CLK) then
        current_state <= next_state;
    end if;  
    end process;
nextstate_decod: process (current_state, START)
    begin            --Decodificador del siguiente estado a cargar en la máquina de estados
    
    next_state <= current_state;
    case current_state is
      when S0 =>
      DONE <= '0';
      ce <= '0';
         if START = '1' then 
            next_state <= LOAD;
         end if;

      when LOAD => 
        DONE <= '0';
        ce <= '1';
        next_state <= WORKING;

      when WORKING =>
        DONE <= '0';
        ce <= '1';
        next_state <= FINISHED;
      
      when FINISHED =>
        DONE <= '1';
        ce <= '0';
        next_state <= S0;

       when others =>
         next_state <= S0;
         DONE <= '0';
end case;
end process;
end Behavioral;

