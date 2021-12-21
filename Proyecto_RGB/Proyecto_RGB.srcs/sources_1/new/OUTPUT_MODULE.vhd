library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std;
use ieee.std_logic_arith.ALL;

-- Módulo que gestiona la salida del RGB (procesado de los valores de la fsm a PWM

entity OUTPUT_MODULE is
    generic(
            width : positive := 8;                      -- Tamaño de las variables
            level_range : positive := 50;               -- Nº de niveles RGB posible
            prescaler_reduction : positive := 10000000    -- Reducción de la temporización para los 7-segmentos
            );
    port(
         clk : in std_logic;                                    --Clock
         reset_n : in std_logic;                                --Reset (negado)
         red_in : in std_logic_vector(width-1 downto 0);        --Entrada de componente rojo (byte)
         green_in : in std_logic_vector(width-1 downto 0);      --Entrada de componente verde (byte)
         blue_in : in std_logic_vector(width-1 downto 0);       --Entrada de componente azul (byte)
         red_out : out std_logic;                               --Salida de componente rojo (PWM)
         green_out : out std_logic;                             --Salida de componente verde (PWM)
         blue_out : out std_logic                               --Salida de componente azul (PWM)
    );
end OUTPUT_MODULE;

architecture behavioral of OUTPUT_MODULE is

    signal counter2comparator : std_logic_vector(width-1  downto 0);
    signal prescaler_out : std_logic;


    COMPONENT Counter
    GENERIC(
            width : positive := width;
            mod_count : positive := level_range
            );
    PORT(
        clk : in std_logic;                                   --Clock
        clr_n : in std_logic;                                 --Clear (negado)
        ce : in std_logic;                                    --Chip Enable
        up : in std_logic;                                    --Count Up (o Down)
        load_n : in std_logic;                                --Carga datos
        data_in : in std_logic_vector(width-1 downto 0);     --Valor a cargar
        code : out std_logic_vector(width-1 downto 0);        --Valor a sacar
        ov : out std_logic
        );
    END COMPONENT;
    
    COMPONENT Comparator
    GENERIC(
            width : positive := width
            );
    PORT(
        in_a : in std_logic_vector(width-1 downto 0);   --Entrada 1
        in_b : in std_logic_vector(width-1 downto 0);   --Entrada 2
        aa : out std_logic;                             --Salida de A mayor
        ab : out std_logic;                             --Salida de Igual
        bb : out std_logic                              --Salida de B mayor
        );
    END COMPONENT;
    
    COMPONENT Prescaler
    GENERIC(
            reduction : positive := prescaler_reduction
            );
    PORT(
        clk_in : in std_logic;
        reset_n : in std_logic;
        clk_out : out std_logic
    );
    END COMPONENT;

begin
    
    Inst_prescaler: Prescaler PORT MAP(
        clk_in => clk,
        reset_n => reset_n,
        clk_out => prescaler_out
        );
    
    Inst_counter: Counter PORT MAP(
        clk => prescaler_out,
        clr_n => reset_n,
        ce => '1',
        up => '1',
        load_n => '1',
        data_in => (others => '0'),
        code => counter2comparator
        );
        
    Inst_comparator_red: Comparator PORT MAP(
        in_a => red_in,
        in_b => counter2comparator,
        aa => red_out
        );
        
     Inst_comparator_green: Comparator PORT MAP(
        in_a => green_in,
        in_b => counter2comparator,
        aa => green_out
        );
        
     Inst_comparator_blue: Comparator PORT MAP(
        in_a => blue_in,
        in_b => counter2comparator,
        aa => blue_out
        );

end behavioral;
