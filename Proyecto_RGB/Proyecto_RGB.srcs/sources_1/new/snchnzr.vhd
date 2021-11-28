library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity synchrnzr is
    generic(width : positive := 1
    );
    port ( 
        clk : in std_logic;        --Clock
        async_in : in std_logic_vector(width-1 downto 0);   --Input (asynchronous)
        sync_out : out std_logic_vector(width-1 downto 0)   --Outnput (synchronous)
    );
end synchrnzr;

architecture behavioral of synchrnzr is
    type sreg_t is array(width-1 downto 0) of std_logic_vector(1 downto 0);
    signal sreg : sreg_t := ("00", "00", "00", "00"); --Vector flip-flops
begin
    process(clk)
    begin
        if rising_edge(clk) then 
            for i in 0 to width-1 loop
                sync_out(i) <= sreg(i)(1);            --Segundo flip-flop
                sreg(i) <= sreg(i)(0) & async_in(i);  --Primer flip-flop
            end loop;
        end if; 
    end process;
end behavioral;