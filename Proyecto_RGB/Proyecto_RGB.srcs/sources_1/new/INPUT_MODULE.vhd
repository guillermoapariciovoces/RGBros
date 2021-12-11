library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity INPUT_MODULE is
    generic(
            inputs : positive := 4
            );
    port(
        clk : in std_logic;                                    --Clock
        button_in: in std_logic_vector(inputs-1 downto 0);
        button_out: out std_logic_vector(inputs-1 downto 0)
         );
end INPUT_MODULE;


architecture behavioral of INPUT_MODULE is

    signal sync2edge: std_logic_vector(inputs-1 downto 0);           --Señal que sale del sincronizador al detector de flancos

    COMPONENT synchrnzr
            port ( 
 CLK : in std_logic;        --Clock
 ASYNC_IN : in std_logic;   --Input (asynchronous)
 SYNC_OUT : out std_logic   --Outnput (synchronous)
 );
    END COMPONENT;
    
    
    COMPONENT edgedtctr
         port ( 
 CLK : in std_logic;        --Clock
 SYNC_IN : in std_logic;    --Input (from synchronizer)
 EDGE : out std_logic       --Output (falling edge detected)
 );
    END COMPONENT;


begin

    Inst_synchrnzr_1: synchrnzr PORT MAP(
            clk => clk,
            async_in => button_in(0),
            sync_out => sync2edge(0)
    );
    
    Inst_synchrnzr_2: synchrnzr PORT MAP(
            clk => clk,
            async_in => button_in(1),
            sync_out => sync2edge(1)
    );
    
    Inst_synchrnzr_3: synchrnzr PORT MAP(
            clk => clk,
            async_in => button_in(2),
            sync_out => sync2edge(2)
    );
    
    Inst_synchrnzr_4: synchrnzr PORT MAP(
            clk => clk,
            async_in => button_in(3),
            sync_out => sync2edge(3)
    );
    
    Inst_edgedtctr_1: edgedtctr PORT MAP(
        clk => clk,
        sync_in => sync2edge(0),
        edge => button_out(0)
    );
    
    Inst_edgedtctr_2: edgedtctr PORT MAP(
        clk => clk,
        sync_in => sync2edge(1),
        edge => button_out(1)
    );
    
    Inst_edgedtctr_3: edgedtctr PORT MAP(
        clk => clk,
        sync_in => sync2edge(2),
        edge => button_out(2)
    );
    
    Inst_edgedtctr_4: edgedtctr PORT MAP(
        clk => clk,
        sync_in => sync2edge(3),
        edge => button_out(3)
    );
    
end behavioral;