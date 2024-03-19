library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

entity ContadorFBRSLoad_tb is
end ContadorFBRSLoad_tb;

architecture Simulacion of ContadorFBRSLoad_tb is

	constant NOUTPUT: integer := 10;
	
	component ContadorFBRSLoad
	port(
		Clk : IN  std_logic;
		Reset : IN  std_logic;
		Load  : IN std_logic;		
		D  : IN UNSIGNED(NOUTPUT-1 downto 0);		
		Q : OUT UNSIGNED(NOUTPUT-1 downto 0)
	);
	end component;


	-- Entradas del componente a comprobar
	signal d : UNSIGNED(NOUTPUT-1 downto 0);
	signal clk : std_logic := '0';
	signal reset : std_logic := '0';
	signal load : std_logic := '0';

	-- Salidas del componente a comprobar
	signal q : UNSIGNED(NOUTPUT-1 downto 0);

	-- Constantes del testbench
	constant CLKPERIOD : time := 10 ns;
	constant ESPERA : time := 1 ns;


begin

	-- Instanciación del componente
	uut: ContadorFBRSLoad port map (
		Clk => clk,
		Reset => reset,
		Load => load,
		Q => q,
		D => d
	);

	-- Proceso que genera el reloj
	CLKPROCESS :process
	begin
		clk <= '0';
		wait for CLKPERIOD/2;
		clk <= '1';
		wait for CLKPERIOD/2;
	end process;

	-- Proceso de estímulos
	stim_proc: process
	begin
		-- Inicialización
		reset <= '1';

		wait until CLK = '0';
		wait for ESPERA;
		Assert q = 0
			report "Error de reset"
			severity failure;
			
		reset <= '0';
		
		Load <= '0';
		
		for i in 0 to 2**NOUTPUT-1 loop
			assert q = i
				report "Fallo en el caso  "  & to_string(i)
				severity failure;
			wait until clk = '0';
			wait for ESPERA;
		end loop;
		
		wait for ESPERA;
		assert q = 0 -- Debe seguir valiendo lo mismo que antes
			report "El registro se ha actualizado sin flanco"
			severity failure;
		
		Load <= '1';
		d <= to_unsigned(2**(NOUTPUT-1)-1,10); -- Un valor cualquiera
		wait until clk = '0';
		wait for ESPERA;
		assert q = D -- Debe seguir valiendo la entrada de carga
			report "Error en Load"
			severity failure;
			
		reset <= '1';
		wait for ESPERA;
		Assert q = D
			report "Error en reset (el reset es asíncrono)"
			severity failure;
				
					
		reset <= '0';
		Load <= '0';
		wait until clk = '1';
		wait for ESPERA;		
		Assert q = D
			report "Error en tipo de flanco"
			severity failure;
			
		report "Simulación correcta";
		wait;
	end process;

end Simulacion;
