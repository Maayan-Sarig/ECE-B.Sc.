--------------- 
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE work.aux_package.ALL;
-------------- ENTITY --------------------
ENTITY Forwarding_Unit IS
	PORT( 
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
END 	Forwarding_Unit;
------------ ARCHITECTURE ----------------
ARCHITECTURE structure OF Forwarding_Unit IS
BEGIN
	PROCESS (MEMtoWB_ctrl_RegWrite_IR_i, EX_des_reg_IR_i, ID_Rs_IR_i, ID_Rt_IR_i, WBtoWB_ctrl_RegWrite_IR_i, MEM_des_reg_IR_i)
	BEGIN
	---------------Register Forwarding------------
		-- EX + MEM Hazard
		if((MEMtoWB_ctrl_RegWrite_IR_i = '1') and (EX_des_reg_IR_i /= "00000") and -- taken from MEM to EX
		   (EX_des_reg_IR_i = ID_Rs_IR_i)) then -- writing to a register which needed for compute in Rs on the next cycle
				ForwardA_o <= "10";
		elsif((WBtoWB_ctrl_RegWrite_IR_i = '1') and (MEM_des_reg_IR_i /= "00000") and (not -- taken from WB to EX
		     (MEMtoWB_ctrl_RegWrite_IR_i = '1' and (EX_des_reg_IR_i /= "00000") and -- writing to a register which needed for compute in Rs on the next next cycle
			 (EX_des_reg_IR_i = ID_Rs_IR_i))) and (MEM_des_reg_IR_i = ID_Rs_IR_i)) then 
				ForwardA_o <= "01";
		else		
				ForwardA_o <= "00";
		end if;
		
		if((MEMtoWB_ctrl_RegWrite_IR_i = '1') and (EX_des_reg_IR_i /= "00000") and -- taken from MEM to EX
		   (EX_des_reg_IR_i = ID_Rt_IR_i)) then -- writing to a register which needed for compute in Rt on the next cycle
				ForwardB_o <= "10";	
		elsif((WBtoWB_ctrl_RegWrite_IR_i = '1') and (MEM_des_reg_IR_i /= "00000") and (not -- taken from WB to EX
		     (WBtoWB_ctrl_RegWrite_IR_i = '1' and (EX_des_reg_IR_i /= "00000") and -- writing to a register which needed for compute in Rt on the next next cycle
			 (EX_des_reg_IR_i = ID_Rt_IR_i))) and (MEM_des_reg_IR_i = ID_Rt_IR_i)) then 
				ForwardB_o <= "01";
		else 
				ForwardB_o <= "00"; 
		end if;

	-------------- Branch Forwarding --------------------
		
		IF ( (IF_Rs_IR_i /= "00000") AND (IF_Rs_IR_i = EX_des_reg_IR_i) AND MEMtoWB_ctrl_RegWrite_IR_i = '1' ) THEN 
			ForwardA_Branch_ID_o <= '1';
		ELSE 
			ForwardA_Branch_ID_o <= '0';
		END IF;
		
		IF ( (IF_Rt_IR_i /= "00000") AND (IF_Rt_IR_i = EX_des_reg_IR_i) AND MEMtoWB_ctrl_RegWrite_IR_i = '1' ) THEN 
			ForwardB_Branch_ID_o <= '1';
		ELSE 
			ForwardB_Branch_ID_o <= '0';
		END IF;		
	
	END PROCESS;

END Structure;