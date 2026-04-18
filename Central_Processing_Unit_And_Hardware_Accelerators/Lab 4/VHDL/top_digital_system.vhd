LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.aux_package.all;
-------------------------------------
entity top_digital_system is
  generic (n : integer := 8;
		   k : integer := 3;   -- k=log2(n)
		   m : integer := 4	); -- m=2^(k-1)
  port 
  (  
		  Y_i,X_i 							 : in  std_logic_vector (15 downto 0)  := (others => '0');
		  ALUFN_i 							 : in  std_logic_vector (m downto 0);
		  ena, rst, clk 					 : in  std_logic;
		  ALUout_o							 : out std_logic_vector(n-1 downto 0);
		  Nflag_o, Cflag_o, Zflag_o, Vflag_o : out std_logic;
		  pwm_out      					     : out std_logic

  ); 
end top_digital_system;
--------------------------------------
architecture top_digital_system_dataflow of top_digital_system is 
	signal X_sig,Y_sig   : std_logic_vector(15 downto 0);
	SIGNAL ALUFN_sig     : std_logic_vector(4 downto 0);
begin
	
	-- process(clk) ---for critical path
		-- begin
		-- if rising_edge(clk) then
			X_sig 	  <= X_i;
			Y_sig 	  <= Y_i;
			ALUFN_sig <= ALUFN_i;
		-- end if;
	-- end process;

	top_alu_connect  : top_alu  generic map(n, k, m)   port map ( Y_sig, X_sig, ALUFN_sig, ALUout_o, Nflag_o, Cflag_o, Zflag_o, Vflag_o);
	
	pwm_unit_connect : pwm_unit generic map(16, k, m)   port map ( Y_sig, X_sig, ALUFN_sig, ena, rst, clk, pwm_out);
												   
	
END top_digital_system_dataflow;

