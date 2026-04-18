library ieee;
use ieee.std_logic_1164.all;
use work.aux_package.all;
-----------------------------------------
entity Logic is
	generic( n : integer := 8);
	port( x, y : in std_logic_vector (n-1 downto 0);
		  ALUFN : in std_logic_vector (2 downto 0);
		  res : out std_logic_vector (n-1 downto 0)
		);
end Logic;
-------------------------------------------

architecture dataflow_logic of Logic is
begin
	claculate : for i in 0 to n-1 generate
		res(i) <= not(y(i))      when ALUFN = "000" else
				  x(i) or y(i)   when ALUFN = "001" else
				  x(i) and y(i)  when ALUFN = "010" else
				  x(i) xor y(i)  when ALUFN = "011" else
				  x(i) nor y(i)  when ALUFN = "100" else
				  x(i) nand y(i) when ALUFN = "101" else
			 	  x(i) xnor y(i) when ALUFN = "111" else
				  '0';
	end generate;
end dataflow_logic;