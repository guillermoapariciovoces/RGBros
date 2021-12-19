library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

--Contador cíclico
--Permite carga
--Permite cuenta arriba y cuenta abajo

entity Counter is
    generic(
            width : positive := 8;
            mod_count : positive := 50
        );
    PORT (
          clk : in std_logic;                                   --Clock
          clr_n : in std_logic;                                 --Clear (negado)
          ce : in std_logic;                                    --Chip Enable
          up : in std_logic;                                    --Count Up (o Down)
          load_n : in std_logic;                                --Carga datos
          data_in : in std_logic_vector(width-1 downto 0);      --Valor a cargar
          code : out std_logic_vector(width-1 downto 0);        --Valor a sacar
          ov : out std_logic                                    --Indicador de Overflow
        );
end Counter;

architecture behavioral of Counter is
    signal code_i : unsigned(width-1 downto 0):= (others => '0');       --Señal sobre la que se actua
begin
    process(clk, clr_n)
    begin
        if clr_n = '0' then
            code_i <= to_unsigned(0,code_i'length);
        elsif rising_edge(clk) then
            if ce = '1' then
                if load_n = '0' then    --Carga de datos
                    code_i <= unsigned(data_in);
                elsif up = '1' then
                    code_i <= (code_i + 1)mod mod_count;   --Bucle de cuenta positiva (overflow)
                    if code_i = mod_count-1 then
                        ov <= '1';
                    else 
                        ov <= '0';
                    end if;
                else -- up = '0'
                    code_i <= (code_i - 1 + mod_count)mod mod_count;    --Bucle de cuenta negativa (underflow)
                    if code_i = 0 then
                        ov <= '1';
                    else 
                        ov <= '0';
                    end if;
                end if;
            end if;
        end if;
    end process;
    code <= std_logic_vector(code_i);     --Asignación a la salida

end;