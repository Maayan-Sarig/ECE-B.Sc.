---------------------------------------------------------------------------------------------
-- Copyright 2025 Hananya Ribo 
-- Advanced CPU architecture and Hardware Accelerators Lab 361-1-4693 BGU
---------------------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE work.cond_comilation_package.all;
USE work.aux_package.all;

ENTITY MCU_tb IS
	generic( 
			MemWidth	: INTEGER := 10;
			SIM 		: BOOLEAN := FALSE;
			CtrlBusSize	: integer := 8;
			AddrBusSize	: integer := 32;
			DataBusSize	: integer := 32;
			IrqSize		: integer := 6;
			RegSize		: integer := 8
	);
END MCU_tb;


ARCHITECTURE struct OF MCU_tb IS
   -- Internal signal declarations
  		SIGNAL	rst_w		: std_logic;
		SIGNAL	clk_w		: std_logic;
		SIGNAL	clk_fir_w	: std_logic;
		SIGNAL	switch_w 	: std_logic_vector(7 downto 0) := X"02";
		SIGNAL	KEY1_w  	: std_logic := '1';
		SIGNAL	KEY2_w		: std_logic := '1';
		SIGNAL	KEY3_w 		: std_logic := '1';
		SIGNAL	LED_w		: std_logic_vector(7 downto 0);
		SIGNAL	HEX0_w		: std_logic_vector(6 downto 0);
		SIGNAL	HEX1_w		: std_logic_vector(6 downto 0);
		SIGNAL	HEX2_w		: std_logic_vector(6 downto 0);
		SIGNAL	HEX3_w 		: std_logic_vector(6 downto 0);
		SIGNAL	HEX4_w		: std_logic_vector(6 downto 0);
		SIGNAL	HEX5_w		: std_logic_vector(6 downto 0);
		SIGNAL	PWM_out_w	: std_logic;

BEGIN
	CORE : MCU
	generic map(
			MemWidth      => MemWidth,
			SIM           => SIM,
			CtrlBusSize   => CtrlBusSize,
			AddrBusSize   => AddrBusSize,
			DataBusSize   => DataBusSize,
			IrqSize       => IrqSize,
			RegSize       => RegSize
	)
	PORT MAP (
			rst_i       => rst_w,
			clk_i       => clk_w,
			-- FIR_clk_i   => clk_fir_w,
			switch_i    => switch_w,
			KEY1_i      => KEY1_w,
			KEY2_i      => KEY2_w,
			KEY3_i      => KEY3_w,
			LED_o       => LED_w,
			HEX0_o      => HEX0_w,
			HEX1_o      => HEX1_w,
			HEX2_o      => HEX2_w,
			HEX3_o      => HEX3_w,
			HEX4_o      => HEX4_w,
			HEX5_o      => HEX5_w,
			PWM_out_o   => PWM_out_w
	);


----------------------------------------
	gen_clk : process
    begin
		clk_w <= '1';
		wait for 50 ns;
		clk_w <= '0';
		wait for 50 ns;
    end process;

	gen_rst : process
    begin
		rst_w <= '0';
		wait for 80 ns;
		rst_w <= '1';
		wait;
    end process;


	gen_clk2 : process
    begin
		clk_fir_w <= '1';
		wait for 50 us;
		clk_fir_w <= '0';
		wait for 50 us;
    end process;

	-- gen_check : process
    -- begin
		-- wait for 2 us;
		
        -- KEY1_w <= '0';
        -- wait for 2 us;

		-- KEY1_w <= '1';
        -- wait for 2 us;
		
		-- KEY2_w <= '0';
        -- wait for 2 us;

		-- KEY2_w <= '1';
        -- wait for 2 us;
		
		-- KEY3_w <= '0';
        -- wait for 2 us;

		-- KEY3_w <= '1';
        -- wait for 2 us;

        -- wait;
    -- end process;

--------------------------------------------------------------------
END struct;
