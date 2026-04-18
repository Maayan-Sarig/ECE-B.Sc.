library ieee;
use ieee.std_logic_1164.ALL;
use ieee.std_logic_arith.ALL;
use ieee.std_logic_unsigned.ALL;
-------------------------------------------------
entity AddSub_tb is
	generic (n : integer := 8);
end AddSub_tb;

architecture dataflow_AddSub of AddSub_tb is
component AdderSub is
port (  x,y     : in  STD_LOGIC_VECTOR(7 DOWNTO 0);
        ALUFN   : in  STD_LOGIC_VECTOR(2 DOWNTO 0);
        cout    : out STD_LOGIC;
        s       : out STD_LOGIC_VECTOR(7 DOWNTO 0));
end component;
    
	signal x,y,s : STD_LOGIC_VECTOR(7 DOWNTO 0);
	signal ALUFN   : STD_LOGIC_VECTOR(2 DOWNTO 0);
	signal cout    : STD_LOGIC;

begin
    test_AddSub: AdderSub port map (x => x, y => y, ALUFN => ALUFN, cout => cout, s => s);

		tb_AddSub_list : process
		begin
		x <= "01000000"; y <= "01111111"; ALUFN <= "000"; wait for 50 ns; --Overflow Case (127 + 64)
		x <= "00100001"; y <= "00001111"; ALUFN <= "000"; wait for 50 ns; --Addition (15 + 33)
		x <= "01000000"; y <= "01000000"; ALUFN <= "000"; wait for 50 ns; --Addition (64 + 64)
		x <= "00100000"; y <= "11111011"; ALUFN <= "001"; wait for 50 ns; --Negative Result (-5 - 32)
		x <= "00000011"; y <= "00000011"; ALUFN <= "001"; wait for 50 ns; --Zero(3 - 3)
		x <= "10111001"; y <= "00001111"; ALUFN <= "011"; wait for 50 ns; --inc + 1 (15+1)
		x <= "10111001"; y <= "00001111"; ALUFN <= "100"; wait for 50 ns; --dec - 1 (15-1)
		end process tb_AddSub_list;
		
end dataflow_AddSub;
