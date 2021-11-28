library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity edgedtctr is
    generic(width : positive := 1
    );
    port ( 
        clk : in std_logic;        --Clock
        sync_in : in std_logic_vector(width-1 downto 0);    --Input (from synchronizer)
        edge : out std_logic_vector(width-1 downto 0)       --Output (falling edge detected)
    );
end edgedtctr;

architecture behavioral of edgedtctr is
    type sreg_t is array(width-1 downto 0) of std_logic_vector(2 downto 0);
    signal sreg : sreg_t := ("000", "000", "000", "000"); --Vector flip-flops
    --El registro evalúa el nivel actual respecto a los dos previos almacenados
begin
    process(clk)   --Actualización del registro con cada golpe de reloj
    begin
        if rising_edge(clk) then
            for i in 0 to width-1 loop
                sreg(i) <= sreg(i)(1 downto 0) & sync_in(i);
            end loop;
        end if; 
    end process;
    
    edge_for: for i in 0 to width-1 generate
        with sreg(i) select    --Condición de salida: Nivel alto sucedido de bajos
            edge(i) <= '1' when "100",
                        '0' when others;
    end generate edge_for;
end behavioral;