--------------- Input Peripheral Module 
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE work.aux_package.ALL;
-------------- ENTITY --------------------
ENTITY Input_Per IS
	GENERIC(DataBusSize	: integer := 32);
	PORT( 
		MemRead_i			: in	std_logic;
		Port_HEX_i			: in 	std_logic;
		switch_i			: in	std_logic_vector(7 DOWNTO 0);
		Device_to_DataBus_o	: out	std_logic_vector(DataBusSize-1 DOWNTO 0)
		);
END Input_Per;
------------ ARCHITECTURE ----------------
ARCHITECTURE behavior OF Input_Per IS

BEGIN	

	Device_to_DataBus_o		<= X"000000" & switch_i WHEN (MemRead_i AND Port_HEX_i) = '1' ELSE 
							  (OTHERS => 'Z');
	
END behavior;