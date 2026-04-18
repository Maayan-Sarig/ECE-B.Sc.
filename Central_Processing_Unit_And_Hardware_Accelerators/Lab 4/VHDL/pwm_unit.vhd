LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.aux_package.all;
-------------------------------------
entity pwm_unit is
  generic (n : integer := 16;
		   k : integer := 3;   -- k=log2(n)
		   m : integer := 4	); -- m=2^(k-1)
  port 
  (  
		  Y_i, X_i      : in std_logic_vector(n -1 downto 0);
		  ALUFN         : in std_logic_vector (m downto 0);
		  ena, rst, clk : in std_logic;
		  pwm_out       : out std_logic
  );
  
end pwm_unit;
--------------------------------------
architecture pwm_unit_dataflow of pwm_unit is 
	
	signal Y, X         : std_logic_vector(n - 1 downto 0);
	signal MODE         : std_logic_vector(2 downto 0);
	signal EN           : std_logic;
	signal pwm_sig      : std_logic := '0';     
	signal timer        : std_logic_vector(15 downto 0) := (others => '0');
	
begin
	
	Y    <= Y_i when ALUFN(4 downto 3) = "00" else
	     (others => '0');

	X    <= X_i when ALUFN(4 downto 3) = "00" else
	     (others => '0');	
		 
	EN   <= ena when ALUFN(4 downto 3) = "00" else
	     '0';
	
	MODE <= ALUFN(2 downto 0);
	
	process (clk, rst)
	begin
		if rising_edge(clk) then
			if (rst = '0') then
				timer <= (others => '0');
			elsif (EN = '1') then
				if (timer >= Y) then
					timer <= (others => '0');
				else
					timer <= timer + 1;
				end if;
			end if;
		end if;
	end process;
	
	process (clk)
    begin
        if (rising_edge(clk) and EN = '1') then
		    if (timer < (X - 1) and MODE = "000") then
				pwm_sig <= '0';
			elsif((timer < (X - 1) or (Y = timer)) and MODE = "001") then
				pwm_sig <= '1';
			elsif(timer >= (X - 1) and timer <= (Y - 1) and MODE = "000" ) then
				pwm_sig <= '1';
			elsif(timer >= (X - 1) and timer <= (Y - 1) and MODE = "001") then
				pwm_sig <= '0';				
			elsif(MODE = "010") then
				if (timer = (X - 1)) then
					pwm_sig <= not(pwm_sig);
				end if;
			else
				pwm_sig <= '0';
			end if;
	    end if;
    end process;
	
	pwm_out  <=	 pwm_sig;
	
end pwm_unit_dataflow;

