----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.12.2021 15:14:17
-- Design Name: 
-- Module Name: FSM_Master - Behavioral
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

entity FSM_Master is
generic(
    width : positive := 8
        );
port (
        reset_n     : in std_logic; --Reset Negado asincrono
        clk         : in std_logic; --Reloj
        button      : in std_logic_vector(3 downto 0);  --Botones de selección 
   -- Orden: arriba (aumentar valor), abajo (decrementar valor), izda(B->G->R), dcha(R->G->B)
   -- Suponemos 3                      2                            1            0
        ROJO        : out std_logic_vector(width-1 downto 0); --Salida valor de Rojo (R)
        VERDE       : out std_logic_vector(width-1 downto 0); --Salida valor de Verde (G)
        AZUL        : out std_logic_vector(width-1 downto 0); --Salida valor de Azul (B)
        Color_Select: out std_logic_vector(0 to 2); --Color seleccionado 
-- r->(1 0 0), g->(0 1 0), b->(0 0 1) -> Importante, en formato ONE HOT (r,g,b)

        --Comunicacion con la maquina esclava
        DONE        : in std_logic;
        REGIST_IN   : in  std_logic_vector(width-1 downto 0);
        START       : out std_logic;
        REGIST_OUT  : out std_logic_vector(width-1 downto 0);
        CHANGE      : out std_logic_vector(1 downto 0) -- 01 decrementar, 10 aumentar
    );
end FSM_Master;

architecture Behavioral of FSM_Master is
type STATES is (SR, SG, SB, SR_SLAVE, SG_SLAVE, SB_SLAVE);
    signal current_state: STATES := SR;
    signal next_state: STATES;
    
signal red: std_logic_vector(width-1 downto 0);
signal green: std_logic_vector(width-1 downto 0);
signal blue: std_logic_vector(width-1 downto 0);

begin
state_register: process (reset_n, CLK)
    begin                                   --Proceso encargado de avance de estados con cada golpe de reloj
    if reset_n = '0' then
        current_state <= SR;
    elsif rising_edge(CLK) then
        current_state <= next_state;
    end if;  
    end process;
nextstate_decod: process (BUTTON, current_state, DONE)
    begin            --Decodificador del siguiente estado a cargar en la máquina de estados
    next_state <= current_state;
    START <= '0';
    Color_Select <= "000";
        case current_state is
        when SR =>
            START <= '0';
            Color_Select <= "100";
            if BUTTON(0) = '1' then 
                    next_state <= SG;
                end if;
            if BUTTON(1) = '1' then 
                    next_state <= SB;
                end if;   
            if (BUTTON(3) = '1') or (BUTTON(2) = '1') then 
                    next_state <= SR_SLAVE;
                end if;
        when SR_SLAVE =>
             START <= '1';
             Color_Select <= "100";
             CHANGE <= BUTTON(3) & BUTTON(2);
             REGIST_OUT <= red;            
        if DONE = '1' then
          red <= REGIST_IN;
          next_state <= SR;
        end if;

        when SG =>
            START <= '0';
            Color_Select <= "010";        
            if BUTTON(0) = '1' then 
                    next_state <= SB;
                end if;
            if BUTTON(1) = '1' then 
                    next_state <= SR;
                end if;   
            if (BUTTON(3) = '1') or (BUTTON(2) = '1') then 
                    next_state <= SG_SLAVE;
                end if;

        when SG_SLAVE =>
             START <= '1';
             Color_Select <= "010";
             CHANGE <= BUTTON(3) & BUTTON(2);            
             REGIST_OUT <= green;
             
        if DONE = '1' then
          green <= REGIST_IN;
          next_state <= SG;
        end if;

        when SB =>
            START <= '0';  
            Color_Select <= "001";      
            if BUTTON(0) = '1' then 
                    next_state <= SR;
                end if;
            if BUTTON(1) = '1' then 
                    next_state <= SG;
                end if;   
            if (BUTTON(3) = '1') or (BUTTON(2) = '1') then  
                    next_state <= SB_SLAVE;
                end if;

        when SB_SLAVE =>
             START <= '1';
             Color_Select <= "001";  
             CHANGE <= BUTTON(3) & BUTTON(2);  
             REGIST_OUT <= blue; 
        if DONE = '1' then
          blue <= REGIST_IN;
          next_state <= SB;
        end if;

        when others =>
                START <= '0';
                next_state <= SR;
end case;
ROJO <= red;
VERDE <= green;
AZUL <= blue;

    end process;
end Behavioral;

