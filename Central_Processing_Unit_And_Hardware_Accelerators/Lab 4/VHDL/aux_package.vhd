library IEEE;
use ieee.std_logic_1164.all;

package aux_package is
--------------------------------------------------------
	component top_digital_system is
  generic (n : integer := 8;
		   k : integer := 3;   -- k=log2(n)
		   m : integer := 4	); -- m=2^(k-1)
  port 
  (  
		  Y_i,X_i 							 : in  std_logic_vector (15 downto 0);
		  ALUFN_i 							 : in  std_logic_vector (m downto 0);
		  ena, rst, clk 					 : in  std_logic;
		  ALUout_o							 : out std_logic_vector(n-1 downto 0);
		  Nflag_o, Cflag_o, Zflag_o, Vflag_o : out std_logic;
		  pwm_out      					     : out std_logic

  ); 
	end component ;

----------------------------------------------------------

component SevenSeg_format IS
  PORT (val_in: in std_logic_vector(3 DOWNTO 0);
		hex_out: out STD_LOGIC_VECTOR (6 downto 0));
END component;

----------------------------------------------------------

	component PLL IS
		PORT
		(
			areset		: IN STD_LOGIC  := '0';
			inclk0		: IN STD_LOGIC  := '0';
			c0			: OUT STD_LOGIC ;
			locked		: OUT STD_LOGIC 
		);
	END component;
--------------------------------------------------------
	component top_alu is
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
	end component;
--------------------------------------------------------------
	component pwm_unit is
  generic (n : integer := 8;
		   k : integer := 3;   -- k=log2(n)
		   m : integer := 4	); -- m=2^(k-1)
  port 
  (  
		  Y_i, X_i      : in std_logic_vector(15 downto 0);
		  ALUFN         : in std_logic_vector (m downto 0);
		  ena, rst, clk : in std_logic;
		  pwm_out       : out std_logic
  );
  
	end component;
	
-------------------------------------------------------------	
	
	component top_IO is
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
		  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5 : out std_logic_vector (HEX_size - 1 downto 0);
		  LED               				 : out std_logic_vector (LED_size - 1 downto 0);
		  pwm_out      					     : out std_logic

  ); 
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
