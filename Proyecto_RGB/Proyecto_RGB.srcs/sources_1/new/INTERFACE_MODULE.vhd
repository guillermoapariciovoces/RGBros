library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.ALL;

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
         color_select : in std_logic_vector(2 downto 0);            --Color seleccionado -> Importante, en formato ONE HOT (r,g,b)
         -- r->(1 0 0), g->(0 1 0), b->(0 0 1)
         anode : out std_logic_vector (7 downto 0);             --Selección de ánodo en la placa -> Importante NEGADO
         segment : out std_logic_vector (6 downto 0)            --Control común de segmentos del display
    );
end INTERFACE_MODULE;


architecture behavioral of INTERFACE_MODULE is
    

    component Mux_3x8 is
        generic(
                inputs : positive := 3;
                width : positive := 8
                );
        port(
            input1 : in std_logic_vector (width-1 downto 0);
            input2 : in std_logic_vector (width-1 downto 0);
            input3 : in std_logic_vector (width-1 downto 0);
            selector : in std_logic_vector (inputs-1 downto 0);
            output: out std_logic_vector(width-1 downto 0)
    );
    end component;
    
    --Salida del Mux_1:
    signal color_value : std_logic_vector(width-1 downto 0);
    
    
    COMPONENT BCD_Decoder
    PORT(
        code_bin_in : in std_logic_vector (7 downto 0);
        code_bcd1_out : out std_logic_vector (3 downto 0);
        code_bcd2_out : out std_logic_vector (3 downto 0);
        code_bcd3_out : out std_logic_vector (3 downto 0)
    );
    END COMPONENT;
    
    --Salidas del decodificador BCD:
    signal bcd_output1 : std_logic_vector(3 downto 0);
    signal bcd_output2 : std_logic_vector(3 downto 0);
    signal bcd_output3 : std_logic_vector(3 downto 0);
    
    
    COMPONENT Letter_Decoder
    PORT(
        letter_hot_in : in std_logic_vector(2 downto 0);   --Importante, en formato ONE HOT
        leter_7s_out : out std_logic_vector(6 DOWNTO 0)
    );
    END COMPONENT;
    
    --Salida del decodificador de letras:
    signal letter_output : std_logic_vector(6 downto 0);
    
    
    COMPONENT Segment_Decoder
    PORT(
        code_bcd_in : in std_logic_vector(3 DOWNTO 0);
        code_7s_out : out std_logic_vector(6 DOWNTO 0)
    );
    END COMPONENT;

    --Salidas del decodificador a 7-Segmentos:
    signal number_output1 : std_logic_vector(6 downto 0);
    signal number_output2 : std_logic_vector(6 downto 0);
    signal number_output3 : std_logic_vector(6 downto 0);


    component Mux_8x7 is
        generic(
                inputs : positive := 8;
                width : positive := 7
                );
        port(
            input1 : in std_logic_vector (width-1 downto 0);
            input2 : in std_logic_vector (width-1 downto 0);
            input3 : in std_logic_vector (width-1 downto 0);
            input4 : in std_logic_vector (width-1 downto 0);
            input5 : in std_logic_vector (width-1 downto 0);
            input6 : in std_logic_vector (width-1 downto 0);
            input7 : in std_logic_vector (width-1 downto 0);
            input8 : in std_logic_vector (width-1 downto 0);
            selector : in std_logic_vector (inputs-1 downto 0);
            output: out std_logic_vector(width-1 downto 0)
            );
    end component;
    
    --Salida del Mux_2:
    signal final_output : std_logic_vector(6 downto 0);
    
    
    COMPONENT Prescaler
    GENERIC(
            reduction : positive := 400000
            );
    PORT(
        clk_in : in std_logic;
        reset_n : in std_logic;
        clk_out : out std_logic
    );
    END COMPONENT;
    
    --Reloj reducido en frecuencia:
    signal reduced_clk : std_logic;
    
    
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

    --Salida del ciclo
    signal ciclo_selection : std_logic_vector(7 downto 0);
    

begin
    
    
    Inst_mux_1: Mux_3x8 PORT MAP(
       input1 => red_in,
       input2 => green_in,
       input3 => blue_in,
       selector => color_select,
       output => color_value
       );
     
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
        
    Inst_mux_2: Mux_8x7 PORT MAP(
       input1 => letter_output,
       input2 => "1111111",
       input3 => "1111111",
       input4 => "1111111",
       input5 => "1111111",
       input6 => number_output1,
       input7 => number_output2,
       input8 => number_output3,
       selector => ciclo_selection,
       output => final_output
       );
     
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
    anode <= not(ciclo_selection);      --recordemos que los ánodos en la placa van negados y eso

end behavioral;
