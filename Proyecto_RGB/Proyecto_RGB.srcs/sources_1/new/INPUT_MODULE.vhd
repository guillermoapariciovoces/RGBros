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
        generic(
            inputs : positive := 4;     --Nº de pulsadores empleados
            reg_size : positive := 2    --Tamaño del registro de desplazamiento
            );
        port( 
            clk : in std_logic;        --Clock
            async_in : in std_logic_vector(inputs-1 downto 0);   --Input (asynchronous)
            sync_out : out std_logic_vector(inputs-1 downto 0)   --Outnput (synchronous)
            );
    END COMPONENT;
    
    
    COMPONENT edgedtctr
        generic(
            inputs : positive := 4;     --Nº de pulsadores empleados
            reg_size : positive := 2    --Tamaño del registro de desplazamiento
        );
        port( 
            clk : in std_logic;                                  --Clock
            sync_in : in std_logic_vector(inputs-1 downto 0);    --Input (from synchronizer)
            edge : out std_logic_vector(inputs-1 downto 0)       --Output (falling edge detected)
        );
    END COMPONENT;


begin

    Inst_synchrnzr: synchrnzr PORT MAP(
            clk => clk,
            async_in => button_in,
            sync_out => sync2edge
    );
    
    Inst_edgedtctr: edgedtctr PORT MAP(
        clk => clk,
        sync_in => sync2edge,
        edge => button_out
    );


end behavioral;
