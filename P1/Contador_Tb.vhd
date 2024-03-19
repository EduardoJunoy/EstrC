----------------------------------------------------------------------
-- Asignatura: Fundamentos de Microprocesadores. Grado ITST. 2º curso.
-- Fichero: Contador_Tb.vhd
-- Descripción: Testbench del contador de 8 bits con habilitador y sentido de cuenta
-- Fichero de apoyo para: Práctica: 1. Ejercicio: 3
----------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

entity Contador_Tb is
end Contador_Tb;

-- Contador de 8 bits


architecture simulador of Contador_Tb is

-- declaracion del componente a simular
component Contador is
    Port (
		Clk : in  STD_LOGIC;
		Reset : in  STD_LOGIC;
		Ce : in  STD_LOGIC;
		Up : in  STD_LOGIC;
		Q : out  UNSIGNED (7 downto 0)
	);
end component;

-- señales auxiliares
signal clk, reset, ce, up : std_logic;
signal cuenta : unsigned(7 downto 0);
constant periodo : time  := 10 ns;
signal simulation : std_logic := '1';

begin
-- instanciacion del componete a simular
uut: Contador port map (CLk => clk, Reset => reset, Ce => ce, Up => up, Q => cuenta) ;


-- proceso del reloj
process
begin
	while simulation = '1' loop
		clk <= '0';
		wait for periodo/2;
		clk <= '1';
		wait for periodo/2;
	end loop;	
end process;

-- proceso de estímulos
process 
begin
-- simula el reset
	reset <= '1';
	ce <= '0';
	up <= '1';	
	wait for periodo ;
	assert cuenta = 0 
		report "Error en el reset"
			severity failure;

-- Con reset = '0', simula el habilitador Ce = '0'reset
	reset <= '0';
	wait for periodo ;
	assert cuenta = 0 
		report "Error en el habilitador de cuenta"
			severity failure;

-- simula la cuenta ascendente
	ce <= '1';
	wait for periodo ;
	for i in 1 to 260 loop
	assert cuenta = to_unsigned((i mod 256),8) 
		report "Error en la cuenta ascendente en el valor: " & to_string(i) 
			severity warning;
	wait for periodo;
	end loop;

-- Resetea y simula la cuenta descendente
	up <= '0';	
	wait for periodo ;
	for i in 260 downto 0 loop
	assert cuenta = to_unsigned((i mod 256),8) 
		report "Error en la cuenta descendente en el valor: " & to_string(i) 
			severity warning;
	wait for periodo;
	end loop;

simulation <= '0' ;
wait for periodo;
report "SIMULACION COMPLETADA. COMPRUEBE Y CORRIJA LOS ERRORES ENCONTRADOS";


end process;

end simulador;

