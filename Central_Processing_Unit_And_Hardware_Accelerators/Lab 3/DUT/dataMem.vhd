library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.aux_package.all;

--------------------------------------------------------------
entity dataMem is
generic( Dwidth: integer:=16;
		 Awidth: integer:=6;
		 dept:   integer:=64);
port(	clk,memEn: in std_logic;	
		WmemData:	in std_logic_vector(Dwidth-1 downto 0);
		WmemAddr,RmemAddr:	
					in std_logic_vector(Awidth-1 downto 0);
		RmemData: 	out std_logic_vector(Dwidth-1 downto 0)
);
end dataMem;
--------------------------------------------------------------
architecture behav of dataMem is

type RAM is array (0 to dept-1) of 
	std_logic_vector(Dwidth-1 downto 0);
signal sysRAM : RAM;

begin			   
  process(clk)
  begin
	if (clk'event and clk='1') then
		RmemData <= sysRAM(conv_integer(RmemAddr));
	    if (memEn='1') then
		    -- index is type of integer so we need to use 
			-- buildin function conv_integer in order to change the type
		    -- from std_logic_vector to integer
			sysRAM(conv_integer(WmemAddr)) <= WmemData;
	    end if;
	end if;
  end process;
  
  process(clk)
    begin
		if rising_edge(clk) then
			report "///////////////////////////////DATA MAP/////////////////////////////////////////////"
			& LF & "DATA(0) = " & to_string(sysRAM(0))
			& LF & "DATA(1) =  " & to_string(sysRAM(1))
			& LF & "DATA(2) = " & to_string(sysRAM(2))
			& LF & "DATA(3) =  " & to_string(sysRAM(3))
			& LF & "DATA(4) = " & to_string(sysRAM(4))
			& LF & "DATA(5) =  " & to_string(sysRAM(5))
			& LF & "DATA(6) = " & to_string(sysRAM(6))
			& LF & "DATA(7) =  " & to_string(sysRAM(7))
			& LF & "DATA(8) = " & to_string(sysRAM(8))
			& LF & "DATA(9) =  " & to_string(sysRAM(9))	
			& LF & "DATA(10) =  " & to_string(sysRAM(10))
			& LF & "DATA(11) = " & to_string(sysRAM(11))
			& LF & "DATA(12) =  " & to_string(sysRAM(12))			
			& LF & "DATA(13) =  " & to_string(sysRAM(13))
			& LF & "DATA(14) = " & to_string(sysRAM(14))
			& LF & "DATA(15) =  " & to_string(sysRAM(15))
			& LF & "DATA(16) =  " & to_string(sysRAM(16))
			& LF & "DATA(17) = " & to_string(sysRAM(17))			
			& LF & "//////////////////////////////// End ///////////////////////////////////////////////";
		end if;
end process;

  
  
  
end behav;
