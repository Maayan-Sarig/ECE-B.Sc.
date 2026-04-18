library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.aux_package.all;
---------------------------------------------------------
entity tb_top is
	constant n : integer := 8;
	constant k : integer := 3;   -- k=log2(n)
	constant m : integer := 4;   -- m=2^(k-1)
	constant ROWmax : integer := 19; 
end tb_top;
-------------------------------------------------------------------------------
architecture rtb of tb is
	TYPE mem IS ARRAY (0 TO ROWmax) OF std_logic_vector(4 DOWNTO 0);
	signal Y,X:  STD_LOGIC_VECTOR (n-1 DOWNTO 0);
	signal ALUFN :  STD_LOGIC_VECTOR (4 DOWNTO 0);
	signal ALUout:  STD_LOGIC_VECTOR(n-1 DOWNTO 0); -- ALUout[n-1:0]&Cflag
	signal Nflag,Cflag,Zflag,Vflag: STD_LOGIC; -- Zflag,Cflag,Nflag,Vflag
	signal Icache : mem := (
							"01000","01001","01010","01011","01100","01000","01001","01111","10000","10001",
							"10010","10000","10001","10010","11001","11010","11101","11111","11011","00100");
BEGIN
	L0 : top GENERIC MAP (n,k,m) PORT MAP(Y, X, ALUFN, ALUout, Nflag, Cflag, Zflag, Vflag);
    
	--------- start of stimulus section ----------------------------------------		
        tb_x_y : PROCESS
        BEGIN
		  x <= (OTHERS => '1');
		  y <= (OTHERS => '1');
		  WAIT FOR 50 ns;
		  FOR i IN 0 TO 40 LOOP
			x <= x-4;
			y <= y-5;
			WAIT FOR 50 ns;
		  END LOOP;
		  WAIT;
        END PROCESS;
		 
		
		tb_ALUFN : process
        begin
		  ALUFN <= (others => '0');
		  for i in 0 to ROWmax loop
			ALUFN <= Icache(i);
			wait for 100 ns;
		  end loop;
		  wait;
        end process;
  
end architecture rtb;
