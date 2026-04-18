--------------- Optimized Address Decoder Module 
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE work.aux_package.ALL;
-------------- ENTITY --------------------
ENTITY Address_Decoder IS
	PORT( 
		rst_i 									: in	STD_LOGIC;
		AddressBus_i							: in	STD_LOGIC_VECTOR(11 DOWNTO 0);
		PORT_LED_o, PORT_SW_o					: out 	STD_LOGIC;
		PORT_HEX0_o, PORT_HEX1_o, PORT_HEX2_o	: out 	STD_LOGIC;
		PORT_HEX3_o, PORT_HEX4_o, PORT_HEX5_o	: out 	STD_LOGIC
		);
		
END Address_Decoder;
------------ ARCHITECTURE ----------------
ARCHITECTURE behavior OF Address_Decoder IS

BEGIN

	PORT_LED_o	<=	'1' WHEN AddressBus_i = X"800" ELSE 
					'0' WHEN rst_i = '0'		   ELSE
					'0';
					
	PORT_HEX0_o	<=	'1' WHEN AddressBus_i = X"804" ELSE 
					'0' WHEN rst_i = '0'		   ELSE
					'0';
					
	PORT_HEX1_o	<=	'1' WHEN AddressBus_i = X"805" ELSE 
					'0' WHEN rst_i = '0'		   ELSE
					'0';
					
	PORT_HEX2_o	<=	'1' WHEN AddressBus_i = X"808" ELSE 
					'0' WHEN rst_i = '0'		   ELSE
					'0';
					
	PORT_HEX3_o	<=	'1' WHEN AddressBus_i = X"809" ELSE 
					'0' WHEN rst_i = '0'		   ELSE
					'0';
					
	PORT_HEX4_o	<=	'1' WHEN AddressBus_i = X"80C" ELSE 
					'0' WHEN rst_i = '0'		   ELSE
					'0';
					
	PORT_HEX5_o	<=	'1' WHEN AddressBus_i = X"80D" ELSE 
					'0' WHEN rst_i = '0'		   ELSE
					'0';
					
	PORT_SW_o	<=	'1' WHEN AddressBus_i = X"810" ELSE 
					'0' WHEN rst_i = '0'		   ELSE
					'0';	

END behavior;