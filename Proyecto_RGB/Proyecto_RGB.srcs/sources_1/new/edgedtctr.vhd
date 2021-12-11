library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity EDGEDTCTR is
 port ( 
 CLK : in std_logic;        --Clock
 SYNC_IN : in std_logic;    --Input (from synchronizer)
 EDGE : out std_logic       --Output (falling edge detected)
 );
end EDGEDTCTR;

architecture BEHAVIORAL of EDGEDTCTR is
    signal sreg : std_logic_vector(2 downto 0) := "000";     --3 step shift register
    --El registro evalúa el nivel actual respecto a los dos previos almacenados
begin
    process (CLK)   --Actualización del registro con cada golpe de reloj
    begin
        if rising_edge(CLK) then
        sreg <= sreg(1 downto 0) & SYNC_IN;
        end if; 
    end process;
    
    with sreg select    --Condición de salida: Nivel alto sucedido de bajos
        EDGE <= '1' when "100",
                '0' when others;
end BEHAVIORAL;