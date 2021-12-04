library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

--Contador cíclico de módulo 40 base para todo el architecture
--Permite cuenta arriba y cuenta abajo

entity Counter is
    generic(width : positive := 8;
            mod_count : positive := 50
        );
    PORT (
        clk : in std_logic;                           --Clock
        clr_n : in std_logic;                         --Clear (negado)
        ce : in std_logic;                            --Chip Enable
        up : in std_logic;                            --Count Up (o Down)
        load_n : in std_logic;                        --Carga datos
        data_in : out unsigned(width-1 downto 0);     --Valor a cargar
        code : out unsigned(width-1 downto 0);        --Valor a sacar
        ov : out std_logic                            --Indicador de Overflow
        );
end Counter;

architecture behavioral of Counter is
    signal code_i : unsigned(code'range);       --Señal sobre la que se actua
begin
    process(clk)
    begin
        if clr_n = '0' then
            code_i <= to_unsigned(0,code'length);
        elsif rising_edge(clk) then
            if ce = '1' then
                if load_n = '0' then    --Carga de datos
                    code_i <= data_in;
                elsif up = '1' then
                    code_i <= (code_i + 1)mod mod_count;   --Bucle de cuenta positiva (overflow)
                else -- up = '0'
                    code_i <= (code_i - 1 + mod_count)mod mod_count;    --Bucle de cuenta negativa (underflow)
                end if;
            end if;
        end if;
    end process;
    code <= code_i;     --Asignación a la salida
    
    process(up, code_i)     --Checkeo de overflow
    begin
        ov <= '0';
        if (up = '1') and (code_i = 2**width-1) then
            ov <= '1';
        elsif (up = '0') and (code_i = 0) then
            ov <= '1';
        end if;
    end process;
end;