----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.12.2021 14:16:58
-- Design Name: 
-- Module Name: FSM_MODULE_2_0 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FSM_MODULE_2_0 is
generic(
    width : positive := 8;
    mod_count : positive := 101
        );
port (
        reset_n     : in std_logic; --Reset Negado asincrono
        clk         : in std_logic; --Reloj
        button      : in std_logic_vector(3 downto 0);  --Botones de selección 
   -- Orden: arriba (aumentar valor), abajo (decrementar valor), izda(B->G->R), dcha(R->G->B)
   -- Suponemos 3                      2                            1            0
        ROJO        : out std_logic_vector(width-1 downto 0); --Salida valor de Rojo (R)
        VERDE       : out std_logic_vector(width-1 downto 0); --Salida valor de Verde (G)
        AZUL        : out std_logic_vector(width-1 downto 0); --Salida valor de Azul (B)
        Color_Select: out std_logic_vector(2 downto 0)--Color actual en seleccion (R, G, B)
        
    );
end FSM_MODULE_2_0;

architecture Behavioral of FSM_MODULE_2_0 is

Signal rojo_signal       : std_logic_vector(1 downto 0);
Signal verde_signal       : std_logic_vector(1 downto 0);
Signal azul_signal        : std_logic_vector(1 downto 0);
    COMPONENT Counter
    GENERIC(
            width : positive := width;
            mod_count : positive := mod_count
            );
    PORT(
        clk : in std_logic;                           --Clock
        clr_n : in std_logic;                         --Clear (negado)
        ce : in std_logic;                            --Chip Enable
        up : in std_logic;                            --Count Up (o Down)
        load_n : in std_logic;                        --Carga datos
        data_in : in std_logic_vector(width-1 downto 0);     --Valor a cargar
        code : out std_logic_vector(width-1 downto 0);        --Valor a sacar
        ov : out std_logic                            --Indicador de Overflow
        );
    END COMPONENT;
    COMPONENT FSM_MASTER_2_0 is
     port (
        reset_n     : in std_logic; --Reset Negado asincrono
        clk         : in std_logic; --Reloj
        button      : in std_logic_vector(3 downto 0);  --Botones de selección 
   -- Orden: arriba (aumentar valor), abajo (decrementar valor), izda(B->G->R), dcha(R->G->B)
   -- Suponemos 3                      2                            1            0
   --Prioridad => mas prioridad 3 2 1 0 menos prioridad
        Color_Select: out std_logic_vector(2 downto 0); --Color seleccionado PROVISIONAL
-- r->(1 0 0), g->(0 1 0), b->(0 0 1) -> Importante, en formato ONE HOT (r,g,b)

        --Comunicacion con contadores
        -- Primer bit es chip enable, segundo el up
        RED      : out std_logic_vector(1 downto 0);
        GREEN    : out std_logic_vector(1 downto 0);
        BLUE     : out std_logic_vector(1 downto 0)
        );
end component;


begin
Inst_counter_RED: Counter PORT MAP(
        clk => clk,
        clr_n => reset_n,
        ce => rojo_signal(1),
        up => rojo_signal(0),
        load_n => '1',
        data_in =>(others => '0'),
        code => ROJO
        );      
Inst_counter_GREEN: Counter PORT MAP(
        clk => clk,
        clr_n => reset_n,
        ce => VERDE_signal(1),
        up => VERDE_signal(0),
        load_n => '1',
        data_in => (others => '0'),
        code => VERDE
        );      
Inst_counter_BLUE: Counter PORT MAP(
        clk => clk,
        clr_n => reset_n,
        ce => AZUL_signal(1),
        up => AZUL_signal(0),
        load_n => '1',
        data_in => (others => '0'),
        code => AZUL
        );      
Inst_FSM_Master: FSM_Master_2_0 PORT MAP(
        reset_n => reset_n,
        clk   => clk,
        button  => button,
        Color_Select => Color_Select,
        RED  => rojo_signal,
        GREEN   => VERDE_signal,
        BLUE   => AZUL_signal



 );

end Behavioral;
