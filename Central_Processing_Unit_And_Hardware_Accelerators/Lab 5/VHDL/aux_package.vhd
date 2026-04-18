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
	PORT(	rst_i		 		:IN	  STD_LOGIC;
			clk_i				:IN	  STD_LOGIC; 
			BPADDR_i			:IN	  STD_LOGIC_VECTOR(7 DOWNTO 0); 
			-- Output important signals to pins for easy display in SignalTap
			
			CLKCNT_o			:OUT  STD_LOGIC_VECTOR(CLK_CNT_WIDTH-1 DOWNTO 0);
			INSTCNT_o 			:OUT  STD_LOGIC_VECTOR(INST_CNT_WIDTH-1 DOWNTO 0);
			IFpc_o				:OUT  STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
			IFinstruction_o     :OUT  STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
			IDpc_o				:OUT  STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
			IDinstruction_o     :OUT  STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
			EXpc_o				:OUT  STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
			EXinstruction_o     :OUT  STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
			MEMpc_o				:OUT  STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
			MEMinstruction_o    :OUT  STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
			WBpc_o				:OUT  STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
			WBinstruction_o     :OUT  STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
			STRIGGER_o          :OUT  STD_LOGIC;
			FHCNT_o             :OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
			STCNT_o             :OUT  STD_LOGIC_VECTOR(7 DOWNTO 0)
		);		
	end component;
---------------------------------------------------------  
	component control is
		PORT( 	
		opcode_i, func_i 	: IN 	STD_LOGIC_VECTOR(5 DOWNTO 0);
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
		ALUOp_ctrl_o	 	: OUT 	STD_LOGIC_VECTOR(1 DOWNTO 0)
	);
	end component;
---------------------------------------------------------	
	component dmemory is
		generic(
		DATA_BUS_WIDTH : integer := 32;
		DTCM_ADDR_WIDTH : integer := 8;
		WORDS_NUM : integer := 256
	);
	PORT(	clk_i,rst_i			: IN 	STD_LOGIC;
			dtcm_addr_i 		: IN 	STD_LOGIC_VECTOR(DTCM_ADDR_WIDTH-1 DOWNTO 0);
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
			FUNCT_WIDTH : integer := 6;
			PC_WIDTH : integer := 10
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
			Stall_ID_i          : IN 	STD_LOGIC; 
			ForwardA_Branch_ID_i: IN 	STD_LOGIC; 	
			ForwardB_Branch_ID_i: IN 	STD_LOGIC; 
			EX_alu_res_IR_i		: IN 	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);	
			read_data1_o		: OUT 	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
			read_data2_o		: OUT 	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
			sign_extend_o 		: OUT 	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
			jump_addr_res_o 	: OUT	STD_LOGIC_VECTOR(7 DOWNTO 0 ); -- transferd from EX
			branch_addr_res_o   : OUT	STD_LOGIC_VECTOR(7 DOWNTO 0 );
			Mux_data_write_ID_o : OUT 	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
			ID_flag_j_branch_o  : OUT	STD_LOGIC_VECTOR(1 downto 0) 	  
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
		pc_o 				: OUT	STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
		pc_plus4_o 			: OUT	STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
		instruction_o 		: OUT	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
		inst_cnt_o 			: OUT	STD_LOGIC_VECTOR(INST_CNT_WIDTH-1 DOWNTO 0)
		);
	end component;
---------------------------------------------------------
	COMPONENT PLL port(
	    areset		: IN STD_LOGIC  := '0';
		inclk0		: IN STD_LOGIC  := '0';
		c0     		: OUT STD_LOGIC ;
		locked		: OUT STD_LOGIC );
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
end aux_package;

