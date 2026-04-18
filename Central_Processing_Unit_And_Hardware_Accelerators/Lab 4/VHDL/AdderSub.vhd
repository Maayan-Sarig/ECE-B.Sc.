	
library ieee;
use ieee.std_logic_1164.all;
library work;
use work.aux_package.all;
----------------------------------------
entity AdderSub is
	generic(n : integer := 8);
	port (x, y  : in std_logic_vector(n-1 downto 0);
		  ALUFN : in std_logic_vector(2 downto 0);
		  cout  : out std_logic;
		  s     : out std_logic_vector(n-1 downto 0));
end AdderSub;
----------------------------------------
architecture dataflow of AdderSub is

	signal regis      		  			  : std_logic_vector(n-1 downto 0);
	signal x_add, y_add, s_addsub, s_swap : std_logic_vector(n-1 downto 0);
	signal cin             			      : std_logic;
	
begin

	operation : for i in 0 to n-1 generate
	x_add(i) <= x(i) when ALUFN = "000" else
				'1'  when ALUFN = "100" else
				'1' xor x(i) when ALUFN = "010" else
				'1' xor x(i) when ALUFN = "001" else
				'0';
				
	y_add(i) <= y(i) when ALUFN = "000" else
				y(i) when ALUFN = "100" else
				y(i) when ALUFN = "001" else
				y(i) when ALUFN = "011" else
				'0';
	end generate;
-------------------------------------------

	cin <= '1' when ALUFN = "001" else
		   '1' when ALUFN = "010" else
		   '1' when ALUFN = "011" else
		   '0';
	
-------------------------------------------

	first : FA port map(
			a => x_add(0),
			b => y_add(0),
			cin => cin,
			s => s_addsub(0),
			cout => regis(0)
			);
			
	rest : for i in 1 to n-1 generate
		   chain : FA port map(
				a => x_add(i),
				b => y_add(i),
				cin => regis(i-1),
				s => s_addsub(i),
				cout => regis(i)
			);
	end generate;
		
		s_swap(7 downto 4) <= y(3 downto 0);
		s_swap(3 downto 0) <= y(7 downto 4);
		
		s    <= s_swap when ALUFN = "101" else
				s_addsub;
				
		cout <= regis(n-1);
end dataflow;