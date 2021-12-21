library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std;
use ieee.std_logic_arith.ALL;


entity top_interface is
    PORT(  reset_n : in std_logic;                     --Reset (negado)
            clk: in std_logic;                          --Reloj
            button : in std_logic_vector(3 downto 0);   --Botones de selección
            -- Orden: arriba, abajo, izda, dcha
            rgb: out std_logic_vector(2 downto 0);      --LED RGB
            led : out std_logic_vector(5 downto 0);     --LEDs auxiliares de nivel
            digctrl : out std_logic_vector(7 downto 0); --Selector de display 7s
            segment : out std_logic_vector(6 downto 0)  --Display 7s (segmentos comunes)
    );
end top_interface;

architecture behavioral of top_interface is
   
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
   
    COMPONENT Prescaler
    GENERIC(
            reduction : positive := 100
            );
    PORT(
        clk_in : in std_logic;
        reset_n : in std_logic;
        clk_out : out std_logic
    );
    END COMPONENT;
    
    signal prescaler_out : std_logic;
    
begin
    
    
    Inst_prescaler: Prescaler PORT MAP(
        clk_in => clk,
        reset_n => reset_n,
        clk_out => prescaler_out
        );
    
    Inst_interface_module: INTERFACE_MODULE PORT MAP (
      clk => prescaler_out,
      reset_n => reset_n,
      red_in => "01111011",
      green_in => "11111111",
      blue_in => "11111111",
      color_select => button(2 downto 0),
      anode => digctrl,
      segment => segment
    );
    
end architecture;