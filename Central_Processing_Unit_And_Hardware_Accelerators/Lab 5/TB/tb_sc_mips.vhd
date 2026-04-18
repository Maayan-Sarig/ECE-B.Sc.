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

ENTITY MIPS_tb IS
	generic( 
		WORD_GRANULARITY : boolean := G_WORD_GRANULARITY;
	    MODELSIM : integer := G_MODELSIM;
		DATA_BUS_WIDTH : integer := 32;
		ITCM_ADDR_WIDTH : integer := G_ADDRWIDTH;
		DTCM_ADDR_WIDTH : integer := G_ADDRWIDTH;
		PC_WIDTH : integer := 10;
		FUNCT_WIDTH : integer := 6;
		DATA_WORDS_NUM : integer := G_DATA_WORDS_NUM;
		CLK_CNT_WIDTH : integer := 16;
		INST_CNT_WIDTH : integer := 16
	);
END MIPS_tb;

ARCHITECTURE struct OF MIPS_tb IS
   -- Internal signal declarations
   SIGNAL rst_tb_i           : STD_LOGIC;
   SIGNAL clk_tb_i           : STD_LOGIC;
   SIGNAL bpaddr_tb_i        : STD_LOGIC_VECTOR(7 DOWNTO 0);

   -- Outputs from MIPS core
   SIGNAL mclk_cnt_tb_o      : STD_LOGIC_VECTOR(CLK_CNT_WIDTH-1 DOWNTO 0);
   SIGNAL inst_cnt_tb_o      : STD_LOGIC_VECTOR(INST_CNT_WIDTH-1 DOWNTO 0);
   SIGNAL if_pc_tb_o         : STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
   SIGNAL if_inst_tb_o       : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
   SIGNAL id_pc_tb_o         : STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
   SIGNAL id_inst_tb_o       : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
   SIGNAL ex_pc_tb_o         : STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
   SIGNAL ex_inst_tb_o       : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
   SIGNAL mem_pc_tb_o        : STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
   SIGNAL mem_inst_tb_o      : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
   SIGNAL wb_pc_tb_o         : STD_LOGIC_VECTOR(PC_WIDTH-1 DOWNTO 0);
   SIGNAL wb_inst_tb_o       : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
   SIGNAL strigger_tb_o      : STD_LOGIC;
   SIGNAL flush_cnt_tb_o     : STD_LOGIC_VECTOR(7 DOWNTO 0);
   SIGNAL stall_cnt_tb_o     : STD_LOGIC_VECTOR(7 DOWNTO 0);

BEGIN
	CORE : MIPS
	generic map(
		WORD_GRANULARITY => WORD_GRANULARITY,
	    MODELSIM => MODELSIM,
		DATA_BUS_WIDTH => DATA_BUS_WIDTH,
		ITCM_ADDR_WIDTH => ITCM_ADDR_WIDTH,
		DTCM_ADDR_WIDTH => DTCM_ADDR_WIDTH,
		PC_WIDTH => PC_WIDTH,
		FUNCT_WIDTH => FUNCT_WIDTH,
		DATA_WORDS_NUM => DATA_WORDS_NUM,
		CLK_CNT_WIDTH => CLK_CNT_WIDTH,
		INST_CNT_WIDTH => INST_CNT_WIDTH
	)
	PORT MAP (
		rst_i            => rst_tb_i,
		clk_i            => clk_tb_i,
		BPADDR_i         => bpaddr_tb_i,
		CLKCNT_o         => mclk_cnt_tb_o,
		INSTCNT_o        => inst_cnt_tb_o,
		IFpc_o           => if_pc_tb_o,
		IFinstruction_o  => if_inst_tb_o,
		IDpc_o           => id_pc_tb_o,
		IDinstruction_o  => id_inst_tb_o,
		EXpc_o           => ex_pc_tb_o,
		EXinstruction_o  => ex_inst_tb_o,
		MEMpc_o          => mem_pc_tb_o,
		MEMinstruction_o => mem_inst_tb_o,
		WBpc_o           => wb_pc_tb_o,
		WBinstruction_o  => wb_inst_tb_o,
		STRIGGER_o       => strigger_tb_o,
		FHCNT_o          => flush_cnt_tb_o,
		STCNT_o          => stall_cnt_tb_o
	);

--------------------------------------------------------------------
	gen_clk : process
    begin
		clk_tb_i <= '1';
		wait for 50 ns;
		clk_tb_i <= '0';
		wait for 50 ns;
    end process;

	gen_rst : process
    begin
		rst_tb_i <= '0';
		wait for 80 ns;
		rst_tb_i <= '1';
		wait;
    end process;

	bpaddr_tb_i <= "00000000";

--------------------------------------------------------------------
END struct;
