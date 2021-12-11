----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.12.2021 15:14:17
-- Design Name: 
-- Module Name: FSM_MODULE - Behavioral
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


entity FSM_MODULE is
generic(
    width : positive := 8
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
end FSM_MODULE;
------------------------------------------------------------------------------------------------------

architecture Behavioral of FSM_MODULE is

Signal DONE        : std_logic;
Signal REGIST_IN   : std_logic_vector(width-1 downto 0);
Signal START       : std_logic;
Signal REGIST_OUT  : std_logic_vector(width-1 downto 0);
Signal CHANGE      : std_logic_vector(1 downto 0);
 
 
component FSM_Master
generic(
    width : positive := 8
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
        Color_Select: out std_logic_vector(2 downto 0); --Color seleccionado 
-- r->(1 0 0), g->(0 1 0), b->(0 0 1) -> Importante, en formato ONE HOT (r,g,b)
       --Comunicacion con la maquina esclava
        DONE        : in std_logic;
        REGIST_IN   : in  std_logic_vector(width-1 downto 0);
        START       : out std_logic;
        REGIST_OUT  : out std_logic_vector(width-1 downto 0);
        CHANGE      : out std_logic_vector(1 downto 0) -- 01 decrementar, 10 aumentar
    );
end component;


component FSM_Slave
generic(
    width : positive := 8
 ); 
  Port ( 
        reset_n     : in  std_logic; --Reset Negado asincrono
        clk         : in  std_logic; --Reloj
        START       : in  std_logic; --Señal de inicio
        REGIST_IN   : in  std_logic_vector(width-1 downto 0); --Entrada de valor de registro a modificar
        CHANGE      : in  std_logic_vector(1 downto 0); -- 01 decrementar, 10 aumentar
        DONE        : out std_logic; --Señal de finalizacion del proceso
        REGIST_OUT  : out std_logic_vector(width-1 downto 0) --Salida del valor modificado  
  );
end component;


begin
 Inst_FSM_Master: FSM_Master PORT MAP(
        reset_n => reset_n,
        clk   => clk,
        button  => button,
        ROJO  => ROJO,
        VERDE   => VERDE,
        AZUL   => AZUL,
        Color_Select => Color_Select,

        DONE     => DONE,
        REGIST_IN  => REGIST_IN,
        START     => START,
        REGIST_OUT  => REGIST_OUT,
        CHANGE     => CHANGE
 );

 Inst_FSM_Slave: FSM_Slave PORT MAP(
        reset_n     => reset_n,
        clk        => clk,
        START      => START,
        REGIST_IN     => REGIST_OUT,
        CHANGE      => CHANGE,
        DONE       => DONE,
        REGIST_OUT    => REGIST_IN
  );
 
end Behavioral;

--------DUDAS---------------------------
--MAquina esclava archovo nuevo -------SIII
--Que tiene prioridad?? ---------------Vector pocho/Nos la suda
--Demasiadas S/E y demasiadas lineas---Solucionado
--Me falta la maq estados esclava -----Pues creala
--Linea 77: es como inicializar, yo he supuesto que si--Estabien
--Las signal estan bien declaradas, importan los nombres, esta bien comunicado??--Siii pq eres tonto
--Opinion de la documentacion , hace falta mas?? Mi respuesta es si --Mete mas 
--Salidas biendeclaradas esq soy una mierda ----------------- Ta bien
--
