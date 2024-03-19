-- Asignatura: Estructura de computadores
-- Fichero: Deco3a8Reg.vhd
-- Descripción: Decodificador 3 a 8 registrado
-- Fichero de Práctica: 1. Ejercicio: 2
----------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

entity Deco3a8Reg is
	port(
		D : IN  std_logic_vector(2 downto 0);
		Ce : IN  std_logic;
		Clk : IN  std_logic;
		Reset : IN  std_logic;
		Q : OUT  std_logic_vector(7 downto 0)
	);
end Deco3a8Reg;

architecture practica of Deco3a8Reg is

	-- Declaración del componente Deco3a8Reg

component Reg8b is
    port ( 
		D : in  std_logic_vector(7 downto 0);
		Reset : in  std_logic;
		Clk : in  std_logic;
		Ce : in  std_logic;
		Q : out  std_logic_vector(7 downto 0)
	);
end component;

component Deco3a8 is
    port ( 
		D : in  std_logic_vector (2 downto 0);
		Q : out  std_logic_vector (7 downto 0)
	);
end component;

	-- Declaración de señales auxiliares
 signal aux : std_logic_vector(7 downto 0) ; 	

begin

--Instanciacion componentes
DECO: Deco3a8 port map( D => D, Q => aux) ;
		
REG: Reg8b port map ( D => aux, Reset => Reset, Clk => Clk, Ce => Ce, Q => Q );

end Practica;	