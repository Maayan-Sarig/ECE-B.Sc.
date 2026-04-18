---------------------------------------------------------------------------------------------
-- Copyright 2025 Hananya Ribo 
-- Advanced CPU architecture and Hardware Accelerators Lab 361-1-4693 BGU
---------------------------------------------------------------------------------------------
library IEEE;
use ieee.std_logic_1164.all;
USE work.cond_comilation_package.all;


package aux_package is

	component MIPS is
		generic( 
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
	PORT(	rst_i		 		: IN	STD_LOGIC;
			clk_i				: IN	STD_LOGIC; 
			BPADDR_i			: IN	STD_LOGIC_VECTOR(7 DOWNTO 0); 
			INTR_i				: IN	STD_LOGIC;
			--INTR_Active_i		: IN	STD_LOGIC;
			--CLR_IRQ_i			: IN	STD_LOGIC_VECTOR(5 DOWNTO 0);
			DataBus_io          : INOUT STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
			-- Output important signals to pins for easy display in SignalTap
			
			CLKCNT_o			: OUT   STD_LOGIC_VECTOR(CLK_CNT_WIDTH-1 DOWNTO 0);
			INSTCNT_o 			: OUT   STD_LOGIC_VECTOR(INST_CNT_WIDTH-1 DOWNTO 0);
			IFpc_o				: OUT   STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
			IFinstruction_o     : OUT   STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
			IDpc_o				: OUT   STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
			IDinstruction_o     : OUT   STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
			EXpc_o				: OUT   STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
			EXinstruction_o     : OUT   STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
			MEMpc_o				: OUT   STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
			MEMinstruction_o    : OUT   STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
			WBpc_o				: OUT   STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
			WBinstruction_o     : OUT   STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
			STRIGGER_o          : OUT   STD_LOGIC;
			FHCNT_o             : OUT   STD_LOGIC_VECTOR(7 DOWNTO 0);
			STCNT_o             : OUT   STD_LOGIC_VECTOR(7 DOWNTO 0);
			ControlBus_o		: OUT	STD_LOGIC_VECTOR(7 DOWNTO 0);
			MemRead_ctrl_o		: OUT 	STD_LOGIC;
			MemWrite_ctrl_o		: OUT 	STD_LOGIC;
			AddressBus_o		: OUT	STD_LOGIC_VECTOR(31 DOWNTO 0);
			GIE_o				: OUT	STD_LOGIC;
			INTA_o				: OUT	STD_LOGIC
		);		
	end component;
---------------------------------------------------------  
	component control is
		PORT( 	
			opcode_i, func_i 	: IN 	STD_LOGIC_VECTOR(5 DOWNTO 0);
			INTR_i				: IN 	STD_LOGIC;
			Read_ISR_ctrl_PC_i  : IN    STD_LOGIC; 
			HOLD_PC_ctrl_i      : IN    STD_LOGIC; 
			RegDst_ctrl_o 		: OUT 	STD_LOGIC_VECTOR(1 downto 0);
			ALUSrc_ctrl_o 		: OUT 	STD_LOGIC;
			MemtoReg_ctrl_o 	: OUT 	STD_LOGIC;
			RegWrite_ctrl_o 	: OUT 	STD_LOGIC;
			MemRead_ctrl_o 		: OUT 	STD_LOGIC;
			MemWrite_ctrl_o	 	: OUT 	STD_LOGIC;
			Beq_ctrl_o   		: OUT 	STD_LOGIC;
			Bne_ctrl_o          : OUT 	STD_LOGIC;
			j_ctrl_o            : OUT 	STD_LOGIC;
			Jal_ctrl_o          : OUT 	STD_LOGIC;
			ALUOp_ctrl_o	 	: OUT 	STD_LOGIC_VECTOR(1 DOWNTO 0);
			INTR_FLUSH_o		: OUT 	STD_LOGIC
	);
	end component;
---------------------------------------------------------	
	component dmemory is
		generic(
		DATA_BUS_WIDTH : integer := 32;
		DTCM_ADDR_WIDTH : integer := 8;
		WORDS_NUM : integer := 256
		);
		PORT(	clk_i,rst_i        	: IN 	STD_LOGIC;
			dtcm_addr_i 		: IN 	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
			dtcm_data_wr_i 		: IN 	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
			MemRead_ctrl_i  	: IN 	STD_LOGIC;
			MemWrite_ctrl_i 	: IN 	STD_LOGIC;
			dtcm_data_rd_o 		: OUT 	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0)
		);
	end component;
---------------------------------------------------------		
	component Execute is
		generic(
			DATA_BUS_WIDTH : integer := 32;
			FUNCT_WIDTH    : integer := 6;
			PC_WIDTH       : integer := 10
		);
		PORT(	
			read_data1_i 		: IN 	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
			read_data2_i 		: IN 	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
			sign_extend_i 		: IN 	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
			funct_i 			: IN 	STD_LOGIC_VECTOR(FUNCT_WIDTH-1 DOWNTO 0);
			OPC             	: IN 	STD_LOGIC_VECTOR(5 DOWNTO 0);
			ALUOp_ctrl_i 		: IN 	STD_LOGIC_VECTOR(1 DOWNTO 0);
			ALUSrc_ctrl_i 		: IN 	STD_LOGIC;
			Rs_EX_i         	: IN 	STD_LOGIC_VECTOR(4 DOWNTO 0);
			Rt_EX_i         	: IN 	STD_LOGIC_VECTOR(4 DOWNTO 0);
			Rd_EX_i         	: IN 	STD_LOGIC_VECTOR(4 DOWNTO 0);
			EX_alu_res_IR_i   	: IN    STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
			Mux_data_write_ID_i : IN    STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
			ForwardA_i			: IN    STD_LOGIC_VECTOR(1 DOWNTO 0);
			ForwardB_i			: IN    STD_LOGIC_VECTOR(1 DOWNTO 0);
			alu_res_o 			: OUT	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
			reg_des_o       	: OUT   STD_LOGIC_VECTOR(4 DOWNTO 0);
			write_data_EX_o     : OUT	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0)
		);
	end component;
---------------------------------------------------------		
	component Idecode is
		generic(
			DATA_BUS_WIDTH : integer := 32
		);
		PORT(	
			clk_i,rst_i			: IN 	STD_LOGIC;
			instruction_i 		: IN 	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
			dtcm_data_rd_i 		: IN 	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
			alu_result_i		: IN 	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
			RegWrite_ctrl_i 	: IN 	STD_LOGIC;
			MemtoReg_ctrl_i 	: IN 	STD_LOGIC;
			RegDst_ctrl_i 		: IN 	STD_LOGIC_VECTOR(1 downto 0);
			pc_plus4_i      	: IN 	STD_LOGIC_VECTOR(9 DOWNTO 0);
			Jal_ctrl_i     	 	: IN 	STD_LOGIC;
			j_i                 : IN 	STD_LOGIC;
			beq_i               : IN 	STD_LOGIC; 
			bne_i               : IN 	STD_LOGIC; 		
			MEM_des_reg_i   	: IN    STD_LOGIC_VECTOR(4 DOWNTO 0);
			Stall_ID_i          : IN 	STD_LOGIC := '0';
			ForwardA_Branch_ID_i: IN 	STD_LOGIC; 	
			ForwardB_Branch_ID_i: IN 	STD_LOGIC; 
			EX_alu_res_IR_i		: IN 	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);	
			Read_ISR_ctrl_PC_i  : IN    STD_LOGIC; 
			INTR_i              : IN    STD_LOGIC; 
			EPC_i               : IN    STD_LOGIC_VECTOR(9 downto 0);
			read_data1_o		: OUT 	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
			read_data2_o		: OUT 	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
			sign_extend_o 		: OUT 	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
			jump_addr_res_o 	: OUT	STD_LOGIC_VECTOR(7 DOWNTO 0 ); -- transferd from EX
			branch_addr_res_o   : OUT	STD_LOGIC_VECTOR(7 DOWNTO 0 );
			Mux_data_write_ID_o : OUT 	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
			ID_flag_j_branch_o  : OUT	STD_LOGIC_VECTOR(1 downto 0);
			GIE_o               : OUT 	STD_LOGIC 	  
		);
	end component;
---------------------------------------------------------		
	component Ifetch is
		generic(
			WORD_GRANULARITY : boolean 	:= False;
			DATA_BUS_WIDTH : integer 	:= 32;
			PC_WIDTH : integer 			:= 10;
			NEXT_PC_WIDTH : integer 	:= 8; -- NEXT_PC_WIDTH = PC_WIDTH-2
			ITCM_ADDR_WIDTH : integer 	:= 8;
			WORDS_NUM : integer 		:= 256;
			INST_CNT_WIDTH : integer 	:= 16
		);
		PORT(	
			clk_i, rst_i 		: IN 	STD_LOGIC;
			Bne_ctrl_i   		: IN 	STD_LOGIC;
			Beq_ctrl_i      	: IN 	STD_LOGIC;
			jal_ctrl_i      	: IN 	STD_LOGIC;
			j_ctrl_i        	: IN 	STD_LOGIC;
			Stall_IF_i      	: IN 	STD_LOGIC;
			ALUOp_ctrl_i    	: IN    STD_LOGIC_VECTOR(1 downto 0);
			ID_flag_j_branch_i  : IN 	STD_LOGIC_VECTOR(1 downto 0);
			jump_addr_res_i     : IN 	STD_LOGIC_VECTOR(7 DOWNTO 0);
			branch_addr_res_i   : IN 	STD_LOGIC_VECTOR(7 DOWNTO 0);
			BPADDR_flag_i       : IN 	STD_LOGIC;
			Read_ISR_ctrl_PC_i  : IN 	STD_LOGIC;
			ISR_Addr_i          : IN    STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
			HOLD_PC_ctrl_i      : IN 	STD_LOGIC;
			pc_o 				: OUT	STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
			pc_plus4_o 			: OUT	STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
			instruction_o 		: OUT	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
			inst_cnt_o 			: OUT	STD_LOGIC_VECTOR(INST_CNT_WIDTH-1 DOWNTO 0)
		);
	end component;
---------------------------------------------------------
	COMPONENT PLL 
		GENERIC( DIV : natural := 3;	
				 freq: natural := 20000);
		port(
	    areset		: IN STD_LOGIC  := '0';
		inclk0		: IN STD_LOGIC  := '0';
		c0     		: OUT STD_LOGIC ;
		locked		: OUT STD_LOGIC );
    END COMPONENT;
--------------------------------------------------------------	
	COMPONENT PLL_FIR PORT
	(
		areset		: IN STD_LOGIC  := '0';
		inclk0		: IN STD_LOGIC  := '0';
		c0			: OUT STD_LOGIC ;
		locked		: OUT STD_LOGIC 
	);
END COMPONENT;
---------------------------------------------------------	
	COMPONENT Forwarding_Unit port(
			ID_Rs_IR_i         		   : IN STD_LOGIC_VECTOR(4 downto 0);
			ID_Rt_IR_i          	   : IN STD_LOGIC_VECTOR(4 downto 0);
			IF_Rs_IR_i         		   : IN STD_LOGIC_VECTOR(4 downto 0);
			IF_Rt_IR_i          	   : IN STD_LOGIC_VECTOR(4 downto 0);
			EX_des_reg_IR_i   		   : IN STD_LOGIC_VECTOR(4 downto 0);
			MEM_des_reg_IR_i 		   : IN STD_LOGIC_VECTOR(4 downto 0);
			MEMtoWB_ctrl_RegWrite_IR_i : IN STD_LOGIC;
			WBtoWB_ctrl_RegWrite_IR_i  : IN STD_LOGIC;
			ForwardA_o        		   : OUT STD_LOGIC_VECTOR(1 downto 0);
			ForwardB_o        		   : OUT STD_LOGIC_VECTOR(1 downto 0);
			ForwardA_Branch_ID_o	   : OUT STD_LOGIC;
			ForwardB_Branch_ID_o	   : OUT STD_LOGIC	 
		);
    END COMPONENT;
---------------------------------------------------------
	COMPONENT Hazard_Dunit port(
			EXtoWB_ctrl_MemtoReg_IR_i          : IN  STD_LOGIC; -- controls the mux between alu result and DTCM
			MEMtoWB_ctrl_MemtoReg_IR_i     	   : IN  STD_LOGIC;
			MEM_des_reg_IR_i				   : IN  STD_LOGIC_VECTOR(4 downto 0);
			IF_Rs_IR_i, IF_Rt_IR_i             : IN  STD_LOGIC_VECTOR(4 downto 0);
			ID_Rt_IR_i                         : IN  STD_LOGIC_VECTOR(4 downto 0);
			EXtoWB_ctrl_RegWrite_IR_i          : IN  STD_LOGIC;
			Bne_ctrl_i, Beq_ctrl_i             : IN  STD_LOGIC;
			EX_reg_dst_i                       : IN  STD_LOGIC_VECTOR(4 downto 0);
			Stall_IF_o, Stall_ID_o             : OUT STD_LOGIC;
			ctrl_mux_flush_o                   : OUT STD_LOGIC 
		);
    END COMPONENT;
---------------------------------------------------------
	COMPONENT FIR port(
			FIRIN_i 							 : in  std_logic_vector(31 downto 0);
			FIFORST_i, FIFOCLK_i, FIFOWEN_i		 : in  std_logic;
			FIRCLK_i, FIRRST_i, FIRENA_i      	 : in  std_logic;
			COEF0_i, COEF1_i, COEF2_i, COEF3_i	 : in  std_logic_vector(7 downto 0);
			COEF4_i, COEF5_i, COEF6_i, COEF7_i   : in  std_logic_vector(7 downto 0);
			FIROUT_read_DataBus_ctrl_i           : in  std_logic;
			GIE_i                                : in  std_logic;
			CLR_IRQ_r_i                          : in  std_logic_vector(7 downto 0);
			FIRIFG_o           					 : out std_logic;
			FIFOFULL_o, FIFOEMPTY_o				 : out std_logic;
			FIROUT_o                     		 : out std_logic_vector(31 downto 0)
		);
    END COMPONENT;
---------------------------------------------------------
	COMPONENT FIFO IS
		generic (
			g_WIDTH 	: integer := 24;
			g_DEPTH 	: integer := 32
			);
		 port (
			i_rst_sync 	: in std_logic;
			i_clk      	: in std_logic;

			i_wr_en   	: in  std_logic;
			i_wr_data 	: in  std_logic_vector(g_WIDTH-1 downto 0);
			o_full    	: out std_logic;
			i_rd_en   	: in  std_logic;
			o_rd_data 	: out std_logic_vector(g_WIDTH-1 downto 0);
			o_empty   	: out std_logic
		);
    END COMPONENT;
---------------------------------------------------------
	COMPONENT Basic_Timer IS
		generic (
				n : integer := 16;
				k : integer := 3; 
				m : integer := 4
			);
		 port (
				BTCCR0_i, BTCCR1_i 		: in  std_logic_vector(31 downto 0); 
				BTHOLD_i, BTCLR_i   	: in  std_logic;
				MCLK_i                  : in  std_logic;
				BTSSELX_i, BTIPx_i      : in  std_logic_vector(1 downto 0);
				BTOUTMD_i, BTOUTEN_i    : in  std_logic;
				BTCNT_io                : inout  std_logic_vector(31 downto 0);
				BTIFG_o, PWM_out_o      : out std_logic
		);
    END COMPONENT;
---------------------------------------------------------	
	COMPONENT MCU IS
		GENERIC(
				MemWidth	: INTEGER := 10;
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
	END COMPONENT;
---------------------------------------------------------
	COMPONENT INTERRUPT_unit IS
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
				-- IFG_STATUS_ERROR_i : IN STD_LOGIC;
				GIE_i			   : IN		STD_LOGIC;			
				INTR_o			   : OUT	STD_LOGIC;
				IRQ_OUT_o		   : OUT    STD_LOGIC_VECTOR(7 DOWNTO 0);
				INTR_Active_o	   : OUT	STD_LOGIC;
				IRQ_CLEARED_OUT_o  : OUT	STD_LOGIC_VECTOR(7 DOWNTO 0);
				CLR_IRQ_r_o        : OUT    STD_LOGIC_VECTOR(7 DOWNTO 0)
			);
	END COMPONENT;
---------------------------------------------------------
	COMPONENT Address_Decoder PORT( 
			rst_i 									: in	STD_LOGIC;
			AddressBus_i							: in	STD_LOGIC_VECTOR(11 DOWNTO 0);
			PORT_LED_o, PORT_SW_o					: out 	STD_LOGIC;
			PORT_HEX0_o, PORT_HEX1_o, PORT_HEX2_o	: out 	STD_LOGIC;
			PORT_HEX3_o, PORT_HEX4_o, PORT_HEX5_o	: out 	STD_LOGIC
			);
	END COMPONENT;	
---------------------------------------------------------
	COMPONENT GPIO IS
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
	END COMPONENT;
---------------------------------------------------------
	COMPONENT Input_Per IS
		GENERIC(DataBusSize	: integer := 32);
		PORT( 
			MemRead_i			: in	std_logic;
			Port_HEX_i			: in 	std_logic;
			switch_i			: in	std_logic_vector(7 DOWNTO 0);
			Device_to_DataBus_o	: out	std_logic_vector(DataBusSize-1 DOWNTO 0)
			);
	END COMPONENT;
---------------------------------------------------------
	COMPONENT Output_Per IS
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
	END COMPONENT;
end aux_package;

