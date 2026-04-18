library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity tb_shifter is
	generic (n : integer := 8);
end tb_shifter;

architecture dataflow_shift of tb_shifter is  
component Shifter is
	port (  x,y   : in  STD_LOGIC_VECTOR(7 downto 0);
            ALUFN : in  STD_LOGIC_VECTOR(2 downto 0);  
		    cout  : out STD_LOGIC;
            res   : out STD_LOGIC_VECTOR(7 downto 0)); 	
end component;

signal x,y,res : STD_LOGIC_VECTOR(7 downto 0);
signal ALUFN   : STD_LOGIC_VECTOR(2 downto 0);
signal cout    : STD_LOGIC;

begin 
	test_shifter : Shifter port map(x => x, y => y, ALUFN => ALUFN, cout => cout, res => res);
		
		tb_shifter_list : process
        begin
		x <= "01011111"; y <= "11101111"; ALUFN <= "000"; wait for 50 ns; 
		x <= "11110010"; y <= "01010101"; ALUFN <= "000"; wait for 50 ns; 
		x <= "01100110"; y <= "10000010"; ALUFN <= "000"; wait for 50 ns; 
		x <= "01001101"; y <= "01111011"; ALUFN <= "001"; wait for 50 ns; 
		x <= "01111010"; y <= "01000001"; ALUFN <= "001"; wait for 50 ns; 
		x <= "01111101"; y <= "01101100"; ALUFN <= "001"; wait for 200 ns; 
		end process tb_shifter_list;
end dataflow_shift;





