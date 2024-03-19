library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

entity ExtCero_tb is
end ExtCero_tb;

architecture Simulacion of ExtCero_tb is

	constant NINPUT: integer := 8;
	constant NOUTPUT: integer := 12;
	
	component ExtCero
	port(
		A : IN  unsigned(NINPUT-1 downto 0);
		Q : OUT  unsigned(NOUTPUT-1 downto 0)
	);
	end component;


	-- Entradas del componente a comprobar
	signal A : unsigned(NINPUT-1 downto 0);
	-- Salidas del componente a comprobar
	signal q : unsigned(NOUTPUT-1 downto 0);

	-- Constantes del testbench
	constant ESPERA : time := 1 ns;


begin

	-- Instanciación del componente
	uut: ExtCero port map (
		A => A,
		Q => q
	);


	-- Proceso de estímulos
	stim_proc: process
	begin
		
		for i in 0 to 2**(NINPUT)-1 loop
			A <= to_unsigned(i,NINPUT);
			wait for ESPERA;
			assert q = i
				report "Fallo en el caso = "  & to_string(i)
				severity failure;
		end loop;
					
		report "Simulación correcta";
		wait;
	end process;

end Simulacion;
