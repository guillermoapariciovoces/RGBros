library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std;
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
         color_selected : in std_logic_vector(2 downto 0);      --Color seleccionado -> Importante, en formato ONE HOT (r,g,b)
         anode : out std_logic_vector (7 downto 0);             --Selección de ánodo en la placa -> Importante NO NEGADO
         segment : out std_logic_vector (6 downto 0)            --Control común de segmentos del display
    );
end INTERFACE_MODULE;

architecture behavioral of INTERFACE_MODULE is

    --Señales de temporización:
    signal prescaler_out : std_logic;
    signal ciclo_selection : std_logic_vector(2 downto 0);
    
    --Señales en formato nativo
    signal color_value : unsigned (width-1 downto 0);
        
    --Señales en formato BCD:
    signal BCD_output1 : std_logic_vector(3 downto 0);
    signal BCD_output2 : std_logic_vector(3 downto 0);
    signal BCD_output3 : std_logic_vector(3 downto 0);
    
    --Señales en formato 7-Segmentos
    signal letter_output : unsigned(6 downto 0);
    signal number_output1 : unsigned(6 downto 0);
    signal number_output2 : unsigned(6 downto 0);
    
    signal final_output : unsigned(6 downto 0);


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
            outputs : positive := 3
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
        input1 : in unsigned(width-1 downto 0);
        input2 : in unsigned(width-1 downto 0);
        input3 : in unsigned(width-1 downto 0);
        selector : in  std_logic_vector (inputs-1 downto 0);
        output: out unsigned(width-1 downto 0)
    );
    END COMPONENT;
    
    
    COMPONENT BCD_Decoder
    PORT(
        bin : in std_logic_vector (7 downto 0);
        bcd1 : out std_logic_vector (3 downto 0);
        bcd2 : out std_logic_vector (3 downto 0);
        bcd3 : out std_logic_vector (3 downto 0)
    );
    END COMPONENT;
    
    COMPONENT Letter_Decoder
    PORT(
        letter : in std_logic_vector(3 DOWNTO 0);   --Importante, en formato ONE HOT
        code : out unsigned(6 DOWNTO 0)
    );
    END COMPONENT;
    
    
    COMPONENT Segment_Decoder
    PORT(
        code_in : IN unsigned(3 DOWNTO 0);
        segment_code : OUT unsigned(6 DOWNTO 0)
    );
    END COMPONENT;

begin
    
    Inst_prescaler: Prescaler PORT MAP(
        clk_in => clk,
        reset_n => reset_n,
        clk_out => prescaler_out
        );
    
     Inst_ciclo: Ciclo PORT MAP(
        clk => clk,
        reset_n => reset_n,
        hots => ciclo_selection
        );
     
     Inst_mux_1: Mux_hot PORT MAP(
        input1 => red_in,
        input2 => green_in,
        input3 => blue_in,
        selector => color_selected,
        output => color_value
        );
        
     Inst_bcd_decoder: BCD_Decoder PORT MAP(
        bin => std_logic_vector(color_value),
        bcd1 => BCD_output1,
        bcd2 => BCD_output1,
        bcd3 => BCD_output1
        );
     
     Inst_letter_decoder: Letter_Decoder PORT MAP(
        letter => color_selected,
        code => letter_output
        );
        
     Inst_segment_decoder_1: Segment_Decoder PORT MAP(
        code_in => unsigned(BCD_output1),
        segment_code => number_output1
        );
        
     Inst_segment_decoder_2: Segment_Decoder PORT MAP(
        code_in => unsigned(BCD_output2),
        segment_code => number_output2
        );
        
     Inst_mux_2: Mux_hot PORT MAP(
        input1 => letter_output,
        input2 => number_output1,
        input3 => number_output2,
        selector => ciclo_selection,
        output => final_output
        );
        
        
        segment <= std_logic_vector(final_output);
        anode <= ciclo_selection;

end behavioral;
