LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

entity fsm is
    port (
        reset : in std_logic;
        clk : in std_logic;
        PUSHBUTTON : in std_logic;
        LIGHT : out std_logic_vector(0 TO 3)
    );
end fsm;

architecture behavioral of fsm is
    type STATES is (S0, S1, S2, S3);
    signal current_state: STATES := S0;
    signal next_state: STATES;
    
begin

    state_register: process (RESET, CLK)
    begin                                   --Proceso encargado de avance de estados con cada golpe de reloj
    if RESET = '0' then
        current_state <= S0;
    elsif rising_edge(CLK) then
        current_state <= next_state;
    end if;  
    end process;

    nextstate_decod: process (PUSHBUTTON, current_state)
    begin                                   --Decodificador del siguiente estado a cargar en la máquina de estados
        next_state <= current_state;
        case current_state is
            when S0 =>
                if PUSHBUTTON = '1' then 
                    next_state <= S1;
                end if;
            when S1 =>
                if PUSHBUTTON = '1' then 
                    next_state <= S2;
                end if;
            when S2 => 
                if PUSHBUTTON = '1' then 
                    next_state <= S3;
                end if;
            when S3 => 
                if PUSHBUTTON = '1' then 
                    next_state <= S0;
                end if;
            when others =>
                next_state <= S0;
        end case;
    end process;
    
    output_decod: process (current_state)
    begin                                   --Decodificador de la salida en base al estado actual
        LIGHT <= (OTHERS => '0');
        case current_state is
            when S0 =>
                LIGHT(0) <= '1';
            when S1 =>
                LIGHT(1) <= '1';
            when S2 => 
                LIGHT(2) <= '1';
            when S3 => 
                LIGHT(3) <= '1';
            when others => 
                LIGHT <= (OTHERS => '0');
        end case;
    end process;
end behavioral;