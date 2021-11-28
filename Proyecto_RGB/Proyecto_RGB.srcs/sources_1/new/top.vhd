library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std;
use ieee.std_logic_arith.ALL;


entity top is
    PORT (  reset_n : in std_logic;                     --Reset (negado)
            clk: in std_logic;                          --Reloj
            button : in std_logic_vector(3 downto 0);  --Botones de selección
            -- Orden: arriba, abajo, izda, dcha
            rgb: out std_logic_vector(2 downto 0);      --LED RGB
            led : out std_logic_vector(2 downto 0);     --LEDs auxiliares de nivel
            digctrl : out std_logic_vector(7 downto 0); --Selector de display 7s
            segment : out std_logic_vector(6 downto 0)  --Display 7s (segmentos comunes)
    );
end top;

architecture behavioral of top is
    signal sync2edge: std_logic_vector(3 downto 0);           --Señal que sale del sincronizador al detector de flancos
    signal edge2fsm: std_logic_vector(3 downto 0);            --Señal del detector de flancos a la máquina de estados

    COMPONENT synchrnzr
        generic(width : positive := 4
        );
        port ( 
            clk : in std_logic;
            async_in : in std_logic_vector(width-1 downto 0);
            sync_out : out std_logic_vector(width-1 downto 0)
        );
    END COMPONENT;
    
    COMPONENT edgedtctr
        generic(width : positive := 4
        );
        port ( 
            clk : in std_logic;
            sync_in : in std_logic_vector(width-1 downto 0);
            edge : out std_logic_vector(width-1 downto 0)
        );
    END COMPONENT;
    
    COMPONENT fsm
        PORT(
            RESET : in std_logic;
            CLK : in std_logic;
            PUSHBUTTON : in std_logic;
            LIGHT : out std_logic_vector(0 TO 3)
        );
    END COMPONENT;
    
    COMPONENT decoder
        PORT (
            code : IN std_logic_vector(3 DOWNTO 0);
            led : OUT std_logic_vector(6 DOWNTO 0)
        );
    END COMPONENT;
    
begin
    Inst_synchrnzr: synchrnzr PORT MAP(
        clk => clk,
        async_in => button,
        sync_out => sync2edge
    );

    Inst_edgedtctr: edgedtctr PORT MAP(
        clk => clk,
        sync_in => sync2edge,
        edge => edge2fsm
    );

    Inst_fsm: fsm PORT MAP (
       RESET => RESET,
       CLK => clk,
       PUSHBUTTON => edge2fsm,
       LIGHT => LIGHT
    );

end behavioral;