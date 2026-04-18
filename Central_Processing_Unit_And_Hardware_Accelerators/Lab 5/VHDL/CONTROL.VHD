---------------------------------------------------------------------------------------------
-- Copyright 2025 Hananya Ribo 
-- Advanced CPU architecture and Hardware Accelerators Lab 361-1-4693 BGU
---------------------------------------------------------------------------------------------
-- control module (implements MIPS control unit)
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;
USE work.const_package.all;


ENTITY control IS
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
END control;

ARCHITECTURE behavior OF control IS

	SIGNAL  rtype_w, lw_w, sw_w, beq_w, itype_imm_w , bne_w, slti_w, lui_w, jal_w, j_w, shift_w: STD_LOGIC;

BEGIN           
				-- Code to generate control signals using opcode bits
	rtype_w 			<=  '1'	WHEN	opcode_i = "000000" or opcode_i = "011100" 		 ELSE '0'; -- Rtype, mult, mov(is addu)
	lw_w          		<=  '1'	WHEN  	opcode_i = "100011"  							 ELSE '0'; -- lw
 	sw_w          		<=  '1'	WHEN  	opcode_i = "101011"  							 ELSE '0'; -- sw
   	beq_w         		<=  '1'	WHEN  	opcode_i = "000100"  		 			 	     ELSE '0'; -- beq
	bne_w               <=  '1'	WHEN  	opcode_i = "000101"  		 				     ELSE '0'; -- bne
	itype_imm_w			<=	'1'	WHEN	((opcode_i = "001000") or (opcode_i = "001001") or
										( opcode_i = "001101") or ( opcode_i = "001100")or
										(opcode_i = "001110") or ( opcode_i = "001001")) ELSE '0'; -- addi, li(is addiu), ori, andi, xori, li	
	slti_w              <=  '1'	WHEN  	opcode_i = "001010"  		 					 ELSE '0'; -- slti
	lui_w               <=  '1'	WHEN  	opcode_i = "001111"  		 					 ELSE '0'; -- lui
	jal_w               <=  '1'	WHEN  	opcode_i = "000011"  		 					 ELSE '0'; -- jal
	j_w                 <=  '1'	WHEN  	((opcode_i = "000010") or 
										((opcode_i = "000000") and (func_i = "001000"))) ELSE '0'; -- j, jr
	shift_w             <=  '1'	WHEN  	((opcode_i = "000000") 
										and ((func_i = "000000") or (func_i = "000010")))ELSE '0'; -- sll, srl
	
	-- check addi works
	
  	RegDst_ctrl_o(0)    <=  rtype_w;
	RegDst_ctrl_o(1)    <=  jal_w;
 	ALUSrc_ctrl_o  		<=  (lw_w OR sw_w or itype_imm_w or lui_w or shift_w or slti_w);
	MemtoReg_ctrl_o 	<=  lw_w;
  	RegWrite_ctrl_o 	<=  (rtype_w OR lw_w or itype_imm_w or slti_w or lui_w or jal_w);
  	MemRead_ctrl_o 		<=  lw_w;
   	MemWrite_ctrl_o 	<=  sw_w; 
 	Beq_ctrl_o      	<=  beq_w;
	Bne_ctrl_o      	<=  bne_w;
	Jal_ctrl_o        	<=  jal_w;
	ALUOp_ctrl_o(0) 	<=  (beq_w or bne_w or shift_w);
	ALUOp_ctrl_o(1) 	<=  rtype_w;
	j_ctrl_o            <=  j_w;
   END behavior;


