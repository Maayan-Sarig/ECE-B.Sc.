--------------- MCU System Architecture Module 
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;
USE work.cond_comilation_package.all;
USE work.aux_package.all;



-------------- ENTITY --------------------
ENTITY MCU IS
	GENERIC(MemWidth	: INTEGER := 10;
			SIM 		: BOOLEAN := FALSE;
			CtrlBusSize	: integer := 8;
			AddrBusSize	: integer := 32;
			DataBusSize	: integer := 32;
			IrqSize		: integer := 6;
			RegSize		: integer := 8;
			WORD_GRANULARITY : boolean 	:= G_WORD_GRANULARITY;
	        MODELSIM : integer 			:= G_MODELSIM;
			DATA_BUS_WIDTH : integer 	:= 32;
			ITCM_ADDR_WIDTH : integer 	:= G_ADDRWIDTH;
			DTCM_ADDR_WIDTH : integer 	:= G_ADDRWIDTH;
			PC_WIDTH : integer 			:= 10;
			FUNCT_WIDTH : integer 		:= 6;
			DATA_WORDS_NUM : integer 	:= G_DATA_WORDS_NUM;
			CLK_CNT_WIDTH : integer 	:= 16;
			INST_CNT_WIDTH : integer 	:= 16
			);
	PORT( 
			rst_i, clk_i           							: in    std_logic;
			-- FIR_clk_i           							: in    std_logic;
			switch_i             							: in    std_logic_vector(7 DOWNTO 0);
			KEY1_i, KEY2_i, KEY3_i   						: in    std_logic;
			LED_o                 							: out   std_logic_vector(7 DOWNTO 0);
			HEX0_o, HEX1_o, HEX2_o, HEX3_o, HEX4_o, HEX5_o	: out	std_logic_vector(6 DOWNTO 0);
			PWM_out_o			             				: out   std_logic
			
			-- UART_RX				: IN 	STD_LOGIC := '1';
			-- UART_TX				: OUT	STD_LOGIC := '1'
		
		);
END MCU;
------------ ARCHITECTURE ----------------
ARCHITECTURE behavior OF MCU IS
	
	SIGNAL MCLK_w 			    : STD_LOGIC;

	-- MIPS
	
	signal  CLKCNT_w    		:  std_logic_vector(15 DOWNTO 0);
	signal  INSTCNT_w  		    :  std_logic_vector(15 DOWNTO 0);
	signal  IFpc_w    			:  std_logic_vector(9 DOWNTO 0);
	signal  IDpc_w    			:  std_logic_vector(9 DOWNTO 0);	
	signal  EXpc_w    			:  std_logic_vector(9 DOWNTO 0);
	signal  MEMpc_w    			:  std_logic_vector(9 DOWNTO 0);
	signal  WBpc_w    			:  std_logic_vector(9 DOWNTO 0);
	signal  IFinstruction_w     :  std_logic_vector(31 DOWNTO 0);
	signal  IDinstruction_w     :  std_logic_vector(31 DOWNTO 0);
	signal  EXinstruction_w     :  std_logic_vector(31 DOWNTO 0);
	signal  MEMinstruction_w    :  std_logic_vector(31 DOWNTO 0);	
	signal  WBinstruction_w     :  std_logic_vector(31 DOWNTO 0);	
	signal  FHCNT_w    			:  std_logic_vector(7 DOWNTO 0);
	signal  STCNT_w    			:  std_logic_vector(7 DOWNTO 0);	
	signal  STRIGGER_w          :  STD_LOGIC;
	signal  BPADDR_w            :  std_logic_vector(7 DOWNTO 0) := "00000000";	
	
	-- GPIO
	
	signal  DataBus_w     		:  std_logic_vector(31 DOWNTO 0) := X"00000000";
	signal  ControlBus_w     	:  std_logic_vector(7 DOWNTO 0);
	
	-- Address_Decoder
	
	signal  PORT_LED_w     		:  STD_LOGIC;
	signal  PORT_SW_w     		:  STD_LOGIC;
	signal  PORT_HEX0_w     	:  STD_LOGIC;
	signal  PORT_HEX1_w     	:  STD_LOGIC;
	signal  PORT_HEX2_w    		:  STD_LOGIC;
	signal  PORT_HEX3_w    		:  STD_LOGIC;
	signal  PORT_HEX4_w    		:  STD_LOGIC;
	signal  PORT_HEX5_w    		:  STD_LOGIC;
	signal  AddressBus_w        :  std_logic_vector(31 DOWNTO 0);         

	-- BASIC TIMER
	
	SIGNAL BTCTL_w				:  STD_LOGIC_VECTOR(CtrlBusSize-1 DOWNTO 0);
	SIGNAL BTCNT_w				:  STD_LOGIC_VECTOR(DataBusSize-1 DOWNTO 0);
	SIGNAL BTCCR0_w				:  STD_LOGIC_VECTOR(DataBusSize-1 DOWNTO 0);
	SIGNAL BTCCR1_w				:  STD_LOGIC_VECTOR(DataBusSize-1 DOWNTO 0);
	SIGNAL BTIFG_w				:  STD_LOGIC := '0';
	
	-- INTERRUPT MODULE

	SIGNAL	IntrSrc_w           :  STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL	INTA_w              :  STD_LOGIC;
	SIGNAL	MemRead_ctrl_w      :  STD_LOGIC;
	SIGNAL	MemWrite_ctrl_w	    :  STD_LOGIC;
	SIGNAL  CLR_IRQ_r_w         :  STD_LOGIC_VECTOR(7 DOWNTO 0); 
	
	-- SIGNAL	IFG_STATUS_ERROR_w  
	SIGNAL	GIE_w               :  STD_LOGIC;          
	SIGNAL	INTR_w              :  STD_LOGIC;       
	SIGNAL	IRQ_OUT_w           :  STD_LOGIC_VECTOR(7 DOWNTO 0); 
	SIGNAL	INTR_Active_w       :  STD_LOGIC; 
	SIGNAL	IRQ_FLAGS_OUT_w     :  STD_LOGIC_VECTOR(7 DOWNTO 0);  
 
	-- FIR
	
	SIGNAL FIRIN_w					:  STD_LOGIC_VECTOR(DataBusSize - 1 DOWNTO 0);
	SIGNAL FIRCTL_w					:  STD_LOGIC_VECTOR(CtrlBusSize - 1 DOWNTO 0);
	SIGNAL FIROUT_w					:  STD_LOGIC_VECTOR(DataBusSize - 1 DOWNTO 0);
	SIGNAL COEF3_0_w				:  STD_LOGIC_VECTOR(DataBusSize - 1 DOWNTO 0);
	SIGNAL COEF7_4_w				:  STD_LOGIC_VECTOR(DataBusSize - 1 DOWNTO 0);
	SIGNAL FIRIFG_w        			:  STD_LOGIC;    
	SIGNAL FIFOFULL_w        		:  STD_LOGIC; 
	SIGNAL FIFOEMPTY_w        		:  STD_LOGIC; 
	SIGNAL FIROUT_read_DataBus_ctrl :  STD_LOGIC;
	SIGNAL fir_clk                  :  STD_LOGIC := '1';
	SIGNAL modulo_fir_clk_w         :  STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
	SIGNAL MCLK_FIR                 :  STD_LOGIC := '0';
	SIGNAL modulo_FIRCLK_w          :  STD_LOGIC_VECTOR(8 downto 0):= X"00" & '0';
BEGIN	

	-------------------------- FPGA or ModelSim -----------------------
	-- resetSim 	<= reset WHEN SIM ELSE not reset;
	-- connect the PLL component
	G0:
	if (MODELSIM = 0) generate
	  MCLK: PLL
	   GENERIC MAP( DIV  => 3,
					freq => 20000)
		PORT MAP (
			inclk0 	=> clk_i,
			c0 		=> MCLK_w
		);
	else generate
		MCLK_w <= clk_i;
	end generate;
	
		-- G1:
	-- if (MODELSIM = 0) generate
	  -- MCLKFIR : PLL
		-- GENERIC MAP( DIV  => 5000,
					 -- freq => 20000)
		-- PORT MAP (
			-- inclk0 	=> clk_i,
			-- c0 		=> MCLK_FIR
		-- );
	-- end generate;
	
	process (clk_i, modulo_FIRCLK_w, MCLK_FIR)
		begin
		IF (rst_i = '0') then
			modulo_FIRCLK_w <= X"00" & '0';
			MCLK_FIR        <= '0';
		elsif rising_edge(clk_i) then 
			if(modulo_FIRCLK_w = X"FF" & '1') then
				MCLK_FIR <= not(MCLK_FIR);
			end if;
			modulo_FIRCLK_w <= modulo_FIRCLK_w + 1;
		end if;
	end process;
	CPU: MIPS
		GENERIC MAP(
			WORD_GRANULARITY		=> G_WORD_GRANULARITY,
	        MODELSIM		 		=> G_MODELSIM,
			DATA_BUS_WIDTH		 	=> 32,
			ITCM_ADDR_WIDTH		 	=> G_ADDRWIDTH,
			DTCM_ADDR_WIDTH		 	=> G_ADDRWIDTH,
			PC_WIDTH		 		=> 10,
			FUNCT_WIDTH		 		=> 6,
			DATA_WORDS_NUM		 	=> G_DATA_WORDS_NUM,
			CLK_CNT_WIDTH		 	=> 16,
			INST_CNT_WIDTH		 	=> 16
					)
		PORT MAP(
			rst_i		 		=> rst_i,
			clk_i		 		=> MCLK_w,
			BPADDR_i			=> BPADDR_w,
			INTR_i              => INTR_w,
			DataBus_io          => DataBus_w,
			CLKCNT_o		 	=> CLKCNT_w,
			INSTCNT_o		 	=> INSTCNT_w,
			IFpc_o		 		=> IFpc_w,
			IFinstruction_o		=> IFinstruction_w,
			IDpc_o		 		=> IDpc_w,
			IDinstruction_o		=> IDinstruction_w,
			EXpc_o		 		=> EXpc_w,
			EXinstruction_o		=> EXinstruction_w,
			MEMpc_o		 		=> MEMpc_w,
			MEMinstruction_o	=> MEMinstruction_w,
			WBpc_o		 		=> WBpc_w,
			WBinstruction_o		=> WBinstruction_w,
			STRIGGER_o          => STRIGGER_w,
			FHCNT_o		 		=> FHCNT_w,
			STCNT_o		 		=> STCNT_w,
			ControlBus_o		=> ControlBus_w,
			MemRead_ctrl_o		=> MemRead_ctrl_w,
			MemWrite_ctrl_o		=> MemWrite_ctrl_w,
			AddressBus_o		=> AddressBus_w,
			GIE_o				=> GIE_w,
			INTA_o				=> INTA_w
		);
			
	AD : 	Address_Decoder
		PORT MAP(	
				rst_i		    => rst_i,
				AddressBus_i	=> AddressBus_w(11 DOWNTO 0),
				PORT_LED_o		=> PORT_LED_w,
				PORT_SW_o		=> PORT_SW_w,
				PORT_HEX0_o		=> PORT_HEX0_w,
				PORT_HEX1_o		=> PORT_HEX1_w,
				PORT_HEX2_o		=> PORT_HEX2_w,
				PORT_HEX3_o		=> PORT_HEX3_w,
				PORT_HEX4_o		=> PORT_HEX4_w,
				PORT_HEX5_o		=> PORT_HEX5_w
				);
		
	
	IO_interface: GPIO
		PORT MAP(
				MEMRead_ctrl_i   => MemRead_ctrl_w,
				MEMWrite_ctrl_i  => MemWrite_ctrl_w,
				clk_i  			 => MCLK_w,
				rst_i  			 => rst_i,
				DataBus_io  	 => DataBus_w,
				switch_i  	  	 => switch_i,
				PORT_LED_i    	 => PORT_LED_w,
				PORT_SW_i     	 => PORT_SW_w,
				PORT_HEX0_i   	 => PORT_HEX0_w,
				PORT_HEX1_i   	 => PORT_HEX1_w,
				PORT_HEX2_i   	 => PORT_HEX2_w,
				PORT_HEX3_i   	 => PORT_HEX3_w,
				PORT_HEX4_i   	 => PORT_HEX4_w,
				PORT_HEX5_i   	 => PORT_HEX5_w,
				HEX0_o  	 	 => HEX0_o,
				HEX1_o  	  	 => HEX1_o,
				HEX2_o   	 	 => HEX2_o,         
				HEX3_o  	 	 => HEX3_o,
				HEX4_o  	  	 => HEX4_o,
				HEX5_o  	 	 => HEX5_o,
				LED_o    	 	 => LED_o
				);

	PROCESS(MCLK_w)
	BEGIN
		if (falling_edge(MCLK_w)) then
			if(AddressBus_w(11 DOWNTO 0) = X"81C" AND MemWrite_ctrl_w = '1') then
				BTCTL_w <= ControlBus_w;
			END IF;
			if(AddressBus_w(11 DOWNTO 0) = X"824" AND MemWrite_ctrl_w = '1') then
				BTCCR0_w <= DataBus_w;
			END IF;
			if(AddressBus_w(11 DOWNTO 0) = X"828" AND MemWrite_ctrl_w = '1') then
				BTCCR1_w <= DataBus_w;
			END IF;
			if(AddressBus_w(11 DOWNTO 0) = X"82C" AND MemWrite_ctrl_w = '1') then
				FIRCTL_w <= ControlBus_w;
			else
				FIRCTL_w(5) <= '0'; -- FIFOWEN turnoff after FIFO write cycle	
			END IF;			
			if(AddressBus_w(11 DOWNTO 0) = X"830" AND MemWrite_ctrl_w = '1') then
				FIRIN_w <= DataBus_w;
			END IF;		
			if(AddressBus_w(11 DOWNTO 0) = X"838" AND MemWrite_ctrl_w = '1') then
				COEF3_0_w <= DataBus_w;
			END IF;
			if(AddressBus_w(11 DOWNTO 0) = X"83C" AND MemWrite_ctrl_w = '1') then
				COEF7_4_w <= DataBus_w;
			END IF;			
		END IF;
	END PROCESS;
	
	
	----
	BTCNT_w		<= DataBus_w	WHEN (AddressBus_w(11 DOWNTO 0) = X"820" AND MemWrite_ctrl_w = '1') ELSE
				   (OTHERS => 'Z');	-- INPUT
	DataBus_w	<= BTCNT_w		WHEN (AddressBus_w(11 DOWNTO 0) = X"820" AND MemRead_ctrl_w = '1') ELSE
				   FIROUT_w		WHEN (AddressBus_w(11 DOWNTO 0) = X"834" AND MemRead_ctrl_w = '1') ELSE
				   (OTHERS => 'Z');  -- OUTPUT
	
	FIROUT_read_DataBus_ctrl <= '1' when (AddressBus_w(11 DOWNTO 0) = X"834" AND MemRead_ctrl_w = '1') ELSE
							    '0';
	
	DataBus_w   <= X"000000" & FIRCTL_w  WHEN (AddressBus_w(11 DOWNTO 0) = X"82C" AND MemRead_ctrl_w = '1') ELSE
				   X"000000" & BTCTL_w   WHEN (AddressBus_w(11 DOWNTO 0) = X"81C" AND MemRead_ctrl_w = '1') ELSE
				   (OTHERS => 'Z');  -- OUTPUT CONTROL 
	
	Timer_connect: Basic_Timer -- add btcnt_io
		PORT MAP(
		
			BTCCR0_i   => BTCCR0_w,
			BTCCR1_i   => BTCCR1_w,
			BTHOLD_i   => BTCTL_w(5),
			BTCLR_i    => BTCTL_w(2),
			MCLK_i     => MCLK_w,
			BTSSELX_i  => BTCTL_w(4 downto 3),
			BTIPx_i    => BTCTL_w(1 downto 0),
			BTOUTMD_i  => BTCTL_w(7),
			BTOUTEN_i  => BTCTL_w(6),
			BTIFG_o    => BTIFG_w,
			PWM_out_o  => PWM_out_o
		
		);

	IntrSrc_w	<= FIRIFG_w & FIFOEMPTY_w & (NOT KEY3_i) & (NOT KEY2_i) & (NOT KEY1_i) & BTIFG_w & "00"; 
	
	Intr_Controller: INTERRUPT_unit
		GENERIC MAP(
			DataBusSize	=> DataBusSize,
			AddrBusSize	=> AddrBusSize
		)
		PORT MAP(
			rst_i               => rst_i,
			clk_i               => MCLK_w,
			MemRead_ctrl_i      => MemRead_ctrl_w,
			MemWrite_ctrl_i     => MemWrite_ctrl_w,
			AddressBus_i        => AddressBus_w(11 downto 0),
			DataBus_io          => DataBus_w,
			IntrSrc_i           => IntrSrc_w,
			INTA_i              => INTA_w,
			-- IFG_STATUS_ERROR_i  => 
			GIE_i               => GIE_w,
			INTR_o              => INTR_w,
			IRQ_OUT_o           => IRQ_OUT_w,
			INTR_Active_o       => INTR_Active_w,
			IRQ_CLEARED_OUT_o   => IRQ_FLAGS_OUT_w,
			CLR_IRQ_r_o         => CLR_IRQ_r_w
		);
		
		
	FIR_connect: FIR
		PORT MAP(
			FIRIN_i      => FIRIN_w,
			FIFORST_i    => FIRCTL_w(4),
			FIFOCLK_i    => MCLK_w,
			FIFOWEN_i    => FIRCTL_w(5),
			FIRCLK_i     => MCLK_FIR,
			FIRRST_i     => FIRCTL_w(1),
			FIRENA_i     => FIRCTL_w(0),
			COEF0_i      => COEF3_0_w(7 downto 0),
			COEF1_i      => COEF3_0_w(15 downto 8),
			COEF2_i      => COEF3_0_w(23 downto 16),
			COEF3_i      => COEF3_0_w(31 downto 24),
			COEF4_i      => COEF7_4_w(7 downto 0),
			COEF5_i      => COEF7_4_w(15 downto 8),
			COEF6_i      => COEF7_4_w(23 downto 16),
			COEF7_i      => COEF7_4_w(31 downto 24),
			FIROUT_read_DataBus_ctrl_i => FIROUT_read_DataBus_ctrl,
			GIE_i        => GIE_w,
			CLR_IRQ_r_i  => CLR_IRQ_r_w,
			FIRIFG_o     => FIRIFG_w,
			FIFOFULL_o   => FIFOFULL_w,
			FIFOEMPTY_o  => FIFOEMPTY_w,
			FIROUT_o     => FIROUT_w
		);		
		
END behavior;