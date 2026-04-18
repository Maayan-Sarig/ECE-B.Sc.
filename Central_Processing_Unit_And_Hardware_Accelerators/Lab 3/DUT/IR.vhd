library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.aux_package.all;

-------------------------------------------------
entity IR is

	generic(word_size : integer := 16;
			field_size: integer := 4;
			imm_size  : integer := 8
			);

	port(	code_line       : in std_logic_vector(word_size - 1 downto 0);	
			IRin            : in std_logic;
			Ra, Rb, Rc, opc : out std_logic_vector(field_size - 1 downto 0);	
			long_imm        : out std_logic_vector(imm_size - 1 downto 0);	
			short_imm       : out std_logic_vector(field_size - 1 downto 0)
	);
end IR;

--------------------------------------------------
architecture IR_dataflow of IR is

	signal IR_sig   : std_logic_vector(word_size - 1 downto 0);
	signal opc_temp : std_logic_vector(field_size - 1 downto 0);
	
begin
	
	IR_sig    <= code_line when IRin = '1' else unaffected;
	opc_temp  <= IR_sig(word_size - 1 downto 12);

	
	Ra        <=  (others => '0') when (opc_temp = "0111" or opc_temp = "1000" or opc_temp = "1001") else
			      IR_sig(11 downto 8);

	Rb        <=   IR_sig(7 downto 4) when (opc_temp = "0000" or opc_temp = "0001" or opc_temp = "0010" or opc_temp = "0011" or opc_temp = "0100" 
	                                          or opc_temp = "1101" or opc_temp = "1110") else 
			       unaffected;
				   
	Rc        <=   IR_sig(3 downto 0) when (opc_temp = "0000" or opc_temp = "0001" or opc_temp = "0010" or opc_temp = "0011" or opc_temp = "0100") else 
			       unaffected;

	opc       <= opc_temp;
	short_imm <= IR_sig(field_size - 1 downto 0);
	long_imm  <= IR_sig(imm_size - 1 downto 0);
	
end IR_dataflow;