library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.ALL;

entity synchrnzr is
    generic(
            inputs : positive := 4;     --Nº de pulsadores empleados
            reg_size : positive := 2    --Tamaño del registro de desplazamiento
    );
    port( 
        clk : in std_logic;        --Clock
        async_in : in std_logic_vector(inputs-1 downto 0);   --Input (asynchronous)
        sync_out : out std_logic_vector(inputs-1 downto 0)   --Outnput (synchronous)
    );
end synchrnzr;

architecture behavioral of synchrnzr is
    subtype vec_t is std_logic_vector(reg_size-1 downto 0);
    type arr_tt is array(inputs-1 downto 0) of vec_t;
    signal sreg : arr_tt := (others => X"0"); --Vector flip-flops
begin
    process(clk)
    begin
        if rising_edge(clk) then 
            for i in 0 to inputs-1 loop
                sync_out(i) <= sreg(i)(reg_size-1);                     --Segundo flip-flop
                sreg(i) <= sreg(i)(reg_size-2 downto 0) & async_in(i);  --Primer flip-flop
            end loop;
        end if; 
    end process;
end behavioral;