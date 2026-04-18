library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.aux_package.all;
------------------------------------------------------------------
entity top is
	generic ( n : positive := 8 ); 
	port( rst_i, clk_i, repeat_i : in std_logic;
		  upperBound_i           : in std_logic_vector(n-1 downto 0);
		  count_o                : out std_logic_vector(n-1 downto 0);
		  busy_o                 : out std_logic);
end top;
------------------------------------------------------------------
architecture arc_sys of top is
	signal en_fast       : std_logic;
	signal en_slow       : std_logic;
	signal control_fast  : std_logic_vector(n-1 downto 0);
	signal control_slow  : std_logic_vector(n-1 downto 0);
	signal cnt_fast      : std_logic_vector(n-1 downto 0);
	signal cnt_slow      : std_logic_vector(n-1 downto 0);
	constant zeros       : std_logic_vector(n-1 downto 0) := (others => '0');

begin
	----------------------------------------------------------------
	----------------------- fast counter process -------------------
	----------------------------------------------------------------
	proc1 : process(clk_i,rst_i)
	begin
		if (rst_i = '1') then
			cnt_fast <= (others => '0');
		elsif (clk_i'event and clk_i = '1') then
			if (en_fast = '1') then
				cnt_fast <= control_fast + 1;
			else
				cnt_fast <= control_fast;
		end if;
	end if;
	end process;
	----------------------------------------------------------------
	---------------------- slow counter process --------------------
	----------------------------------------------------------------
	proc2 : process(clk_i,rst_i)
	begin
		if (rst_i = '1') then
			cnt_slow <= (others => '0');
		elsif (clk_i'event and clk_i = '1') then
			if (en_slow = '1') then
				cnt_slow <= control_slow + 1;
			else
				cnt_slow <= control_slow;
		end if;
	end if;
	end process;
	---------------------------------------------------------------
	--------------------- combinational part ----------------------
	---------------------------------------------------------------
	control_fast <= cnt_fast when cnt_fast < cnt_slow else
					zeros    when cnt_fast = cnt_slow and upperBound_i > cnt_fast else
					cnt_fast when cnt_fast = cnt_slow and upperBound_i <= cnt_fast and repeat_i = '0' else
					zeros;
	
	control_slow <= cnt_slow when cnt_fast < cnt_slow else
					cnt_slow when cnt_fast = cnt_slow and upperBound_i > cnt_slow else
					cnt_slow when cnt_fast = cnt_slow and upperBound_i <= cnt_fast and repeat_i = '0' else
					zeros;
	
	en_fast      <= '1' when cnt_fast < cnt_slow else
					'0' when cnt_fast = cnt_slow and upperBound_i > cnt_fast else
					'0' when cnt_fast = cnt_slow and upperBound_i <= cnt_fast and repeat_i = '0' else
					'0';
	
	en_slow      <= '0' when cnt_fast < cnt_slow else
					'1' when cnt_fast = cnt_slow and upperBound_i > cnt_slow else
					'0' when cnt_fast = cnt_slow and upperBound_i <= cnt_fast and repeat_i = '0' else
					'0';
	
	count_o <= cnt_fast;
	
	busy_o  <= '0' when en_fast = '0' and en_slow = '0' and repeat_i = '0' else
	           '1';
	----------------------------------------------------------------
end arc_sys;







