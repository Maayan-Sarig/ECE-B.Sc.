LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE work.aux_package.ALL;
-------------- ENTITY --------------------
ENTITY Output_Per IS
	GENERIC (SevenSeg	: boolean := TRUE;
			 IOSize		: integer := 7); -- 7 WHEN HEX, 8 WHEN LEDs
	PORT( 
		MemRead_ctrl_i			: in	std_logic;
		clk_i					: in 	std_logic;
		rst_i					: in 	std_logic;
		MemWrite_ctrl_i			: in	std_logic;
		Port_HEX_i				: in 	std_logic;
		DataBus_to_Device_io	: inout	std_logic_vector(7 DOWNTO 0);
		HEX_Output_o			: out	std_logic_vector(IOSize - 1 DOWNTO 0)
		);
END Output_Per;
------------ ARCHITECTURE ----------------
ARCHITECTURE behavior OF Output_Per IS
	SIGNAL D_Latch_w	: std_logic_vector(7 DOWNTO 0);
BEGIN
	
	PROCESS(clk_i)
	BEGIN
	IF (rst_i = '0') THEN
		D_Latch_w	<= X"00";
	ELSIF (falling_edge(clk_i)) THEN
		IF (MemWrite_ctrl_i = '1' AND Port_HEX_i = '1') THEN
			D_Latch_w <= DataBus_to_Device_io;
		END IF;
	END IF;
	END PROCESS;
	
	---------------------------------------
	
	DataBus_to_Device_io	<=	D_Latch_w WHEN (MemRead_ctrl_i = '1' AND Port_HEX_i = '1') 	ELSE 
								(others => 'Z'); 
	
	SEG: 
		IF (SevenSeg = TRUE) GENERATE
		HEX_Output_o <= "1000000" when D_Latch_w(3 downto 0) = "0000" else -- 0
						"1111001" when D_Latch_w(3 downto 0) = "0001" else -- 1
						"0100100" when D_Latch_w(3 downto 0) = "0010" else -- 2
						"0110000" when D_Latch_w(3 downto 0) = "0011" else -- 3
						"0011001" when D_Latch_w(3 downto 0) = "0100" else -- 4
						"0010010" when D_Latch_w(3 downto 0) = "0101" else -- 5
						"0000010" when D_Latch_w(3 downto 0) = "0110" else -- 6
						"1111000" when D_Latch_w(3 downto 0) = "0111" else -- 7 
						"0000000" when D_Latch_w(3 downto 0) = "1000" else -- 8 
						"0010000" when D_Latch_w(3 downto 0) = "1001" else -- 9
						"0001000" when D_Latch_w(3 downto 0) = "1010" else -- A
						"0000011" when D_Latch_w(3 downto 0) = "1011" else -- B
						"1000110" when D_Latch_w(3 downto 0) = "1100" else -- C
						"0100001" when D_Latch_w(3 downto 0) = "1101" else -- D
						"0000110" when D_Latch_w(3 downto 0) = "1110" else -- E
						"0001110" when D_Latch_w(3 downto 0) = "1111" else -- F
						"1111111"; 										   -- None
		END GENERATE SEG;
	
	NO_SEG:
		IF (SevenSeg = FALSE) GENERATE
			HEX_Output_o <= D_Latch_w;
		END GENERATE NO_SEG;
	
END behavior;

