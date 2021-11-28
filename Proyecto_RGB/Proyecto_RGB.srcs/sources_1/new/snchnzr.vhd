library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity synchrnzr is
    port ( 
        clk : in std_logic;        --Clock
        async_in : in std_logic;   --Input (asynchronous)
        sync_out : out std_logic   --Outnput (synchronous)
    );
end synchrnzr;

architecture behavioral of synchrnzr is
    signal sreg : std_logic_vector(1 downto 0) := "00";    --Vector flip-flops
begin
    process(clk)
    begin
        if rising_edge(clk) then 
            sync_out <= sreg(1);            --Segundo flip-flop
            sreg <= sreg(0) & async_in;     --Primer flip-flop
        end if; 
    end process;
end behavioral;