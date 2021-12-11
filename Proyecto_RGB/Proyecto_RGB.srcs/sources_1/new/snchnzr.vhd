library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SYNCHRNZR is
 port ( 
 CLK : in std_logic;        --Clock
 ASYNC_IN : in std_logic;   --Input (asynchronous)
 SYNC_OUT : out std_logic   --Outnput (synchronous)
 );
end SYNCHRNZR;

architecture BEHAVIORAL of SYNCHRNZR is
 signal sreg : std_logic_vector(1 downto 0) := "00";    --Vector flip-flops
begin
    process (CLK)
    begin
        if rising_edge(CLK) then 
            sync_out <= sreg(1);            --Segundo flip-flop
            sreg <= sreg(0) & async_in;     --Primer flip-flop
        end if; 
    end process;
end BEHAVIORAL;