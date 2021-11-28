library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity edgedtctr is
 port ( 
 clk : in std_logic;        --Clock
 sync_in : in std_logic;    --Input (from synchronizer)
 edge : out std_logic       --Output (falling edge detected)
 );
end edgedtctr;

architecture behavioral of edgedtctr is
    signal sreg : std_logic_vector(2 downto 0) := "000";     --3 step shift register
    --El registro evalúa el nivel actual respecto a los dos previos almacenados
begin
    process(clk)   --Actualización del registro con cada golpe de reloj
    begin
        if rising_edge(clk) then
        sreg <= sreg(1 downto 0) & sync_in;
        end if; 
    end process;
    
    with sreg select    --Condición de salida: Nivel alto sucedido de bajos
        edge <= '1' when "100",
                '0' when others;
end behavioral;