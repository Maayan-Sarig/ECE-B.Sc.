library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.aux_package.all;

--------------------------------------------------------------
entity ProgMem is
generic( Dwidth: integer:=16;
		 Awidth: integer:=6;
		 dept:   integer:=64);
port(	clk,memEn           : in std_logic;	
		WmemData            : in std_logic_vector(Dwidth-1 downto 0);
		WmemAddr,RmemAddr   : in std_logic_vector(Awidth-1 downto 0);
		RmemData            : out std_logic_vector(Dwidth-1 downto 0)
);
end ProgMem;
--------------------------------------------------------------
architecture behav of ProgMem is

type RAM is array (0 to dept-1) of 
	std_logic_vector(Dwidth-1 downto 0);
signal sysRAM: RAM;

begin			   
  process(clk)
  begin
	if (clk'event and clk='1') then
	    if (memEn='1') then
		    -- index is type of integer so we need to use 
			-- buildin function conv_integer in order to change the type
		    -- from std_logic_vector to integer
			sysRAM(conv_integer(WmemAddr)) <= WmemData; 
	    end if;
	end if;
  end process;
	
  RmemData <= sysRAM(conv_integer(RmemAddr));

-- process(clk)
    -- begin
		-- if rising_edge(clk) then
			-- report "///////////////////////////////ProgMem MAP/////////////////////////////////////////////"
			-- & LF & "sysRAM(0) = " & to_string(sysRAM(0))
			-- & LF & "sysRAM(1) =  " & to_string(sysRAM(1))
			-- & LF & "sysRAM(2) = " & to_string(sysRAM(2))
			-- & LF & "sysRAM(3) =  " & to_string(sysRAM(3))
			-- & LF & "sysRAM(4) = " & to_string(sysRAM(4))
			-- & LF & "sysRAM(5) =  " & to_string(sysRAM(5))
			-- & LF & "sysRAM(6) = " & to_string(sysRAM(6))
			-- & LF & "sysRAM(7) =  " & to_string(sysRAM(7))
			-- & LF & "sysRAM(8) = " & to_string(sysRAM(8))
			-- & LF & "sysRAM(9) =  " & to_string(sysRAM(9))	
			-- & LF & "sysRAM(10) =  " & to_string(sysRAM(10))
			-- & LF & "sysRAM(11) = " & to_string(sysRAM(11))
			-- & LF & "sysRAM(12) =  " & to_string(sysRAM(12))			
			-- & LF & "sysRAM(13) =  " & to_string(sysRAM(13))
			-- & LF & "sysRAM(14) = " & to_string(sysRAM(14))
			-- & LF & "sysRAM(15) =  " & to_string(sysRAM(15))
			-- & LF & "sysRAM(16) =  " & to_string(sysRAM(16))
			-- & LF & "sysRAM(17) = " & to_string(sysRAM(17))
			-- & LF & "sysRAM(18) =  " & to_string(sysRAM(18))	
			-- & LF & "sysRAM(19) =  " & to_string(sysRAM(19))
			-- & LF & "sysRAM(20) = " & to_string(sysRAM(20))
			-- & LF & "sysRAM(21) =  " & to_string(sysRAM(21))			
			-- & LF & "sysRAM(22) =  " & to_string(sysRAM(22))
			-- & LF & "sysRAM(23) = " & to_string(sysRAM(23))
			-- & LF & "sysRAM(24) =  " & to_string(sysRAM(24))				
			-- & LF & "//////////////////////////////// End ///////////////////////////////////////////////";
		-- end if;
-- end process;

end behav;
