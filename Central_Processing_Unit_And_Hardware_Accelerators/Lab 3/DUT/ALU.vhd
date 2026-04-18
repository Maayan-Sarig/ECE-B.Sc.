library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.aux_package.all;

-------------------------------------------------
entity ALU is

generic(word_size: integer := 16 ;
        ALUFN_size: integer := 4);

port(	A, B                : in std_logic_vector(word_size-1 downto 0);	
		ALUFN, current_opc  : in std_logic_vector(ALUFN_size-1 downto 0);	
		Cflag, Zflag, Nflag : out std_logic;	
		C                   : out std_logic_vector(word_size-1 downto 0)
);
end ALU;

--------------------------------------------------
architecture ALU_dataflow of ALU is

	signal C_sig_add_sub, C_sig_logic, c_temp     : std_logic_vector(word_size-1 downto 0) := (others => '0');
	signal carry_sig                              : std_logic_vector(word_size downto 0) := (others => '0');
	signal A_sig, A_logic, B_sig, B_logic, B_eqC  : std_logic_vector(word_size-1 downto 0);
	constant zeroes                               : std_logic_vector(word_size-1 downto 0) := (others => '0');
	constant ones                                 : std_logic_vector(word_size-1 downto 0) := (others => '1');
 
begin

	A_sig   <= A;
	A_logic <= A;
	B_logic <= B;
	B_eqC   <= B;
	
	b_sig   <= B xor ones when ALUFN = "0001" else
			   B;
		
	carry_sig(0) <= '1' when ALUFN = "0001" else 
					'0';
	
	first : FA port map(A_sig(0), B_sig(0), carry_sig(0), C_sig_add_sub(0), carry_sig(1));
	
	FA_conect : for i in 1 to word_size-1 generate
		conecctions : FA port map(A_sig(i), B_sig(i), carry_sig(i), C_sig_add_sub(i), carry_sig(i+1));
	end generate FA_conect;

	B_eqC <= B when ALUFN = "0101" else (others => '0');  -- B=C

	C_sig_logic <= A_logic and B_logic when ALUFN = "0010" else
				   A_logic or  B_logic when ALUFN = "0011" else
	               A_logic xor B_logic when ALUFN = "0100" else
				   (others => '0');

	Zflag <= '1' when (C_sig_add_sub = zeroes) and (ALUFN = "0000" or ALUFN = "0001") and (current_opc = "0000" or current_opc = "0001") else
			 '0' when (C_sig_add_sub /= zeroes) and (ALUFN = "0000" or ALUFN = "0001") and (current_opc = "0000" or current_opc = "0001") else
		     '1' when (C_sig_logic = zeroes) and (ALUFN = "0010" or ALUFN = "0011" or ALUFN = "0100") and (current_opc = "0010" or current_opc = "0011"or current_opc = "0100") else
			 '0' when (C_sig_logic /= zeroes) and (ALUFN = "0010" or ALUFN = "0011" or ALUFN = "0100") and (current_opc = "0010" or current_opc = "0011"or current_opc = "0100") else
			 unaffected;

	Nflag <= C_sig_add_sub(word_size - 1) when (ALUFN = "0000" or ALUFN = "0001") and (current_opc = "0000" or current_opc = "0001") else
			 C_sig_logic(word_size - 1) when (ALUFN = "0010" or ALUFN = "0011" or ALUFN = "0100") and (current_opc = "0010" or current_opc = "0011"or current_opc = "0100") else
		     unaffected;
			 
    Cflag <= carry_sig(word_size) when (ALUFN = "0000" or ALUFN = "0001") and (current_opc = "0000" or current_opc = "0001") else
			 unaffected;
	
	C     <= C_sig_add_sub when (ALUFN = "0000" or ALUFN = "0001")                   else
		     C_sig_logic   when (ALUFN = "0010" or ALUFN = "0011" or ALUFN = "0100") else
			 B_eqC         when  ALUFN = "0101"                                      else  -- using "0101" to activate b=c for background 
			 (others => 'Z');

process(ALUFN)
    begin
		if (ALUFN = "0000" or ALUFN = "0001") then
			report "###########ALU Debug############################################################"
			& LF & "A =   " & to_string(A)
			& LF & "B =   " & to_string(B)
			& LF & "C_sig_add_sub =   " & to_string(C_sig_add_sub)
			& LF & "C =   " & to_string(C)
			& LF & "C_sig_logic =   " & to_string(C_sig_logic)			
			& LF & "ALUFN =   " & to_string(ALUFN);
		end if;
end process;
end ALU_dataflow;