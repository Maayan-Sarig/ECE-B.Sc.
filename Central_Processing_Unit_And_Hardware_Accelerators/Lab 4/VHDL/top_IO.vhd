LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.aux_package.all;
-------------------------------------
entity top_IO is
  generic (switch_size : integer := 10;
		   key_size    : integer := 4;   -- k=log2(n)
		   HEX_size    : integer := 4;
		   LED_size    : integer := 10;
		   n 		   : integer := 8;
		   k           : integer := 3;   -- k=log2(n)
		   m           : integer := 4); -- m=2^(k-1)); -- m=2^(k-1)
  port 
  (  
		  clk 							     : in  std_logic;
		  SW                                 : in  std_logic_vector (switch_size - 1 downto 0);
		  KEY 							     : in  std_logic_vector (key_size - 1 downto 0);
		  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5 : out std_logic_vector (6 downto 0);
		  LED               				 : out std_logic_vector (LED_size - 1 downto 0) := (others => '0');
		  pwm_out      					     : out std_logic

  ); 
end top_IO;
--------------------------------------
architecture top_IO_dataflow of top_IO is 
	
	signal clk_sig, locked_pll        											   : std_logic;
	signal enable_low_Y, enable_high_Y, enable_low_X, enable_high_X, enable_ALUFN  : std_logic;
	signal reg_low_Y, reg_high_Y, reg_low_X, reg_high_X, ALUout_sig, reg_ALU       : std_logic_vector(7 downto 0) := (others => '0');
	signal Y_sig, X_sig                                                            : std_logic_vector(15 downto 0);   
	signal ALUFN_sig                                                               : std_logic_vector(4 downto 0);   
	signal HEX0_sig, HEX1_sig, HEX2_sig, HEX3_sig, HEX4_sig, HEX5_sig              : std_logic_vector (HEX_size - 1 downto 0);
	
begin

	top_digital_system_connect  : top_digital_system  generic map(n, k, m)   port map ( Y_sig, X_sig, ALUFN_sig, SW(8), KEY(3), clk_sig, ALUout_sig, LED(3), LED(2), LED(1), LED(0), pwm_out);
	
	PLL_connect 			    : PLL  port map ('0', clk, clk_sig, locked_pll);
													   
	enable_low_Y   <= '1' when (KEY(0) = '0' and SW(9) = '0') else '0';
	
	enable_high_Y  <= '1' when (KEY(0) = '0' and SW(9) = '1') else '0';
	
	enable_low_X   <= '1' when (KEY(1) = '0' and SW(9) = '0') else '0';
	
	enable_high_X  <= '1' when (KEY(1) = '0' and SW(9) = '1') else '0';
	
	process (clk)
	begin
		if rising_edge(clk) then
			if    (KEY(0) = '0' and SW(9) = '0') then
				       reg_low_Y  <=  SW(7 downto 0);
			elsif (KEY(0) = '0' and SW(9) = '1') then
				       reg_high_Y <=  SW(7 downto 0);
			elsif (KEY(1) = '0' and SW(9) = '0') then
				       reg_low_X  <=  SW(7 downto 0);		
			elsif (KEY(1) = '0' and SW(9) = '1') then
				       reg_high_X <=  SW(7 downto 0);					   
			elsif (KEY(2) = '0') then
				       reg_ALU  <=  SW(7 downto 0);			
			end if;
		end if;
	end process;
	
	
	Y_sig          <=  reg_high_Y & reg_low_Y;
	
	X_sig          <=  reg_high_X & reg_low_X;
	
	ALUFN_sig      <=  reg_ALU(4 downto 0);
	
	HEX0_sig       <=  X_sig(3 downto 0) when SW(9) = '0' else
					   X_sig(11 downto 8);
	
	HEX1_sig       <=  X_sig(7 downto 4) when SW(9) = '0' else
					   X_sig(15 downto 12);	
					   
	HEX2_sig       <=  Y_sig(3 downto 0) when SW(9) = '0' else
					   Y_sig(11 downto 8);
	
	HEX3_sig       <=  Y_sig(7 downto 4) when SW(9) = '0' else
					   Y_sig(15 downto 12);						   
	
	HEX4_sig       <=  ALUout_sig(3 downto 0);
	
	HEX5_sig       <=  ALUout_sig(7 downto 4);
	
	hex1_seven : SevenSeg_format port map(HEX0_sig, HEX0);
	
	hex2_seven : SevenSeg_format port map(HEX1_sig, HEX1);
	
	hex3_seven : SevenSeg_format port map(HEX2_sig, HEX2);
	
	hex4_seven : SevenSeg_format port map(HEX3_sig, HEX3);
	
	hex5_seven : SevenSeg_format port map(HEX4_sig, HEX4);
	
	hex6_seven : SevenSeg_format port map(HEX5_sig, HEX5);
	
	LED(9 downto 5) <= ALUFN_sig;
	
	LED(4) <= '0';
	
end top_IO_dataflow;
