library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity Comparator is
    generic(
        width : positive := 8
     );
    port(
        in_a : in std_logic_vector(width-1 downto 0);   --Entrada 1
        in_b : in std_logic_vector(width-1 downto 0);   --Entrada 2
        aa : out std_logic;                     --Salida de A mayor
        ab : out std_logic;                     --Salida de Igual
        bb : out std_logic                      --Salida de B mayor
    );
end Comparator;

architecture dataflow of Comparator is

begin
    aa <= '1' when (in_a > in_b) else '0';
    ab <= '1' when (in_a = in_b) else '0';
    bb <= '1' when (in_a < in_b) else '0';
end dataflow;
