LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.aux_package.all;
-------------------------------------
entity top is
  generic (n : integer := 8;
		   k : integer := 3;   -- k=log2(n)
		   m : integer := 4	); -- m=2^(k-1)
  port 
  (  
		  Y_i,X_i : in STD_LOGIC_VECTOR (n-1 downto 0);
		  ALUFN_i : in STD_LOGIC_VECTOR (m downto 0);
		  ALUout_o: out STD_LOGIC_VECTOR(n-1 downto 0);
		  Nflag_o, Cflag_o, Zflag_o, Vflag_o: OUT STD_LOGIC
  ); -- Zflag,Cflag,Nflag,Vflag
end top;
--------------------------------------
architecture struct of top is 
	
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
	constant only_zeroes                                               : std_logic_vector(n-1 downto 0) := (others => '0');
	constant pos_over : std_logic_vector(n-1 downto 0) := ((n-1) => '1', others => '0');
	
begin

----data flow define----
	addSub_x <= X_i						 when ALUFN_i(4 downto 3) = "01" else input_z;
	addSub_y <= Y_i 					 when ALUFN_i(4 downto 3) = "01" else input_z;
	addSub_alufn <= ALUFN_i(2 downto 0)  when ALUFN_i(4 downto 3) = "01" else alu_z;
	
	logic_x <= X_i 						 when ALUFN_i(4 downto 3) = "11" else input_z;
	logic_y <= Y_i 						 when ALUFN_i(4 downto 3) = "11" else input_z;
	logic_alufn <= ALUFN_i(2 downto 0)   when ALUFN_i(4 downto 3) = "11" else alu_z;
	
	shifter_x <= X_i					 when ALUFN_i(4 downto 3) = "10" else input_z;
	shifter_y <= Y_i 					 when ALUFN_i(4 downto 3) = "10" else input_z;
	shifter_alufn <= ALUFN_i(2 downto 0) when ALUFN_i(4 downto 3) = "10" else alu_z;
	
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
					only_zeroes when "00",
					unaffected when others;
						

-------------------------------------

	Cflag_o <= carry_out(0) when ALUFN_i(4 downto 3) = "01" else
			   carry_out(1) when ALUFN_i(4 downto 3) = "11" else
			   '0';
			   
	Zflag_o <= '1' when alu_out = only_zeroes else '0';
	
	Nflag_o <= alu_out(n-1);
	
	Vflag_o <= '1' when ((ALUFN_i = "01010" and x_i = pos_over) or
						 (ALUFN_i = "01000" and x_i(n-1) = '0' and y_i(n-1) = '0' and alu_out(n-1) = '1') or -- positive + positive = negative
						 (ALUFN_i = "01000" and x_i(n-1) = '1' and y_i(n-1) = '1' and alu_out(n-1) = '0') or -- negative + negative = positive
						 (ALUFN_i = "01001" and x_i(n-1) = '0' and y_i(n-1) = '1' and alu_out(n-1) = '0') or -- negative - positive = positive
						 (ALUFN_i = "01001" and x_i(n-1) = '1' and y_i(n-1) = '0' and alu_out(n-1) = '1')) else -- positive - negative = negative
						 '0';
						 
	ALUout_o <= alu_out;
	
END struct;

