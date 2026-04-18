library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.aux_package.all;

--------------------------------------------
entity Shifter is
  generic (	n  : INTEGER := 8;
			k  : INTEGER := 3);
  port ( x,y   : IN STD_LOGIC_VECTOR (n-1 downto 0); 
		 ALUFN : IN STD_LOGIC_VECTOR (k-1 downto 0);
         cout  : OUT STD_LOGIC; 
         res   : OUT STD_LOGIC_VECTOR(n-1 downto 0));
end Shifter;
--------------------------------------------
architecture dataflow of Shifter is
	subtype vector is std_logic_vector (n-1 downto 0);
	type shift_matrix is array (n-1 downto 0) of vector;
	signal mat : shift_matrix; 
	signal counter : integer := 1;

begin

	switch : for i in 0 to n-1 generate
		mat(0)(i) <= y(i) 	 when ALUFN = "000" else
					 y(n-1-i)when ALUFN = "001" else
					 '0';
	end generate;

	options : for i in 1 to n-1 generate
		mat(i) <= mat(i-1)(n-2 downto 0) & '0' when (ALUFN = "000" or ALUFN = "001") else
		mat(i-1);
		
	end generate;
	
	calc : for i in 0 to n-1 generate
		res(i) <= mat(0)(i) 	when (ALUFN = "000" and x(k-1 downto 0) = "000") else
				  mat(1)(i) 	when (ALUFN = "000" and x(k-1 downto 0) = "001") else
				  mat(2)(i) 	when (ALUFN = "000" and x(k-1 downto 0) = "010") else
				  mat(3)(i) 	when (ALUFN = "000" and x(k-1 downto 0) = "011") else
				  mat(4)(i) 	when (ALUFN = "000" and x(k-1 downto 0) = "100") else
				  mat(5)(i) 	when (ALUFN = "000" and x(k-1 downto 0) = "101") else
				  mat(6)(i)	    when (ALUFN = "000" and x(k-1 downto 0) = "110") else
				  mat(7)(i) 	when (ALUFN = "000" and x(k-1 downto 0) = "111") else
				  mat(0)(n-1-i) when (ALUFN = "001" and x(k-1 downto 0) = "000") else
				  mat(1)(n-1-i) when (ALUFN = "001" and x(k-1 downto 0) = "001") else
				  mat(2)(n-1-i) when (ALUFN = "001" and x(k-1 downto 0) = "010") else
				  mat(3)(n-1-i) when (ALUFN = "001" and x(k-1 downto 0) = "011") else
				  mat(4)(n-1-i) when (ALUFN = "001" and x(k-1 downto 0) = "100") else
				  mat(5)(n-1-i) when (ALUFN = "001" and x(k-1 downto 0) = "101") else
				  mat(6)(n-1-i) when (ALUFN = "001" and x(k-1 downto 0) = "110") else
				  mat(7)(n-1-i) when (ALUFN = "001" and x(k-1 downto 0) = "111") else
				  '0';
	end generate;
	
	counter <= conv_integer(unsigned(x(k-1 downto 0)));
	
	cout <= '0' 				  when counter = 0                      else
			mat(counter - 1)(n-1) when (ALUFN = "000" or ALUFN = "001") else
			'0';
	
end dataflow;
