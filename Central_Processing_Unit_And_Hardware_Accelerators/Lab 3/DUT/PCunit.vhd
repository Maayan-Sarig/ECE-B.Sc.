library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.aux_package.all;

-------------------------------------------------
entity PC_unit is

	generic(immediate_size: integer := 8;
			memory_size   : integer := 6
	        );

	port(	IR_immediate : in std_logic_vector(immediate_size-1 downto 0);	
			PCsel        : in std_logic_vector(1 downto 0);	
			PCin, clk    : in std_logic;
			PCout        : out std_logic_vector(memory_size - 1 downto 0)
	);
end PC_unit;

-------------------------------------------------
architecture PC_dataflow of PC_unit is
	
	signal current_PC, next_PC : std_logic_vector(memory_size - 1 downto 0) := (others => '0');
	signal offset              : std_logic_vector(memory_size - 1 downto 0);

begin
	
	offset <= IR_immediate(5 downto 0);
	
PC_sync : process(clk) begin
	        if(clk'event and clk = '1' and PCin = '1') then
				current_PC <= next_PC;
			end if;
	end process;

PC_offset: with PCsel select
		next_PC <= current_PC + 1 		    when "10",  -- PC + 1
				   current_PC + offset 	    when "01",  -- PC + 1 + offset
				   (others => '0')			when "00",  -- zeros
				   unaffected when others;

	PCout <= current_PC; 
	
process(clk)
    begin
		if rising_edge(clk) then
			report "///////////////////////////////PC debug/////////////////////////////////////////////"
			& LF & "current_PC = " & to_string(current_PC)
			& LF & "next_PC =  " & to_string(next_PC)
			& LF & "//////////////////////////////// End ///////////////////////////////////////////////";
		end if;
end process;

end PC_dataflow;
