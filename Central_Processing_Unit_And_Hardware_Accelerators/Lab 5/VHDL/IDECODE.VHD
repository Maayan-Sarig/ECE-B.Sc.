---------------------------------------------------------------------------------------------
-- Copyright 2025 Hananya Ribo 
-- Advanced CPU architecture and Hardware Accelerators Lab 361-1-4693 BGU
---------------------------------------------------------------------------------------------
--  Idecode module (implements the register file for the MIPS computer
LIBRARY IEEE; 		
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;


ENTITY Idecode IS
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
			read_data1_o		: OUT 	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
			read_data2_o		: OUT 	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
			sign_extend_o 		: OUT 	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
			jump_addr_res_o 	: OUT	STD_LOGIC_VECTOR(7 DOWNTO 0 ); -- transferd from EX
			branch_addr_res_o   : OUT	STD_LOGIC_VECTOR(7 DOWNTO 0 );
			Mux_data_write_ID_o : OUT 	STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
			ID_flag_j_branch_o  : OUT	STD_LOGIC_VECTOR(1 downto 0) 
			
	);
END Idecode;

	
ARCHITECTURE behavior OF Idecode IS
TYPE register_file IS ARRAY (0 TO 31) OF STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);

	SIGNAL RF_q					: register_file;
	SIGNAL write_reg_addr_w 	: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL write_reg_data_w		: STD_LOGIC_VECTOR( DATA_BUS_WIDTH-1 DOWNTO 0 );
	SIGNAL rs_register_w		: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL rt_register_w		: STD_LOGIC_VECTOR( 4 DOWNTO 0 );
	SIGNAL imm_value_w			: STD_LOGIC_VECTOR( 15 DOWNTO 0 );
	SIGNAL sign_extend_w        : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
	SIGNAL read_data1_w         : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
	SIGNAL read_data2_w         : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
	SIGNAL branch_addr_r 		: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL forward_mux_data1_w  : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
	SIGNAL forward_mux_data2_w  : STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
	
BEGIN
	rs_register_w 			<= instruction_i(25 DOWNTO 21);
   	rt_register_w 			<= instruction_i(20 DOWNTO 16);
   	imm_value_w 			<= instruction_i(15 DOWNTO 0);
	
	-- ForwardID mux
	forward_mux_data1_w  <=  EX_alu_res_IR_i WHEN ForwardA_Branch_ID_i = '1' ELSE read_data1_w;
	forward_mux_data2_w  <=  EX_alu_res_IR_i WHEN ForwardB_Branch_ID_i = '1' ELSE read_data2_w;
	
	-- flag if jump/branch occur - reset the ID_IR to zeroes
	ID_flag_j_branch_o(0) <= beq_i WHEN ((unsigned(forward_mux_data1_w) = unsigned(forward_mux_data2_w)) AND
									      Stall_ID_i = '0')                                                  ELSE 
                             bne_i WHEN ((unsigned(forward_mux_data1_w) /= unsigned(forward_mux_data2_w))AND 
										  Stall_ID_i = '0') 												 ELSE
							 '0'; -- branch

	ID_flag_j_branch_o(1) <= '1'   WHEN (Jal_ctrl_i = '1' OR j_i = '1') ELSE '0'; -- j, jr, jal
	
	-- Read Register 1 Operation
	
	read_data1_w <= RF_q(CONV_INTEGER(rs_register_w));
	read_data1_o <= read_data1_w;
	
	-- Read Register 2 Operation	
	read_data2_w <= RF_q(CONV_INTEGER(rt_register_w));
	read_data2_o <= read_data2_w;
	
	-- Mux for Register Write Address
	write_reg_addr_w <= "11111"       WHEN (Jal_ctrl_i = '1') ELSE -- jal
						MEM_des_reg_i;
	
	-- Mux to bypass data memory for Rformat instructions
	write_reg_data_w <= X"00000" & "00" & pc_plus4_i            WHEN (Jal_ctrl_i = '1')      ELSE  -- jal
						alu_result_i(DATA_BUS_WIDTH-1 DOWNTO 0) WHEN (MemtoReg_ctrl_i = '0') ELSE 
						dtcm_data_rd_i;  
	
	Mux_data_write_ID_o <= write_reg_data_w;
	
	-- Sign Extend 16-bits to 32-bits
    sign_extend_w <= 	X"0000" & imm_value_w WHEN imm_value_w(15) = '0' ELSE
						X"FFFF" & imm_value_w;

	sign_extend_o <=    sign_extend_w;  

	-- Adder to compute Branch Address
	branch_addr_r	<= pc_plus4_i(9 DOWNTO 2) + sign_extend_w(7 DOWNTO 0);
	
	jump_addr_res_o      <= instruction_i(7 downto 0) WHEN (instruction_i(31 downto 26) = "000010") OR       -- j
														   (instruction_i(31 downto 26) = "000011")     ELSE -- jal
							read_data1_w(9 downto 2); -- jr divided by 4
																
	branch_addr_res_o    <= branch_addr_r; -- branch
	
	-- addr_res_o 		<= read_data1_w(9 DOWNTO 2) WHEN ((instruction_i(31 downto 26) = "000000") 
													  -- and (instruction_i(5 downto 0) = "001000")) ELSE -- jr
					   -- branch_addr_r(7 DOWNTO 0);
	
	process(clk_i,rst_i)
	begin
		if (rst_i='0') then
			FOR i IN 0 TO 31 LOOP
				-- RF_q(i) <= CONV_STD_LOGIC_VECTOR(i,32);
				RF_q(i) <= CONV_STD_LOGIC_VECTOR(0,32);
			END LOOP;
		elsif (clk_i'event and clk_i='0') then
			if ((Jal_ctrl_i = '1' OR RegWrite_ctrl_i = '1') AND write_reg_addr_w /= 0) then
				RF_q(CONV_INTEGER(write_reg_addr_w)) <= write_reg_data_w;
				-- index is integer type so we must use conv_integer for type casting
			end if;
		end if;
end process;

END behavior;





