library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std;
USE ieee.std_logic_arith.ALL;


entity top is
    PORT (  reset : in std_logic;
            clk: in std_logic;
            PUSHBUTTON : in std_logic;
            LIGHT : out std_logic_vector(0 TO 3)
    );
end top;

architecture behavioral of top is
    signal sync2edge: std_logic;           --Señal que sale del sincronizador al detector de flancos
    signal edge2fsm: std_logic;            --Señal del detector de flancos a la máquina de estados

    COMPONENT synchrnzr
        PORT ( 
            clk : in std_logic;
            async_in : in std_logic;
            sync_out : out std_logic
        );
    END COMPONENT;
    
    COMPONENT edgedtctr
        PORT ( 
            clk : in std_logic;
            sync_in : in std_logic;
            edge : out std_logic
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
        async_in => PUSHBUTTON,
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