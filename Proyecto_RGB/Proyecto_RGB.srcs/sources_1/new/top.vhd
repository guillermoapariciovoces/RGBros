library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std;
use ieee.std_logic_arith.ALL;


entity top is
    PORT(  reset_n : in std_logic;                     --Reset (negado)
            clk: in std_logic;                          --Reloj
            button : in std_logic_vector(3 downto 0);   --Botones de selección
            -- Orden: arriba, abajo, izda, dcha
            rgb: out std_logic_vector(2 downto 0);      --LED RGB
            led : out std_logic_vector(5 downto 0);     --LEDs auxiliares de nivel
            digctrl : out std_logic_vector(7 downto 0); --Selector de display 7s
            segment : out std_logic_vector(6 downto 0)  --Display 7s (segmentos comunes)
    );
end top;

architecture behavioral of top is
    signal sync2edge: std_logic_vector(3 downto 0);           --Señal que sale del sincronizador al detector de flancos
    signal edge2fsm: std_logic_vector(3 downto 0);            --Señal del detector de flancos a la máquina de estados

    COMPONENT INPUT_MODULE
        generic(
            inputs : positive := 4
            );
        port(
            clk : in std_logic;                                    --Clock
            button_in: in std_logic_vector(inputs-1 downto 0);
            button_out: out std_logic_vector(inputs-1 downto 0)
            );
    END COMPONENT;
    
    COMPONENT FSM_MODULE_2_0
        generic(
                width : positive := 8
                );
        port(
             reset_n     : in std_logic; --Reset Negado asincrono
             clk         : in std_logic; --Reloj
             button      : in std_logic_vector(3 downto 0);  --Botones de selección 
             -- Orden: arriba (aumentar valor), abajo (decrementar valor), izda(B->G->R), dcha(R->G->B)
             -- Suponemos 3                      2                            1            0
             ROJO        : out std_logic_vector(width-1 downto 0); --Salida valor de Rojo (R)
             VERDE       : out std_logic_vector(width-1 downto 0); --Salida valor de Verde (G)
             AZUL        : out std_logic_vector(width-1 downto 0); --Salida valor de Azul (B)
             Color_Select: out std_logic_vector(2 downto 0)  --Color actual en seleccion (R, G, B)
             );
    END COMPONENT;
    
    COMPONENT OUTPUT_MODULE
        generic(
            width : positive := 8;                      -- Tamaño de las variables
            level_range : positive := 50;               -- Nº de niveles RGB posible
            prescaler_reduction : positive := 100000    -- Reducción de la temporización para los 7-segmentos
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
    END COMPONENT;
    
    COMPONENT INTERFACE_MODULE
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
            anode : out std_logic_vector (7 downto 0);             --Selección de ánodo en la placa -> Importante NO NEGADO
            segment : out std_logic_vector (6 downto 0)            --Control común de segmentos del display
            );
    END COMPONENT;
    
    signal button2fsm : std_logic_vector(3 downto 0);
    
    signal red_info : std_logic_vector(7 downto 0);
    signal green_info : std_logic_vector(7 downto 0);
    signal blue_info : std_logic_vector(7 downto 0);
    signal color_info : std_logic_vector(0 to 2);
    
    signal red2output : std_logic;
    signal green2output : std_logic;
    signal blue2output : std_logic;
    
begin
    Inst_input_module: INPUT_MODULE PORT MAP(
        clk => clk,
        button_in => button,
        button_out => button2fsm
    );

    Inst_fsm_module: FSM_MODULE_2_0 PORT MAP(
        reset_n => reset_n,
        clk => clk,
        button => button2fsm,
        ROJO => red_info,
        VERDE => green_info,
        AZUL => blue_info,
        Color_Select => color_info
    );

    Inst_output_module: OUTPUT_MODULE PORT MAP (
       clk => clk,
       reset_n => reset_n,
       red_in => red_info,
       green_in => green_info,
       blue_in => blue_info,
       red_out => red2output,
       green_out => green2output,
       blue_out => blue2output
    );
    
    Inst_interface_module: INTERFACE_MODULE PORT MAP (
       clk => clk,
       reset_n => reset_n,
       red_in => red_info,
       green_in => green_info,
       blue_in => blue_info,
      color_select => color_info,
      anode => digctrl,
      segment => segment
    );
    
    led(5 downto 3) <= color_info;
    
    rgb(0) <=  red2output;
    rgb(1) <=  green2output;
    rgb(2) <=  blue2output;
    led(2) <=  red2output;
    led(1) <=  green2output;
    led(0) <=  blue2output;
end behavioral;