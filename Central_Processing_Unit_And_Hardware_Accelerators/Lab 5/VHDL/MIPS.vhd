---------------------------------------------------------------------------------------------
-- Copyright 2025 Hananya Ribo 
-- Advanced CPU architecture and Hardware Accelerators Lab 361-1-4693 BGU
---------------------------------------------------------------------------------------------
-- Top Level Structural Model for MIPS Processor Core
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;
USE work.cond_comilation_package.all;
USE work.aux_package.all;


ENTITY MIPS IS
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
END MIPS;
-------------------------------------------------------------------------------------
ARCHITECTURE structure OF MIPS IS
	-- declare signals used to connect VHDL components
	SIGNAL pc_plus4_w 		   : STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
	SIGNAL read_data1_w 	   : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
	SIGNAL read_data2_w 	   : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
	SIGNAL sign_extend_w 	   : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
	SIGNAL alu_result_w 	   : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
	SIGNAL dtcm_data_rd_w 	   : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
	SIGNAL alu_src_w 		   : STD_LOGIC;
	SIGNAL beq_w 		       : STD_LOGIC;
	SIGNAL bne_w 		       : STD_LOGIC;
	SIGNAL j_w 		           : STD_LOGIC;
	SIGNAL jal_w 	           : STD_LOGIC;
	SIGNAL reg_dst_w 		   : STD_LOGIC_VECTOR(1 downto 0);
	SIGNAL reg_write_w 		   : STD_LOGIC;
	SIGNAL zero_w 			   : STD_LOGIC;
	SIGNAL mem_write_w 		   : STD_LOGIC;
	SIGNAL MemtoReg_w 		   : STD_LOGIC;
	SIGNAL mem_read_w 		   : STD_LOGIC;
	SIGNAL alu_op_w 		   : STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL instruction_w	   : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
	SIGNAL MCLK_w 			   : STD_LOGIC;
	SIGNAL mclk_cnt_q		   : STD_LOGIC_VECTOR(CLK_CNT_WIDTH-1 DOWNTO 0);
	SIGNAL inst_cnt_w		   : STD_LOGIC_VECTOR(INST_CNT_WIDTH-1 DOWNTO 0);
	SIGNAL flush_cnt_q         : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL stall_cnt_q         : STD_LOGIC_VECTOR(7 DOWNTO 0); 
	SIGNAL ena                 : STD_LOGIC := '1';
	SIGNAL PC_IF_w             : STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
	SIGNAL EX_reg_dst_w        : STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL Mux_data_write_ID_w : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0); 
	SIGNAL ID_flag_j_branch_w  : STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL write_data_EX_w     : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0); 
	SIGNAL jump_addr_res_w     : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL branch_addr_res_w   : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL BPADDR_flag_w       : STD_LOGIC;
--------------state registers-------------------------------------

--------------IF---------------- 	
-- register
	SIGNAL IF_instruction_IR   : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
	SIGNAL IF_PC_IR            : STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
	SIGNAL IF_PC_plus4_IR      : STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
-- control 
--------------ID----------------
-- register
	SIGNAL ID_instruction_IR   : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
	SIGNAL ID_imm_extended_IR  : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
	SIGNAL ID_Rs_IR            : STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL ID_Rt_IR            : STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL ID_Rd_IR            : STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL ID_read_data1_IR    : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
	SIGNAL ID_read_data2_IR    : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
	SIGNAL ID_PC_IR            : STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);

--------------EX----------------
-- register
	SIGNAL EX_alu_res_IR       : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
	SIGNAL EX_des_reg_IR       : STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL EX_PC_IR            : STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
	SIGNAL EX_instruction_IR   : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
	SIGNAL EX_read_data2_IR    : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
-- control 
	SIGNAL EXtoEX_ctrl_ALUop_IR        : STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL EXtoEX_ctrl_ALUsrc_IR       : STD_LOGIC;
	SIGNAL EXtoMEM_ctrl_MemRead_IR 	   : STD_LOGIC;
	SIGNAL EXtoMEM_ctrl_MemWrite_IR    : STD_LOGIC;
	SIGNAL EXtoWB_ctrl_RegWrite_IR     : STD_LOGIC;
	SIGNAL EXtoWB_ctrl_MemtoReg_IR     : STD_LOGIC;
	SIGNAL EXtoWB_ctrl_RegDst_IR       : STD_LOGIC_VECTOR(1 downto 0);

--------------MEM----------------
-- register
	SIGNAL MEM_DTCM_IR         : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
	SIGNAL MEM_alu_res_IR      : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
	SIGNAL MEM_des_reg_IR      : STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL MEM_PC_IR           : STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
	SIGNAL MEM_instruction_IR  : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
-- control 
	SIGNAL MEMtoMEM_ctrl_MemRead_IR  : STD_LOGIC;
	SIGNAL MEMtoMEM_ctrl_MemWrite_IR : STD_LOGIC;
	SIGNAL MEMtoWB_ctrl_RegWrite_IR  : STD_LOGIC;
	SIGNAL MEMtoWB_ctrl_MemtoReg_IR  : STD_LOGIC;
	SIGNAL MEMtoWB_ctrl_RegDst_IR    : STD_LOGIC_VECTOR(1 DOWNTO 0);

---------------WB------------------
-- control 
	SIGNAL WBtoWB_ctrl_RegWrite_IR   : STD_LOGIC;
	SIGNAL WBtoWB_ctrl_MemtoReg_IR   : STD_LOGIC;
	SIGNAL WBtoWB_ctrl_RegDst_IR     : STD_LOGIC_VECTOR(1 DOWNTO 0);
	
---------------Hazard--------------
	SIGNAL Stall_IF_w 				 : STD_LOGIC;  
	SIGNAL Stall_ID_w 				 : STD_LOGIC;       
	SIGNAL ctrl_mux_flush_w          : STD_LOGIC;  

---------------forwarding----------
	SIGNAL ForwardA_w  		         : STD_LOGIC_VECTOR(1 DOWNTO 0); 
	SIGNAL ForwardB_w  		         : STD_LOGIC_VECTOR(1 DOWNTO 0); 
	SIGNAL ForwardA_Branch_ID_w      : STD_LOGIC;
	SIGNAL ForwardB_Branch_ID_w      : STD_LOGIC;



BEGIN

	-- connect the PLL component
	G0:
	if (MODELSIM = 0) generate
	  MCLK: PLL
		PORT MAP (
			inclk0 	=> clk_i,
			c0 		=> MCLK_w
		);
	else generate
		MCLK_w <= clk_i;
	end generate;
	-- connect the 5 MIPS components   
	IFE : Ifetch
	generic map(
		WORD_GRANULARITY	=> 	WORD_GRANULARITY,
		DATA_BUS_WIDTH		=> 	DATA_BUS_WIDTH, 
		PC_WIDTH			=>	PC_WIDTH,
		ITCM_ADDR_WIDTH		=>	ITCM_ADDR_WIDTH,
		WORDS_NUM			=>	DATA_WORDS_NUM,
		INST_CNT_WIDTH		=>	INST_CNT_WIDTH
	)
	PORT MAP (	
		clk_i 				=> MCLK_w,  
		rst_i 				=> rst_i, 
		Bne_ctrl_i   		=> bne_w,
		Beq_ctrl_i      	=> beq_w,
		jal_ctrl_i      	=> jal_w,
		j_ctrl_i        	=> j_w,
		jump_addr_res_i     => jump_addr_res_w,
		branch_addr_res_i   => branch_addr_res_w,
		ALUOp_ctrl_i    	=> alu_op_w,
		Stall_IF_i      	=> Stall_IF_w,
		ID_flag_j_branch_i  => ID_flag_j_branch_w,
		BPADDR_flag_i       => BPADDR_flag_w, -- stops PC 
		pc_o 				=> PC_IF_w,
		pc_plus4_o	 		=> pc_plus4_w,
		instruction_o 		=> instruction_w,
		inst_cnt_o			=> inst_cnt_w
	);

	ID : Idecode
   	generic map(
		DATA_BUS_WIDTH		=>  DATA_BUS_WIDTH
	)
	PORT MAP (	
		clk_i 				 => MCLK_w,  
		rst_i 				 => rst_i,
        instruction_i 		 => IF_instruction_IR,
        dtcm_data_rd_i 		 => MEM_DTCM_IR,
		alu_result_i 		 => MEM_alu_res_IR,
		RegWrite_ctrl_i 	 => WBtoWB_ctrl_RegWrite_IR,
		MemtoReg_ctrl_i 	 => WBtoWB_ctrl_MemtoReg_IR,
		RegDst_ctrl_i 		 => WBtoWB_ctrl_RegDst_IR,
		pc_plus4_i           => IF_PC_plus4_IR,
		Jal_ctrl_i           => jal_w,
		j_i                  => j_w,
		beq_i                => beq_w,
		bne_i                => bne_w,
		MEM_des_reg_i        => MEM_des_reg_IR,
		ForwardA_Branch_ID_i => ForwardA_Branch_ID_w,
		ForwardB_Branch_ID_i => ForwardB_Branch_ID_w,	
		EX_alu_res_IR_i      => EX_alu_res_IR,		
		read_data1_o 		 => read_data1_w,
        read_data2_o 		 => read_data2_w,
		sign_extend_o 		 => sign_extend_w,
		Stall_ID_i           => Stall_ID_w,
		jump_addr_res_o 	 => jump_addr_res_w,
		branch_addr_res_o    => branch_addr_res_w,
		Mux_data_write_ID_o  => Mux_data_write_ID_w,
		ID_flag_j_branch_o   => ID_flag_j_branch_w
		);

	CTL:   control
	PORT MAP ( 	
			opcode_i 			=> IF_instruction_IR(DATA_BUS_WIDTH-1 DOWNTO 26),
			func_i              => IF_instruction_IR(5 downto 0),
			RegDst_ctrl_o 		=> reg_dst_w,
			ALUSrc_ctrl_o 		=> alu_src_w,
			MemtoReg_ctrl_o 	=> MemtoReg_w,
			RegWrite_ctrl_o 	=> reg_write_w,
			MemRead_ctrl_o 		=> mem_read_w,
			MemWrite_ctrl_o 	=> mem_write_w,
			Beq_ctrl_o   		=> beq_w,
			Bne_ctrl_o          => bne_w,
			j_ctrl_o            => j_w,
			Jal_ctrl_o          => jal_w,
			ALUOp_ctrl_o 		=> alu_op_w
		);

	EXE:  Execute
   	generic map(
		DATA_BUS_WIDTH 		=> 	DATA_BUS_WIDTH,
		FUNCT_WIDTH 		=>	FUNCT_WIDTH,
		PC_WIDTH 			=>	PC_WIDTH
	)
	PORT MAP (	
		read_data1_i 		=> ID_read_data1_IR,
        read_data2_i 		=> ID_read_data2_IR,
		sign_extend_i 		=> ID_imm_extended_IR,
        funct_i				=> ID_instruction_IR(5 DOWNTO 0),
		OPC             	=> ID_instruction_IR(31 downto 26),
		ALUOp_ctrl_i 		=> EXtoEX_ctrl_ALUop_IR,
		ALUSrc_ctrl_i 		=> EXtoEX_ctrl_ALUsrc_IR,
		Rs_EX_i         	=> ID_Rs_IR,
		Rt_EX_i         	=> ID_Rt_IR,
		Rd_EX_i         	=> ID_Rd_IR,
		EX_alu_res_IR_i   	=> EX_alu_res_IR,
		Mux_data_write_ID_i => Mux_data_write_ID_w,
		ForwardA_i			=> ForwardA_w,
		ForwardB_i			=> ForwardB_w,
        alu_res_o			=> alu_result_w,
		reg_des_o       	=> EX_reg_dst_w,
		write_data_EX_o 	=> write_data_EX_w
	);

	G1: 
	if (WORD_GRANULARITY = True) generate -- i.e. each WORD has a unike address - MODELSIM
		MEM1:  dmemory
			generic map(
				DATA_BUS_WIDTH		=> 	DATA_BUS_WIDTH, 
				DTCM_ADDR_WIDTH		=> 	DTCM_ADDR_WIDTH,
				WORDS_NUM			=>	DATA_WORDS_NUM
			)
			PORT MAP (	
				clk_i 				=> MCLK_w,  
				rst_i 				=> rst_i,
				dtcm_addr_i 		=> EX_alu_res_IR((DTCM_ADDR_WIDTH+2)-1 DOWNTO 2), -- increment memory address by 4
				dtcm_data_wr_i 		=> EX_read_data2_IR,-- connect to EX due to forwarding unit
				MemRead_ctrl_i 		=> MEMtoMEM_ctrl_MemRead_IR, 
				MemWrite_ctrl_i 	=> MEMtoMEM_ctrl_MemWrite_IR,
				dtcm_data_rd_o 		=> dtcm_data_rd_w 
			);	
	elsif (WORD_GRANULARITY = False) generate -- i.e. each BYTE has a unike address - FPGA
		MEM2:  dmemory
			generic map(
				DATA_BUS_WIDTH		=> 	DATA_BUS_WIDTH, 
				DTCM_ADDR_WIDTH		=> 	DTCM_ADDR_WIDTH,
				WORDS_NUM			=>	DATA_WORDS_NUM
			)
			PORT MAP (	
				clk_i 				=> MCLK_w,  
				rst_i 				=> rst_i,
				dtcm_addr_i 		=> EX_alu_res_IR(DTCM_ADDR_WIDTH-1 DOWNTO 2)&"00",
				dtcm_data_wr_i 		=> EX_read_data2_IR,-- connect to EX due to forwarding unit
				MemRead_ctrl_i 		=> MEMtoMEM_ctrl_MemRead_IR, 
				MemWrite_ctrl_i 	=> MEMtoMEM_ctrl_MemWrite_IR,
				dtcm_data_rd_o 		=> dtcm_data_rd_w
			);
	end generate;
	
Hazard_D:	Hazard_Dunit
	PORT MAP(	
		EXtoWB_ctrl_MemtoReg_IR_i  => EXtoWB_ctrl_MemtoReg_IR,
		MEMtoWB_ctrl_MemtoReg_IR_i => MEMtoWB_ctrl_MemtoReg_IR,
		MEM_des_reg_IR_i 		   => MEM_des_reg_IR,
		IF_Rs_IR_i                 => IF_instruction_IR(25 downto 21),
		IF_Rt_IR_i                 => IF_instruction_IR(20 downto 16),
		ID_Rt_IR_i                 => ID_Rt_IR,
		EXtoWB_ctrl_RegWrite_IR_i  => EXtoWB_ctrl_RegWrite_IR,
		Bne_ctrl_i 			       => bne_w,
		Beq_ctrl_i   		       => beq_w,
		EX_reg_dst_i			   => EX_reg_dst_w,
		Stall_IF_o 				   => Stall_IF_w,
		Stall_ID_o 				   => Stall_ID_w,
		ctrl_mux_flush_o 		   => ctrl_mux_flush_w		
	);	
	
Forwarding :	Forwarding_Unit
	PORT MAP(	
		ID_Rs_IR_i  		       => ID_Rs_IR,
		ID_Rt_IR_i 		           => ID_Rt_IR,
		IF_Rs_IR_i 		           => IF_instruction_IR(25 downto 21),     		   
		IF_Rt_IR_i  		       => IF_instruction_IR(20 downto 16),        	   
		EX_des_reg_IR_i  		   => EX_des_reg_IR,
		MEM_des_reg_IR_i  		   => MEM_des_reg_IR,
		MEMtoWB_ctrl_RegWrite_IR_i => MEMtoWB_ctrl_RegWrite_IR,
		WBtoWB_ctrl_RegWrite_IR_i  => WBtoWB_ctrl_RegWrite_IR,
		ForwardA_o  		       => ForwardA_w,
		ForwardB_o  		       => ForwardB_w,
		ForwardA_Branch_ID_o 	   => ForwardA_Branch_ID_w,
		ForwardB_Branch_ID_o 	   => ForwardB_Branch_ID_w
	);		
	
	----------------------- Connect Pipeline Registers ------------------------
	PROCESS BEGIN
		WAIT UNTIL (MCLK_w'EVENT AND MCLK_w = '1');
		IF  (rst_i = '1') THEN 
			-------------- IF Register ----------------
				----- Control Reg -----
				----- State Reg -----
			IF (Stall_ID_w = '0') THEN	
					IF_PC_plus4_IR    <= pc_plus4_w;			
					IF_instruction_IR <= instruction_w;
					IF_PC_IR          <= PC_IF_w;
			END IF;
			IF(ID_flag_j_branch_w(0) = '1' OR ID_flag_j_branch_w(1) = '1') THEN
					IF_PC_plus4_IR     <= "0000000000";
					IF_PC_IR           <= "0000000000";
				    IF_instruction_IR  <= X"00000000";
			END IF;
			-------------- ID Register ----------------
			IF(ctrl_mux_flush_w = '1') THEN
					----- Control Reg -----
				EXtoEX_ctrl_ALUop_IR     <= "00";
				EXtoEX_ctrl_ALUsrc_IR    <= '0';
				EXtoMEM_ctrl_MemRead_IR  <= '0';
				EXtoMEM_ctrl_MemWrite_IR <= '0';
				EXtoWB_ctrl_RegWrite_IR  <= '0';
				EXtoWB_ctrl_MemtoReg_IR  <= '0';
				EXtoWB_ctrl_RegDst_IR    <= "00";

					----- State Reg -----
				ID_instruction_IR <= X"00000000";
				ID_PC_IR          <= X"00" & "00";
				ID_read_data1_IR  <= X"00000000";
				ID_read_data2_IR  <= X"00000000";
				ID_imm_extended_IR<= X"00000000";
				ID_Rd_IR          <= "00000";
				ID_Rs_IR          <= "00000";
				ID_Rt_IR          <= "00000";
			ELSE 
					----- Control Reg -----
				EXtoEX_ctrl_ALUop_IR     <= alu_op_w;
				EXtoEX_ctrl_ALUsrc_IR    <= alu_src_w;
				EXtoMEM_ctrl_MemRead_IR  <= mem_read_w;
				EXtoMEM_ctrl_MemWrite_IR <= mem_write_w;
				EXtoWB_ctrl_RegWrite_IR  <= reg_write_w;
				EXtoWB_ctrl_MemtoReg_IR  <= MemtoReg_w;
				EXtoWB_ctrl_RegDst_IR    <= reg_dst_w;

					----- State Reg -----
				ID_instruction_IR <= IF_instruction_IR;
				ID_PC_IR          <= IF_PC_IR;
				ID_read_data1_IR  <= read_data1_w;
				ID_read_data2_IR  <= read_data2_w;
				ID_imm_extended_IR<= sign_extend_w;
				ID_Rd_IR          <= IF_instruction_IR(15 downto 11);
				ID_Rs_IR          <= IF_instruction_IR(25 downto 21);
				ID_Rt_IR          <= IF_instruction_IR(20 downto 16);
			END IF;
			-------------- EX Register ----------------
			----- Control Reg -----
			MEMtoMEM_ctrl_MemRead_IR  <= EXtoMEM_ctrl_MemRead_IR;
			MEMtoMEM_ctrl_MemWrite_IR <= EXtoMEM_ctrl_MemWrite_IR;
			MEMtoWB_ctrl_RegWrite_IR  <= EXtoWB_ctrl_RegWrite_IR;
			MEMtoWB_ctrl_MemtoReg_IR  <= EXtoWB_ctrl_MemtoReg_IR;
			MEMtoWB_ctrl_RegDst_IR    <= EXtoWB_ctrl_RegDst_IR;
			
			----- State Reg -----
			EX_instruction_IR <= ID_instruction_IR;
			EX_PC_IR          <= ID_PC_IR;
			EX_alu_res_IR     <= alu_result_w;
			EX_des_reg_IR     <= EX_reg_dst_w;
			EX_read_data2_IR  <= write_data_EX_w; -- for sw - data from Rt after forwarding mux
			
			-------------- MEM Register ----------------
			----- Control Reg -----
			WBtoWB_ctrl_RegWrite_IR  <= MEMtoWB_ctrl_RegWrite_IR;
			WBtoWB_ctrl_MemtoReg_IR  <= MEMtoWB_ctrl_MemtoReg_IR;
			WBtoWB_ctrl_RegDst_IR    <= MEMtoWB_ctrl_RegDst_IR;
			
			----- State Reg ----- 
			MEM_DTCM_IR              <= dtcm_data_rd_w;
			MEM_alu_res_IR           <= EX_alu_res_IR;  
			MEM_des_reg_IR           <= EX_des_reg_IR;     
			MEM_PC_IR                <= EX_PC_IR;  
			MEM_instruction_IR       <= EX_instruction_IR;

		END IF;
	END PROCESS;
---------------------------------------------------------------------------

	--------------------MIPS outputs connections---------------------------
			
			CLKCNT_o  		    <= mclk_cnt_q;
			INSTCNT_o 		    <= inst_cnt_w;
			IFpc_o              <= PC_IF_w;
			IFinstruction_o     <= instruction_w;
			IDpc_o              <= IF_PC_IR;
			IDinstruction_o     <= IF_instruction_IR;
			EXpc_o              <= ID_PC_IR;
			EXinstruction_o     <= ID_instruction_IR;
			MEMpc_o             <= EX_PC_IR;
			MEMinstruction_o    <= EX_instruction_IR;
			WBpc_o              <= MEM_PC_IR;
			WBinstruction_o     <= MEM_instruction_IR;
			STRIGGER_o          <= BPADDR_flag_w;
			FHCNT_o             <= flush_cnt_q;
			STCNT_o             <= stall_cnt_q;
	
			BPADDR_flag_w <= '1' WHEN (BPADDR_i = PC_IF_w(9 downto 2)) ELSE '0';
			
---------------------------------------------------------------------------------------
--					IPC - MCLK counter, stalls and flushes register                  --
---------------------------------------------------------------------------------------
process (MCLK_w , rst_i, Stall_ID_w, Stall_IF_w, ctrl_mux_flush_w)
begin
	if (rst_i = '0' OR BPADDR_flag_w = '1') THEN
		mclk_cnt_q	<=	(others	=> '0');
		flush_cnt_q <=	(others	=> '0'); 
		stall_cnt_q <= 	(others	=> '0'); 
	elsif rising_edge(MCLK_w) then
			mclk_cnt_q	<=	mclk_cnt_q + 1;
			IF(Stall_IF_w = '1' OR Stall_ID_w = '1') THEN
				stall_cnt_q <= stall_cnt_q + 1;
			END IF;
			IF(ctrl_mux_flush_w = '1') THEN
				flush_cnt_q <= flush_cnt_q + 1;
			END IF;
	END IF;
end process;

---------------------------------------------------------------------------------------
END structure;

