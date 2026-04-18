library IEEE;
use ieee.std_logic_1164.all;
---------------------------------------------------------
entity tb_logic is
	generic (n : integer := 8);
end tb_logic;
-------------------------------------------------------------------------------
architecture dataflow_logic of tb_logic is
	component Logic is 
    generic (n : INTEGER :=8 );
	port (x,y   : in STD_LOGIC_VECTOR (7 downto 0);
		  ALUFN	: in STD_LOGIC_VECTOR (2 downto 0); 
		  res   : out STD_LOGIC_VECTOR(7 downto 0));
end component ;
	signal x,y      :STD_LOGIC_VECTOR (7 downto 0);
	signal ALUFN  : STD_LOGIC_VECTOR(2 downto 0);
	signal res: STD_LOGIC_VECTOR(7 downto 0);
	
begin
	test_Logic: Logic port map (x => x, y => y, ALUFN => ALUFN, res => res);
				 
		tb_log_list : process
		begin
		x <= "11001100"; y <= "11001100"; ALUFN <= "000"; wait for 50 ns;  -- not
		x <= "00011110"; y <= "00100101"; ALUFN <= "001"; wait for 50 ns ; -- or
		x <= "00011100"; y <= "10101010"; ALUFN <= "010"; wait for 50 ns ; -- and
		x <= "10101010"; y <= "10111010"; ALUFN <= "011"; wait for 50 ns ; -- xor
		x <= "11011001"; y <= "10111010"; ALUFN <= "100"; wait for 50 ns ; -- nor
		x <= "00000111"; y <= "00100101"; ALUFN <= "101"; wait for 50 ns ; -- nand
		x <= "11000001"; y <= "10111010"; ALUFN <= "110"; wait for 50 ns ; -- undefined
		x <= "11001110"; y <= "00100101"; ALUFN <= "111"; wait for 50 ns ; -- xnor
		end process tb_log_list;
		
end architecture dataflow_logic;
