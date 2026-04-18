library IEEE;
use ieee.std_logic_1164.all;

package aux_package is
--------------------------------------------------------
	component top is
	generic (n : INTEGER := 8;
		     k : integer := 3;   -- k=log2(n)
		     m : integer := 4); -- m=2^(k-1)
	port 
	(  
		Y_i, X_i: in STD_LOGIC_VECTOR (n-1 downto 0);
		ALUFN_i : in STD_LOGIC_VECTOR (4 downto 0);
		ALUout_o: out STD_LOGIC_VECTOR(n-1 downto 0);
		Nflag_o, Cflag_o, Zflag_o, Vflag_o: OUT STD_LOGIC
--		Debug : OUT STD_LOGIC_VECTOR(2*n DOWNTO 0) -- For debugging	
	); -- Zflag,Cflag,Nflag, Vflag
	end component;
------------Full-Adder component-------------------------------  
	component FA is
		port (a, b, cin : IN std_logic;
			  s, cout   : OUT std_logic);
	end component;
-------------Adder/Subtractor component------------------------
	component AdderSub is
		generic (n : INTEGER := 8);
		port (x,y	: IN STD_LOGIC_VECTOR (n-1 downto 0);
		      ALUFN : IN STD_LOGIC_VECTOR(2 downto 0);
              cout	: OUT STD_LOGIC;
              s	    : OUT STD_LOGIC_VECTOR(n-1 downto 0));
	end component;
-----------Shifter component-----------------------------------
	component Shifter IS
		generic (n	: INTEGER := 8);
		port (x,y	: IN STD_LOGIC_VECTOR (n-1 downto 0);
		      ALUFN	: IN STD_LOGIC_VECTOR(2 downto 0);
              cout	: OUT STD_LOGIC;
              res	: OUT STD_LOGIC_VECTOR(n-1 downto 0));
	end component;
------------Logic component-------------------------------------
	component Logic IS
		generic (n : INTEGER := 8);
		port (x,y	: IN STD_LOGIC_VECTOR (n-1 downto 0);
			  ALUFN : IN STD_LOGIC_VECTOR (2 downto 0);
			  res   : OUT STD_LOGIC_VECTOR(n-1 downto 0));
	end component;
	
end aux_package;
