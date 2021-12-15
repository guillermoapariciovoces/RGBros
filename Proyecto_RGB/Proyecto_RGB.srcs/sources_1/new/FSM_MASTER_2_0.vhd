----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.12.2021 14:16:58
-- Design Name: 
-- Module Name: FSM_MODULE_2_0 - Behavioral
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FSM_MASTER_2_0 is
port (
        reset_n     : in std_logic; --Reset Negado asincrono
        clk         : in std_logic; --Reloj
        button      : in std_logic_vector(3 downto 0);  --Botones de selección 
   -- Orden: arriba (aumentar valor), abajo (decrementar valor), izda(B->G->R), dcha(R->G->B)
   -- Suponemos 3                      2                            1            0
   --Prioridad => mas prioridad 3 2 1 0 menos prioridad
        Color_Select: out std_logic_vector(2 downto 0); --Color seleccionado PROVISIONAL
-- r->(1 0 0), g->(0 1 0), b->(0 0 1) -> Importante, en formato ONE HOT (r,g,b)

        --Comunicacion con contadores
        -- Primer bit es chip enable, segundo el up
        RED      : out std_logic_vector(1 downto 0);
        GREEN    : out std_logic_vector(1 downto 0);
        BLUE     : out std_logic_vector(1 downto 0)
        );
        
end FSM_MASTER_2_0;

architecture Behavioral of FSM_MASTER_2_0 is
type STATES is (SR, SG, SB, SR_COUNTER_MAS, SR_COUNTER_MENOS,SG_COUNTER_MAS, SG_COUNTER_MENOS,SB_COUNTER_MAS,SB_COUNTER_MENOS);
    signal current_state: STATES := SR;
    signal next_state: STATES;
    

begin
state_register: process (reset_n, CLK)
    begin                                   --Proceso encargado de avance de estados con cada golpe de reloj
    if reset_n = '0' then
        current_state <= SR;
    elsif rising_edge(CLK) then
        current_state <= next_state;
    end if;  
    end process;
nextstate_decod: process (BUTTON, current_state)
    begin            --Decodificador del siguiente estado a cargar en la máquina de estados
    next_state <= current_state;
    RED  <= "00";
    GREEN<= "00";
    BLUE <= "00";
        case current_state is
        when SR =>
        Color_Select <= "100";
            if BUTTON(3) = '1' then 
                    next_state <= SG;
                end if;
            if BUTTON(2) = '1' then 
                    next_state <= SB;
                end if;   
            if (BUTTON(1) = '1') then  
                    next_state <= SR_COUNTER_MENOS;
                end if;
            if (BUTTON(0) = '1') then  
                    next_state <= SR_COUNTER_MAS;
                end if;
                
        when SR_COUNTER_MAS =>
             Color_Select <= "100";
             RED <= "11";     
             next_state <= SR;
             
      when SR_COUNTER_MENOS =>
             Color_Select <= "100";
             RED <= "10";     
             next_state <= SR;

        when SG =>
        Color_Select <= "010";        
            if BUTTON(3) = '1' then 
                    next_state <= SB;
                end if;
            if BUTTON(2) = '1' then 
                    next_state <= SR;
                end if;   
            if (BUTTON(1) = '1') then  
                    next_state <= SG_COUNTER_MENOS;
                end if;
            if (BUTTON(0) = '1') then  
                    next_state <= SG_COUNTER_MAS;
                end if;

        when SG_COUNTER_MAS =>
            Color_Select <= "010";                
            GREEN <= "11";  
             next_state <= SG;
        when SG_COUNTER_MENOS =>
            Color_Select <= "010";                
            GREEN <= "10";  
             next_state <= SG;
             
        when SB =>
           Color_Select <= "001";      
            if BUTTON(3) = '1' then 
                    next_state <= SR;
                end if;
            if BUTTON(2) = '1' then 
                    next_state <= SG;
                end if;   
            if (BUTTON(1) = '1') then  
                    next_state <= SB_COUNTER_MENOS;
                end if;
            if (BUTTON(0) = '1') then  
                    next_state <= SB_COUNTER_MAS;
                end if;

        when SB_COUNTER_MAS =>
             Color_Select <= "001";
             BLUE <= "11"; 
             next_state <= SB; 
        when SB_COUNTER_MENOS =>
             Color_Select <= "001";
             BLUE <= "10"; 
             next_state <= SB; 

        when others =>
                next_state <= SR;
                Color_Select <= "000";
end case;
end process;
end Behavioral;
