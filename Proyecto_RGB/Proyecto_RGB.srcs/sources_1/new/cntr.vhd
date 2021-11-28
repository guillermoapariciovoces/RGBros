library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity cntr is
    PORT (
        clk : in std_logic;                --Clock
        ce : in std_logic;                 --Chip Enable
        code : out unsigned(3 downto 0)    --Valor de 0 a 9
        );
end cntr;

architecture behavioral of cntr is
    signal code_i : unsigned(code'range);       --Señal sobre la que se actua
begin
    process(clk)    --Incremento del contador con cada golpe de reloj
                    --(El golpe de reloj será en realidad la señal de flanco)
    begin
        if rising_edge(clk) then
            if ce = '1' then
                code_i <= (code_i + 1)mod 10;   --Módulo 10 para secuencia BCD
             end if;
        end if;
    end process;
    code <= code_i;     --Asignación a la salida
end;