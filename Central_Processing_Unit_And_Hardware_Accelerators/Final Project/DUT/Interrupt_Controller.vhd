	LIBRARY IEEE;
	USE IEEE.STD_LOGIC_1164.ALL;
	USE IEEE.STD_LOGIC_ARITH.ALL;
	USE IEEE.STD_LOGIC_UNSIGNED.ALL;
	USE work.aux_package.ALL;
	-------------- ENTITY --------------------
	ENTITY INTERRUPT_unit IS
		GENERIC(
		DataBusSize	: integer := 32;
		AddrBusSize : integer := 32
				);
		PORT( 
				rst_i			   : IN		STD_LOGIC;
				clk_i			   : IN		STD_LOGIC;
				MemRead_ctrl_i	   : IN		STD_LOGIC;
				MemWrite_ctrl_i	   : IN		STD_LOGIC;
				AddressBus_i	   : IN		STD_LOGIC_VECTOR(11 DOWNTO 0);
				DataBus_io		   : INOUT	STD_LOGIC_VECTOR(DataBusSize-1 DOWNTO 0);
				IntrSrc_i		   : IN		STD_LOGIC_VECTOR(7 DOWNTO 0); -- requests for interrupt
				INTA_i			   : IN		STD_LOGIC;
				GIE_i			   : IN		STD_LOGIC;			
				INTR_o			   : OUT	STD_LOGIC;
				IRQ_OUT_o		   : OUT    STD_LOGIC_VECTOR(7 DOWNTO 0);
				INTR_Active_o	   : OUT	STD_LOGIC;
				IRQ_CLEARED_OUT_o  : OUT	STD_LOGIC_VECTOR(7 DOWNTO 0);
				CLR_IRQ_r_o        : OUT    STD_LOGIC_VECTOR(7 DOWNTO 0)


			);
	END INTERRUPT_unit;
	------------ ARCHITECTURE ----------------
	ARCHITECTURE behavior OF INTERRUPT_unit IS
		SIGNAL IRQ_w			: STD_LOGIC_VECTOR(7 DOWNTO 0) := (others => '0');
		SIGNAL CLR_IRQ_w		: STD_LOGIC_VECTOR(7 DOWNTO 0) := (others => '1');		
		SIGNAL IntrEn_w			: STD_LOGIC_VECTOR(7 DOWNTO 0);
		SIGNAL IFG_w			: STD_LOGIC_VECTOR(7 DOWNTO 0);
		SIGNAL TypeReg_w		: STD_LOGIC_VECTOR(7 DOWNTO 0);
		SIGNAL INTA_Delayed_w   : STD_LOGIC;
		SIGNAL IntrSrc_6_7_or_w : STD_LOGIC;
		SIGNAL CLR_IRQ_r        : STD_LOGIC_VECTOR(7 DOWNTO 0)  := (others => '1');
		
	BEGIN
	--------------------------- IO MCU ---------------------------
	-- OUTPUT TO MCU -- 
	DataBus_io <=	X"000000" 	& TypeReg_w WHEN ((AddressBus_i = X"842" AND MemRead_ctrl_i = '1') OR (INTA_i = '0' AND MemRead_ctrl_i = '0')) ELSE
					X"000000"	& IFG_w		WHEN (AddressBus_i = X"841" AND MemRead_ctrl_i = '1') ELSE
					X"000000"	& IntrEn_w 	WHEN (AddressBus_i = X"840" AND MemRead_ctrl_i = '1') ELSE
					(OTHERS => 'Z');

	--INPUT FROM MCU -- 

	PROCESS(clk_i) 
	BEGIN
		IF (falling_edge(clk_i)) THEN
			IF (AddressBus_i = X"840" AND MemWrite_ctrl_i = '1') THEN
				IntrEn_w 	<=	DataBus_io(7 DOWNTO 0);
			END IF;		
		END IF;
	END PROCESS;

	IFG_w		<=	DataBus_io(7 DOWNTO 0)	WHEN (AddressBus_i = X"841" AND MemWrite_ctrl_i = '1') ELSE
					IRQ_w AND IntrEn_w;		

	-------------------------------------------------------------

	-- Find the INTR output
	PROCESS (clk_i, IFG_w) BEGIN 
		IF (rising_edge(clk_i)) THEN
			IF (IFG_w(0) = '1' OR IFG_w(1) = '1' OR
				IFG_w(2) = '1' OR IFG_w(3) = '1' OR
				IFG_w(4) = '1' OR IFG_w(5) = '1' OR
				IFG_w(6) = '1' ) THEN
					INTR_o <= GIE_i;
			ELSE 
					INTR_o <= '0';
			END IF;
		END IF;
	END PROCESS;

	------------ BTIMER ---------------
	PROCESS (clk_i, rst_i, CLR_IRQ_w(2), IntrSrc_i(2))
	BEGIN
		IF (rst_i = '0') THEN
			IRQ_w(2) <= '0';
		ELSIF CLR_IRQ_w(2) = '0' THEN
			IRQ_w(2) <= '0';
		ELSIF rising_edge(IntrSrc_i(2)) THEN
			IRQ_w(2) <= '1';
		END IF;
	END PROCESS;
	------------ KEY1 ---------------
	PROCESS (clk_i, rst_i, CLR_IRQ_w(3), IntrSrc_i(3))
	BEGIN
		IF (rst_i = '0') THEN
			IRQ_w(3) <= '0';
		ELSIF CLR_IRQ_w(3) = '0' THEN
			IRQ_w(3) <= '0';
		ELSIF rising_edge(IntrSrc_i(3)) THEN
			IRQ_w(3) <= '1';
		END IF;
	END PROCESS;
	------------ KEY2 ---------------
	PROCESS (clk_i, rst_i, CLR_IRQ_w(4), IntrSrc_i(4))
	BEGIN
		IF (rst_i = '0') THEN
			IRQ_w(4) <= '0';
		ELSIF CLR_IRQ_w(4) = '0' THEN
			IRQ_w(4) <= '0';
		ELSIF rising_edge(IntrSrc_i(4)) THEN
			IRQ_w(4) <= '1';
		END IF;
	END PROCESS;
	------------ KEY3 ---------------
	PROCESS (clk_i, rst_i, CLR_IRQ_w(5), IntrSrc_i(5))
	BEGIN
		IF (rst_i = '0') THEN
			IRQ_w(5) <= '0';
		ELSIF CLR_IRQ_w(5) = '0' THEN
			IRQ_w(5) <= '0';
		ELSIF rising_edge(IntrSrc_i(5)) THEN
			IRQ_w(5) <= '1';
		END IF;
	END PROCESS;
	------------ FIR - FIFO EMPTY/FIROUT---------------
	PROCESS (clk_i, rst_i, CLR_IRQ_w(6), IntrSrc_6_7_or_w)
	BEGIN
		IF (rst_i = '0') THEN
			IRQ_w(6) <= '0';
		ELSIF CLR_IRQ_w(6) = '0' THEN
			IRQ_w(6) <= '0';
		ELSIF rising_edge(IntrSrc_6_7_or_w) THEN
			IRQ_w(6) <= '1';
		END IF;
	END PROCESS;

	IntrSrc_6_7_or_w <= IntrSrc_i(6) OR IntrSrc_i(7);
	IRQ_OUT_o		 <= IRQ_w;
	---------------------------------------------

	PROCESS (clk_i) BEGIN
		IF (rst_i = '0') THEN
			INTA_Delayed_w <= '1';
		ELSIF (falling_edge(clk_i)) THEN
			INTA_Delayed_w <= INTA_i;
		END IF;
	END PROCESS;


	PROCESS (clk_i, rst_i, INTA_i, INTA_Delayed_w) BEGIN
		IF (rst_i = '0') THEN
			CLR_IRQ_r <= (others => '1');
		ELSIF (falling_edge(clk_i)) THEN
			CLR_IRQ_r <= (others => '1');
			if (INTA_i = '1' AND INTA_Delayed_w = '0') THEN
				     case TypeReg_w is
						when X"10" => CLR_IRQ_r(2) <= '0';
						when X"14" => CLR_IRQ_r(3) <= '0';
						when X"18" => CLR_IRQ_r(4) <= '0';
						when X"1C" => CLR_IRQ_r(5) <= '0';
						when X"20" => CLR_IRQ_r(6) <= '0';
						when X"24" => CLR_IRQ_r(6) <= '0';
						when others => null;
					end case;
			end if;
		end if;
	end process;

	CLR_IRQ_r_o <= CLR_IRQ_r;

	CLR_IRQ_w <= CLR_IRQ_r;

	IRQ_CLEARED_OUT_o <= CLR_IRQ_w;

	-- Determinate if interrupt is currently active
	INTR_Active_o	<= 	IFG_w(0) OR IFG_w(1) OR IFG_w(2) OR
						IFG_w(3) OR IFG_w(4) OR IFG_w(5) OR
						IFG_w(6) OR IFG_w(7);

	-- Interrupt Vectors
	TypeReg_w	<= 	X"00" WHEN rst_i  = '0' ELSE -- main
					--X"04" -- Uart Status Error
					--X"08" -- Uart RX
					--X"0C" -- Uart TX
					X"10" WHEN IFG_w(2) = '1' ELSE  -- Basic timer
					X"14" WHEN IFG_w(3) = '1' ELSE  -- KEY1
					X"18" WHEN IFG_w(4) = '1' ELSE	-- KEY2
					X"1C" WHEN IFG_w(5) = '1' ELSE	-- KEY3
					X"20" WHEN IFG_w(6) = '1' ELSE	-- FIFO EMPTY/FIROUT
					-- X"24" WHEN IFG_w(7) = '1' ELSE	-- POSSIBLE FOR FIROUT
				(OTHERS => 'Z');

	END behavior;