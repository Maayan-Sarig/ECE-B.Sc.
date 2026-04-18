LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
use ieee.numeric_std.all;
USE work.aux_package.ALL;
-----------------------------------------
ENTITY Hazard_Dunit IS
	PORT(
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
		
END 	Hazard_Dunit;
------------ ARCHITECTURE ----------------
ARCHITECTURE structure OF Hazard_Dunit IS
	SIGNAL stall_lw_w, stall_branch_w 	: BOOLEAN;
	SIGNAL stall_mux_res_w           	: STD_LOGIC;    
BEGIN
	
	-- Stalls logic define
	stall_lw_w       <= ((EXtoWB_ctrl_MemtoReg_IR_i = '1') AND (ID_Rt_IR_i = IF_Rs_IR_i OR ID_Rt_IR_i = IF_Rt_IR_i));
	
	stall_branch_w   <= ((Bne_ctrl_i = '1' OR Beq_ctrl_i = '1') AND (EXtoWB_ctrl_RegWrite_IR_i = '1') AND 
					    (EX_reg_dst_i = IF_Rs_IR_i OR EX_reg_dst_i = IF_Rt_IR_i)) OR
					    ((Bne_ctrl_i = '1' OR Beq_ctrl_i = '1') AND (MEMtoWB_ctrl_MemtoReg_IR_i = '1') AND
					    (MEM_des_reg_IR_i = IF_Rs_IR_i OR MEM_des_reg_IR_i = IF_Rt_IR_i));
					  
	-- stall_2_branch_w <= (((EXtoWB_ctrl_MemtoReg_IR_i = '1') AND (ID_Rt_IR_i = IF_Rs_IR_i OR ID_Rt_IR_i = IF_Rt_IR_i)) AND
						-- (Bne_ctrl_i = '1' OR Beq_ctrl_i = '1'));

	stall_mux_res_w	 <= '1' WHEN (stall_lw_w OR stall_branch_w) ELSE '0';
						
	Stall_IF_o       <= stall_mux_res_w;
	Stall_ID_o       <= stall_mux_res_w;       
	ctrl_mux_flush_o <= stall_mux_res_w;  
	
END Structure;