library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.ALL;

package Mux_hot_pkg is
        type std_logic_array is array(natural range <>) of std_logic_vector;
end package;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.ALL;
use work.Mux_hot_pkg.all;

entity INTERFACE_MODULE is
    generic(
            width : positive := 8       --Tamaño de palabra de los valores
    );
    port(
         clk : in std_logic;                                    --Clock
         reset_n : in std_logic;                                --Reset (negado)
         red_in : in std_logic_vector(width-1 downto 0);        --Entrada de componente rojo (byte)
         green_in : in std_logic_vector(width-1 downto 0);      --Entrada de componente verde (byte)
         blue_in : in std_logic_vector(width-1 downto 0);       --Entrada de componente azul (byte)
         color_select : in std_logic_vector(0 to 2);            --Color seleccionado -> Importante, en formato ONE HOT (r,g,b)
         -- r->(1 0 0), g->(0 1 0), b->(0 0 1)
         anode : out std_logic_vector (7 downto 0);             --Selección de ánodo en la placa -> Importante NO NEGADO
         segment : out std_logic_vector (6 downto 0)            --Control común de segmentos del display
    );
end INTERFACE_MODULE;


architecture behavioral of INTERFACE_MODULE is
    
    COMPONENT Prescaler
    GENERIC(
            reduction : positive := 100000
            );
    PORT(
        clk_in : in std_logic;
        reset_n : in std_logic;
        clk_out : out std_logic
    );
    END COMPONENT;
    
    
    COMPONENT Ciclo
    generic(
            outputs : positive := 8
            );
    port(
        clk : in std_logic;
        reset_n : in std_logic;
        hots : out std_logic_vector(outputs-1 downto 0)
    );
    END COMPONENT;
    
    
    COMPONENT Mux_hot
    generic(
            inputs : positive := 3;
            width : positive := 8
    );
    port(
        input : in std_logic_array(integer range inputs-1 downto 0)(width-1 downto 0);  --OJO, que puede no funcionar la el array
        --input2 : in unsigned(width-1 downto 0);
        --input3 : in unsigned(width-1 downto 0);
        selector : in std_logic_vector (inputs-1 downto 0);
        output: out std_logic_vector(width-1 downto 0)
    );
    END COMPONENT;
    
    
    COMPONENT BCD_Decoder
    PORT(
        code_bin_in : in std_logic_vector (7 downto 0);
        code_bcd1_out : out std_logic_vector (3 downto 0);
        code_bcd2_out : out std_logic_vector (3 downto 0);
        code_bcd3_out : out std_logic_vector (3 downto 0)
    );
    END COMPONENT;
    
    COMPONENT Letter_Decoder
    PORT(
        letter_hot_in : in std_logic_vector(0 to 2);   --Importante, en formato ONE HOT
        leter_7s_out : out std_logic_vector(6 DOWNTO 0)
    );
    END COMPONENT;
    
    
    COMPONENT Segment_Decoder
    PORT(
        code_bcd_in : in std_logic_vector(3 DOWNTO 0);
        code_7s_out : out std_logic_vector(6 DOWNTO 0)
    );
    END COMPONENT;

   
    --Formateado a array de la entrada para Mux_1
    signal mux1_in : std_logic_array(2 downto 0);
    
    --Señales en formato nativo
    signal color_value : std_logic_vector(width-1 downto 0);
        
    --Señales en formato BCD:
    signal bcd_output1 : std_logic_vector(3 downto 0);
    signal bcd_output2 : std_logic_vector(3 downto 0);
    signal bcd_output3 : std_logic_vector(3 downto 0);
    
    --Señales en formato 7-Segmentos
    signal letter_output : std_logic_vector(6 downto 0);
    signal number_output1 : std_logic_vector(6 downto 0);
    signal number_output2 : std_logic_vector(6 downto 0);
    signal number_output3 : std_logic_vector(6 downto 0);
    
    --Formateado a array de la entrada para Mux_2
    signal mux2_in : std_logic_array(7 downto 0);
    
    --Salida definitiva al display
    signal final_output : std_logic_vector(6 downto 0);
    
    --Señales de temporización:
    signal reduced_clk : std_logic;
    signal ciclo_selection : std_logic_vector(7 downto 0);
    

begin
    
    -- Mux de entrada desde FSM_MODULE
    mux1_in(0) <= red_in;
    mux1_in(1) <= green_in;
    mux1_in(2) <= blue_in;
     
    Inst_mux_1: Mux_hot PORT MAP(
       input => mux1_in,
       selector => color_select,
       output => color_value
       );
     
    -- Decodificado de las señales a 7 segmentos
    Inst_bcd_decoder: BCD_Decoder PORT MAP(
       code_bin_in => color_value,
       code_bcd1_out => BCD_output1,
       code_bcd2_out => BCD_output2,
       code_bcd3_out => BCD_output3
       );
    
    Inst_segment_decoder_1: Segment_Decoder PORT MAP(
       code_bcd_in => bcd_output1,
       code_7s_out => number_output1
       );
        
    Inst_segment_decoder_2: Segment_Decoder PORT MAP(
       code_bcd_in => bcd_output2,
       code_7s_out => number_output2
       );
        
    Inst_segment_decoder_3: Segment_Decoder PORT MAP(
       code_bcd_in => bcd_output2,
       code_7s_out => number_output3
       );
     
    Inst_letter_decoder: Letter_Decoder PORT MAP(
       letter_hot_in => color_select,
       leter_7s_out => letter_output
       );
    
    -- Mux de salida a los displays
    mux2_in(0) <= letter_output;
    mux2_in(1) <= "11111111";
    mux2_in(2) <= "11111111";
    mux2_in(3) <= "11111111";
    mux2_in(4) <= "11111111";
    mux2_in(5) <= number_output1;
    mux2_in(6) <= number_output2;
    mux2_in(7) <= number_output3;
        
    Inst_mux_2: Mux_hot PORT MAP(
       input => mux2_in,
       selector => ciclo_selection,
       output => final_output
       );
     
    -- Selección dinámica en one-hot para el display
    Inst_prescaler: Prescaler PORT MAP(
       clk_in => clk,
       reset_n => reset_n,
       clk_out => reduced_clk
       );
    
    Inst_ciclo: Ciclo PORT MAP(
       clk => reduced_clk,
       reset_n => reset_n,
       hots => ciclo_selection
       );
        
    segment <= final_output;
    anode <= ciclo_selection;

end behavioral;
