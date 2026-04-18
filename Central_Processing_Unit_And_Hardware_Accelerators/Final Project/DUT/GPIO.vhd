LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE work.aux_package.ALL;
-------------- ENTITY --------------------
ENTITY GPIO IS
	GENERIC(
			DataBusSize	: integer := 32
			);
	PORT( 

		MEMRead_ctrl_i, MEMWrite_ctrl_i   		: in    std_logic;
		clk_i, rst_i                      		: in    std_logic;
		DataBus_io                        		: inout std_logic_vector(DataBusSize - 1 downto 0);
		switch_i                          		: in    std_logic_vector(7 downto 0);
		PORT_LED_i, PORT_SW_i					: in 	STD_LOGIC;
		PORT_HEX0_i, PORT_HEX1_i, PORT_HEX2_i	: in 	STD_LOGIC;
		PORT_HEX3_i, PORT_HEX4_i, PORT_HEX5_i	: in 	STD_LOGIC;
		HEX0_o, HEX1_o, HEX2_o                  : out	std_logic_vector(6 DOWNTO 0);
		HEX3_o, HEX4_o, HEX5_o				    : out	std_logic_vector(6 DOWNTO 0);
		LED_o                                   : out	std_logic_vector(7 DOWNTO 0) 
		
		);
END GPIO;
------------ ARCHITECTURE ----------------
ARCHITECTURE behavior OF GPIO IS
	---- CONTROL SIGNALS ----
	SIGNAL HEX_Output_w	: STD_LOGIC_VECTOR(6 DOWNTO 0);

BEGIN	
		
	LED_connect:	Output_Per
	GENERIC MAP(
				SevenSeg	  => FALSE,
				IOSize		  => 8
				)
	PORT MAP(			
			MemRead_ctrl_i	      => MEMRead_ctrl_i,		
			clk_i	              => clk_i,
			rst_i	              => rst_i,
			MemWrite_ctrl_i	      => MEMWrite_ctrl_i,
			Port_HEX_i	          => PORT_LED_i,
			DataBus_to_Device_io  => DataBus_io(7 downto 0),
			HEX_Output_o	      => LED_o
			);
	
	HEX0_7SEG:	Output_Per
	PORT MAP(	
			MemRead_ctrl_i	      => MEMRead_ctrl_i,		
			clk_i	              => clk_i,
			rst_i	              => rst_i,
			MemWrite_ctrl_i	      => MEMWrite_ctrl_i,
			Port_HEX_i	          => PORT_HEX0_i,
			DataBus_to_Device_io  => DataBus_io(7 downto 0),
			HEX_Output_o	      => HEX0_o
			);
			
	HEX1_7SEG:	Output_Per
	PORT MAP(
			MemRead_ctrl_i	      => MEMRead_ctrl_i,		
			clk_i	              => clk_i,
			rst_i	              => rst_i,
			MemWrite_ctrl_i	      => MEMWrite_ctrl_i,
			Port_HEX_i	          => PORT_HEX1_i,
			DataBus_to_Device_io  => DataBus_io(7 downto 0),
			HEX_Output_o	      => HEX1_o
			);
	
	HEX2_7SEG:	Output_Per
	PORT MAP(
			MemRead_ctrl_i	      => MEMRead_ctrl_i,		
			clk_i	              => clk_i,
			rst_i	              => rst_i,
			MemWrite_ctrl_i	      => MEMWrite_ctrl_i,
			Port_HEX_i	          => PORT_HEX2_i,
			DataBus_to_Device_io  => DataBus_io(7 downto 0),
			HEX_Output_o	      => HEX2_o
			);
	
	HEX3_7SEG:	Output_Per
	PORT MAP(
			MemRead_ctrl_i	      => MEMRead_ctrl_i,		
			clk_i	              => clk_i,
			rst_i	              => rst_i,
			MemWrite_ctrl_i	      => MEMWrite_ctrl_i,
			Port_HEX_i	          => PORT_HEX3_i,
			DataBus_to_Device_io  => DataBus_io(7 downto 0),
			HEX_Output_o	      => HEX3_o
			);
			
	HEX4_7SEG:	Output_Per
	PORT MAP(
			MemRead_ctrl_i	      => MEMRead_ctrl_i,		
			clk_i	              => clk_i,
			rst_i	              => rst_i,
			MemWrite_ctrl_i	      => MEMWrite_ctrl_i,
			Port_HEX_i	          => PORT_HEX4_i,
			DataBus_to_Device_io  => DataBus_io(7 downto 0),
			HEX_Output_o	      => HEX4_o
			);
			
	HEX5_7SEG:	Output_Per
	PORT MAP(
			MemRead_ctrl_i	      => MEMRead_ctrl_i,		
			clk_i	              => clk_i,
			rst_i	              => rst_i,
			MemWrite_ctrl_i	      => MEMWrite_ctrl_i,
			Port_HEX_i	          => PORT_HEX5_i,
			DataBus_to_Device_io  => DataBus_io(7 downto 0),
			HEX_Output_o	      => HEX5_o
			);
			
	switch_connect: Input_Per
	PORT MAP(
			MemRead_i	          => MEMRead_ctrl_i,
			Port_HEX_i	          => PORT_SW_i,
			switch_i	          => switch_i,
			Device_to_DataBus_o	  => DataBus_io
			);	
	
END behavior;