LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.aux_package.all;
-------------------------------------
entity top_alu is
  generic (n : integer := 8;
		   k : integer := 3;   -- k=log2(n)
		   m : integer := 4	); -- m=2^(k-1)
  port 
  (  
		  Y_i,X_i : in STD_LOGIC_VECTOR (15 downto 0);
		  ALUFN_i : in STD_LOGIC_VECTOR (m downto 0);
		  ALUout_o: out STD_LOGIC_VECTOR(n-1 downto 0);
		  Nflag_o, Cflag_o, Zflag_o, Vflag_o: OUT STD_LOGIC
  );
end top_alu;
--------------------------------------
architecture struct of top_alu is 
	
	subtype vector is std_logic_vector(n-1 downto 0);
	type    matrix is array(2 downto 0) of vector;
	signal  res_mat                                                    : matrix;
	signal  addSub_x, addSub_y, logic_x, logic_y, shifter_x, shifter_y : std_logic_vector(n-1 downto 0);
	signal  addSub_alufn, logic_alufn, shifter_alufn                   : std_logic_vector(2 downto 0);
	signal  addSub_res, logic_res, shifter_res                         : std_logic_vector(n-1 downto 0);
	signal  carry_out                                                  : std_logic_vector(1 downto 0);
	signal  alu_out                                                    : std_logic_vector(n-1 downto 0);
	signal  input_z                                                    : std_logic_vector(n-1 downto 0) := (others => 'Z');
	signal  alu_z                                                      : std_logic_vector(k-1 downto 0) := (others => 'Z');
	constant alu_zeroes                                                : std_logic_vector(k-1 downto 0) := (others => '0');
	constant only_zeroes                                               : std_logic_vector(n-1 downto 0) := (others => '0');
	constant pos_over : std_logic_vector(n-1 downto 0) := ((n-1) => '1', others => '0');
	signal  byte_X, byte_Y	                                           : std_logic_vector(n-1 downto 0) := (others => '0');
	
begin
	
	byte_X  <= X_i(7 downto 0);
	byte_y  <= Y_i(7 downto 0);


----data flow define----
	addSub_x <= byte_X					 when ALUFN_i(4 downto 3) = "01" else only_zeroes;
	addSub_y <= byte_y 					 when ALUFN_i(4 downto 3) = "01" else only_zeroes;
	addSub_alufn <= ALUFN_i(2 downto 0)  when ALUFN_i(4 downto 3) = "01" else alu_zeroes;
	
	logic_x <= byte_X 					 when ALUFN_i(4 downto 3) = "11" else only_zeroes;
	logic_y <= byte_y 					 when ALUFN_i(4 downto 3) = "11" else only_zeroes;
	logic_alufn <= ALUFN_i(2 downto 0)   when ALUFN_i(4 downto 3) = "11" else alu_zeroes;
	
	shifter_x <= byte_X					 when ALUFN_i(4 downto 3) = "10" else only_zeroes;
	shifter_y <= byte_y 				 when ALUFN_i(4 downto 3) = "10" else only_zeroes;
	shifter_alufn <= ALUFN_i(2 downto 0) when ALUFN_i(4 downto 3) = "10" else alu_zeroes;
	
----blocks define------
	adderSub_Block : AdderSub generic map(n) port map (x => addSub_x
												      ,y => addSub_y
													  ,ALUFN => addSub_alufn
													  ,cout => carry_out(0)
													  ,s => res_mat(0));
	
	logic_Block    : Logic generic map(n) port map (x => logic_x
												   ,y => logic_y
												   ,ALUFN => logic_alufn
												   ,res => res_mat(1));
												   
	shifter_Block  : Shifter generic map(n) port map (x => shifter_x
													 ,y => shifter_y
													 ,ALUFN => shifter_alufn
													 ,cout => carry_out(1)
													 ,res => res_mat(2));
	
----output define--------------------
	with ALUFN_i(4 downto 3) select
		alu_out <= 	res_mat(0)  when "01",
					res_mat(1)  when "11",
					res_mat(2)  when "10", 
					(others => '0') when others;
						

-------------------------------------

	Cflag_o <= carry_out(0) when ALUFN_i(4 downto 3) = "01" else
			   carry_out(1) when ALUFN_i(4 downto 3) = "11" else
			   '0';
			   
	Zflag_o <= '1' when alu_out = only_zeroes else '0';
	
	Nflag_o <= alu_out(n-1);
	
	Vflag_o <= '1' when ((ALUFN_i = "01010" and byte_X = pos_over) or
						 (ALUFN_i = "01000" and byte_X(n-1) = '0' and byte_y(n-1) = '0' and alu_out(n-1) = '1') or -- positive + positive = negative
						 (ALUFN_i = "01000" and byte_X(n-1) = '1' and byte_y(n-1) = '1' and alu_out(n-1) = '0') or -- negative + negative = positive
						 (ALUFN_i = "01001" and byte_X(n-1) = '0' and byte_y(n-1) = '1' and alu_out(n-1) = '0') or -- negative - positive = positive
						 (ALUFN_i = "01001" and byte_X(n-1) = '1' and byte_y(n-1) = '0' and alu_out(n-1) = '1')) else -- positive - negative = negative
						 '0';
						 
	ALUout_o <= alu_out;
	
END struct;

