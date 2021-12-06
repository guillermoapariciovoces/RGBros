library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.ALL;

package extra_pkg is
        type std_logic_array is array(natural range <>) of std_logic_vector;
end package;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.ALL;
use work.extra_pkg.all;

entity edgedtctr is
    generic(
            inputs : positive := 4;     --Nº de pulsadores empleados
            reg_size : positive := 2    --Tamaño del registro de desplazamiento
    );
    port( 
        clk : in std_logic;                                 --Clock
        sync_in : in std_logic_vector(inputs-1 downto 0);    --Input (from synchronizer)
        edge : out std_logic_vector(inputs-1 downto 0)       --Output (falling edge detected)
    );
end edgedtctr;

architecture behavioral of edgedtctr is
    subtype vec_t is std_logic_vector(reg_size-1 downto 0);
    type arr_tt is array(inputs-1 downto 0) of vec_t;
    signal sreg : arr_tt := (others => X"0"); --Vector flip-flops
    --El registro evalúa el nivel actual respecto a los dos previos almacenados
begin
    process(clk)   --Actualización del registro con cada golpe de reloj
    begin
        if rising_edge(clk) then
            for i in 0 to inputs-1 loop
                sreg(i) <= sreg(i)(reg_size-1 downto 0) & sync_in(i);
            end loop;
        end if; 
    end process;
    
    edge_for: for i in 0 to inputs-1 generate
        with sreg(i) select    --Condición de salida: Nivel alto sucedido de bajos
            edge(i) <= '1' when ('1', others => '0'),
                        '0' when others;
    end generate edge_for;
end behavioral;