---------------------------------------------------------------------------------------------
-- Copyright 2025 Hananya Ribo 
-- Advanced CPU architecture and Hardware Accelerators Lab 361-1-4693 BGU
---------------------------------------------------------------------------------------------
--  Execute module (implements the data ALU and Branch Address Adder  
--  for the MIPS computer)
LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;


ENTITY  Execute IS
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
END Execute;


ARCHITECTURE behavior OF Execute IS
	SIGNAL a_input_w, b_input_w 	: STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
	SIGNAL alu_out_mux_w			: STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
	SIGNAL alu_ctl_w				: STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL mux_in_alu_A		    	: STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);
	SIGNAL mux_in_alu_B		    	: STD_LOGIC_VECTOR(DATA_BUS_WIDTH-1 DOWNTO 0);	
BEGIN

	a_input_w <= 	mux_in_alu_B WHEN (ALUOp_ctrl_i = "11") ELSE -- Rt to a_input when shift
					mux_in_alu_A;
					
	b_input_w <= 	mux_in_alu_B WHEN (ALUSrc_ctrl_i = '0') ELSE 
					sign_extend_i(DATA_BUS_WIDTH-1 DOWNTO 0); -- for lw, sw, itype, lui, shift, slti
	
	-- ALU MUX input (with forwarding)
	mux_in_alu_A	<= 	read_data1_i        WHEN	ForwardA_i = "00" ELSE -- from ID
						EX_alu_res_IR_i     WHEN	ForwardA_i = "10" ELSE -- from MEM
						Mux_data_write_ID_i WHEN    ForwardA_i = "01" ELSE -- from WB
						X"00000000";                       

	mux_in_alu_B	<= 	read_data2_i        WHEN	ForwardB_i = "00" ELSE -- from ID
						EX_alu_res_IR_i     WHEN	ForwardB_i = "10" ELSE -- from MEM
						Mux_data_write_ID_i WHEN    ForwardB_i = "01" ELSE -- from WB
						X"00000000";   
	
	write_data_EX_o <= mux_in_alu_B;
--------------------------------------------------------------------------------------------------------

	PROCESS (ALUOp_ctrl_i, funct_i, OPC)
	BEGIN
 	CASE ALUOp_ctrl_i IS
		WHEN "10" => -- r-type
			CASE funct_i IS
				WHEN "100000" => alu_ctl_w <= "0010"; -- add
				WHEN "100001" => alu_ctl_w <= "0010"; -- mov(addu)
				WHEN "100010" => alu_ctl_w <= "0110"; -- sub
				WHEN "000010" => alu_ctl_w <= "0011"; -- mul
				WHEN "100100" => alu_ctl_w <= "0000"; -- and
				WHEN "100101" => alu_ctl_w <= "0001"; -- or
				WHEN "100110" => alu_ctl_w <= "0100"; -- xor
				WHEN "101010" => alu_ctl_w <= "0111"; -- slt
				WHEN "001000" => alu_ctl_w <= "1110"; -- jr
				WHEN OTHERS   => alu_ctl_w <= "1111"; -- else
			END CASE;				
		WHEN "00" => -- i-type
			CASE OPC IS
				WHEN "100011" => alu_ctl_w <= "0010"; -- lw
				WHEN "101011" => alu_ctl_w <= "0010"; -- sw
				WHEN "001000" => alu_ctl_w <= "0010"; -- addi
				WHEN "001100" => alu_ctl_w <= "0000"; -- andi
				WHEN "001101" => alu_ctl_w <= "0001"; -- ori
				WHEN "001110" => alu_ctl_w <= "0100"; -- xori
				WHEN "001111" => alu_ctl_w <= "1001"; -- lui
				WHEN "001010" => alu_ctl_w <= "0111"; -- slti
				WHEN "001001" => alu_ctl_w <= "0010"; -- li(addiu)
		        WHEN OTHERS   => alu_ctl_w <= "1111"; -- else
			END CASE;			
		WHEN "01" 	=> 
								 alu_ctl_w <= "0110"; -- beq, bne	
								 
 	 	WHEN "11"	=>  -- shift
			CASE funct_i IS
				WHEN "000000" => alu_ctl_w <= "0101"; -- sll
				WHEN "000010" => alu_ctl_w <= "1000"; -- srl
				WHEN OTHERS   => alu_ctl_w <= "1111"; -- else
			END CASE;
		
		WHEN OTHERS =>  
								 alu_ctl_w <= "1111"; -- else	
  	END CASE;
  END PROCESS;
--------------------------------------------------------------------------------------------------------

	--------------- Select ALU operation ---------------------
	
PROCESS ( alu_ctl_w, a_input_w, b_input_w )
	BEGIN
 	CASE alu_ctl_w IS
		-- ALU performs ALUresult = A_input AND B_input
		WHEN "0000" 	=>	alu_out_mux_w 	<= a_input_w AND b_input_w; 
		-- ALU performs ALUresult = A_input OR B_input
     	WHEN "0001" 	=>	alu_out_mux_w 	<= a_input_w OR b_input_w;
		-- ALU performs ALUresult = A_input + B_input
	 	WHEN "0010" 	=>	alu_out_mux_w 	<= a_input_w + b_input_w; 
		-- ALU performs ALUresult = A_input * B_input
 	 	WHEN "0011" 	=>	alu_out_mux_w <= a_input_w(15 downto 0) * b_input_w(15 downto 0);
		-- ALU performs ALUresult = A_input XOR B_input
 	 	WHEN "0100" 	=>	alu_out_mux_w 	<= a_input_w XOR b_input_w;
		-- ALU performs ALUresult = A_input SLL B_input
 	 	WHEN "0101" 	=>	alu_out_mux_w 	<=	std_logic_vector(shift_left(unsigned(a_input_w),to_integer(unsigned(b_input_w(10 downto 6))))); -- shamt 

		-- ALU performs ALUresult = A_input SRL B_input
 	 	WHEN "1000" 	=>	alu_out_mux_w 	<=	std_logic_vector(shift_right(unsigned(a_input_w),to_integer(unsigned(b_input_w(10 downto 6))))); -- shamt 

		-- ALU performs ALUresult = A_input - B_input
 	 	WHEN "0110" 	=>	alu_out_mux_w 	<= a_input_w - b_input_w; 
		-- ALU performs SLT
  	 	WHEN "0111" 	=>	alu_out_mux_w 	<= a_input_w - b_input_w;  
		-- ALU performs LUI
  	 	WHEN "1001" 	=>	alu_out_mux_w 	<= b_input_w(15 DOWNTO 0) & X"0000";
		-- ALU performs jr (alu_out = a_input)
  	 	WHEN "1110" 	=>	alu_out_mux_w 	<= a_input_w;
		-- OUTPUT ZERO
 	 	WHEN OTHERS		=>	alu_out_mux_w 	<= X"00000000";
  	END CASE;
END PROCESS;
--------------------------------------------------------------------------------------------------------

	
	-- Select ALU output    
	alu_res_o <= 	X"0000000" & B"000"  & alu_out_mux_w(31) WHEN  alu_ctl_w = "0111" ELSE  -- slt and slti execuation
					alu_out_mux_w(DATA_BUS_WIDTH-1 DOWNTO 0);
					
	reg_des_o <=    Rd_EX_i WHEN ALUOp_ctrl_i(1) = '1' ELSE -- r-type
					Rt_EX_i; -- i-type

END behavior;

