library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.aux_package.all;

-------------------------------------------------
entity Control is

generic(mux_size: integer := 2; 
	    ALUFN_size: integer := 4);

port(	st_op, ld_op, mov_op, done_op, add_op, sub_op, jmp_op, jc_op, jnc_op, and_op, or_op, xor_op, unused_op, Zflag, Nflag, Cflag : in std_logic;
		rst, ena, clk                                                                                                               : in std_logic;
		DTCM_wr, DTCM_addr_sel, DTCM_addr_out, DTCM_addr_in, DTCM_out, Ain, RFin, RFout, IRin, PCin, Imm1_in, Imm2_in,rst_control   : out std_logic;
		RFaddr_rd, RFaddr_wr, PCsel : out std_logic_vector(mux_size - 1 downto 0);
		ALUFN                       : out std_logic_vector(ALUFN_size - 1 downto 0);
		done                        : out std_logic
		
);
end Control;

--------------------------------------------------
architecture Control_dataflow of Control is 


	type state is(Fetch, 
				  Decode,
				  R_state_0, R_state_1,
				  J_state,
				  I_state_mov, I_state_ld_st_0, I_state_ld_1, I_state_ld_2, I_state_st_1, I_state_st_2,
				  Reset
	);
	signal current_state, next_state : state;
	
begin
	sync_states : process (clk, rst)
	begin
		if(rst = '1') then
			current_state <= Reset;
		elsif(clk'event and clk = '1' and ena = '1') then
			current_state <= next_state;
		end if;
	end process;
	
FSM_run : process(current_state, next_state, st_op, ld_op, mov_op, done_op, add_op, sub_op, jmp_op, jc_op, jnc_op, and_op, or_op, xor_op, unused_op)
	begin 
		case current_state is 
		
-------------------------------------------------------		
		when Reset =>
		if done_op = '0' then
			DTCM_wr        <= '0';
			DTCM_addr_sel  <= '0';
			DTCM_addr_out  <= '0';
			DTCM_addr_in   <= '0';
			DTCM_out       <= '0';
			Ain            <= '0';
			RFin           <= '0';
			RFout          <= '0';
			IRin           <= '0';
			PCin           <= '1';
			Imm1_in        <= '0';
			Imm2_in        <= '0';
			RFaddr_rd      <= "11";
			RFaddr_wr      <= "11";
			PCsel          <= "00";
			ALUFN          <= "ZZZZ";    
			done           <= '0';
			rst_control    <= '1';
			
			next_state     <= Fetch;
		end if;
--------------------------------------------------------			
		when Fetch =>
		
			DTCM_wr        <= '0';
			DTCM_addr_sel  <= '0';
			DTCM_addr_out  <= '0';
			DTCM_addr_in   <= '0';
			DTCM_out       <= '0';
			Ain            <= '0';
			RFin           <= '0';
			RFout          <= '0';
			IRin           <= '1';
			PCin           <= '1';
			Imm1_in        <= '0';
			Imm2_in        <= '0';
			RFaddr_rd      <= "11";
			RFaddr_wr      <= "11";
			PCsel          <= "10";
			ALUFN          <= "ZZZZ";    
			done           <= '0';
			rst_control    <= '0';

			next_state     <= Decode;

-----------------------------------------------------------		
		when Decode =>
		
			DTCM_wr        <= '0';
			DTCM_addr_sel  <= '0';
			DTCM_addr_out  <= '0';
			DTCM_addr_in   <= '0';
			DTCM_out       <= '0';
			Ain            <= '0';
			RFin           <= '0';
			RFout          <= '0';
			IRin           <= '0';
			PCin           <= '0';
			Imm1_in        <= '0';
			Imm2_in        <= '0';
			RFaddr_rd      <= "11";
			RFaddr_wr      <= "11";
			PCsel          <= "10";
			ALUFN          <= "ZZZZ";    
			done           <= '0';
			rst_control    <= '0';
			
			if (done_op = '1') then
				done       <= '1';
				PCin	   <= '1';
				next_state <= Fetch;
			elsif (add_op = '1' or sub_op = '1' or or_op = '1' or and_op = '1' or xor_op = '1') then
				next_state <= R_state_0;
			elsif (jmp_op = '1' or jc_op = '1' or jnc_op = '1') then
				next_state <= J_state;
			elsif (mov_op = '1') then
				next_state <= I_state_mov;
			elsif (ld_op = '1') then
				next_state <= I_state_ld_st_0;
			elsif (ld_op ='1' or st_op = '1') then
				next_state <= I_state_ld_st_0;	
			else 
				next_state <= Fetch;
			end if;
			
------------------------------------------------------------			
			
		when R_state_0 =>
		
			DTCM_wr        <= '0';
			DTCM_addr_sel  <= '0';
			DTCM_addr_out  <= '0';
			DTCM_addr_in   <= '0';
			DTCM_out       <= '0';
			Ain            <= '1';
			RFin           <= '0';
			RFout          <= '1';
			IRin           <= '0';
			PCin           <= '0';
			Imm1_in        <= '0';
			Imm2_in        <= '0';
			RFaddr_rd      <= "01"; -- Rb
			RFaddr_wr      <= "11";
			PCsel          <= "10";
			ALUFN          <= "0101"; --B = C 
			done           <= '0';
			rst_control    <= '0';
			
			next_state <= R_state_1;
			
---------------------------------------------------------------

		when R_state_1 =>
		
			DTCM_wr        <= '0';
			DTCM_addr_sel  <= '0';
			DTCM_addr_out  <= '0';
			DTCM_addr_in   <= '0';
			DTCM_out       <= '0';
			Ain            <= '0';
			RFin           <= '1';
			RFout          <= '1';
			IRin           <= '0';
			PCin           <= '0';
			Imm1_in        <= '0';
			Imm2_in        <= '0';
			RFaddr_rd      <= "10"; -- Rc
			RFaddr_wr      <= "00"; -- Ra
			PCsel          <= "10";
			if(add_op = '1') then
				ALUFN <= "0000";   
			elsif(sub_op = '1') then
				ALUFN <= "0001";
			elsif(and_op = '1') then
				ALUFN <= "0010";  	
			elsif(or_op = '1') then
				ALUFN <= "0011";  	
			elsif(xor_op = '1') then
				ALUFN <= "0100";  	
			else
				ALUFN <= "ZZZZ";
			end if;
			done           <= '0';
			rst_control    <= '0';
			
			next_state <= Fetch;
------------------------------------------------------------

		when J_state =>
		
			DTCM_wr        <= '0';
			DTCM_addr_sel  <= '0';
			DTCM_addr_out  <= '0';
			DTCM_addr_in   <= '0';
			DTCM_out       <= '0';
			Ain            <= '0';
			RFin           <= '0';
			RFout          <= '0';
			IRin           <= '0';
			PCin           <= '0';
			Imm1_in        <= '0';
			Imm2_in        <= '0';
			RFaddr_rd      <= "11";
			RFaddr_wr      <= "11";
			if(jmp_op = '1') then
				PCsel <= "01";
				PCin  <= '1';
			elsif(jc_op = '1' and Cflag = '1') then
				PCsel <= "01";
				PCin  <= '1';				
			elsif(jnc_op = '1' and Cflag = '0') then
				PCsel <= "01";  
				PCin  <= '1';				
			else
				PCsel <= "10";
			end if;
			ALUFN          <= "ZZZZ";
			done           <= '0';
			rst_control    <= '0';
			
			next_state <= Fetch;
----------------------------------------------------------------

		when I_state_mov =>
		
			DTCM_wr        <= '0';
			DTCM_addr_sel  <= '0';
			DTCM_addr_out  <= '0';
			DTCM_addr_in   <= '0';
			DTCM_out       <= '0';
			Ain            <= '0';
			RFin           <= '1';
			RFout          <= '0';
			IRin           <= '0';
			PCin           <= '0';
			Imm1_in        <= '1';
			Imm2_in        <= '0';
			RFaddr_rd      <= "11";
			RFaddr_wr      <= "00"; -- Ra
			PCsel          <= "10";
			ALUFN          <= "0101"; -- B = C
			done           <= '0';
			rst_control    <= '0';
			
			next_state <= Fetch;

----------------------------------------------------------------

		when I_state_ld_st_0 =>
		
			DTCM_wr        <= '0';
			DTCM_addr_sel  <= '0';
			DTCM_addr_out  <= '0';
			DTCM_addr_in   <= '0';
			DTCM_out       <= '0';
			Ain            <= '1';
			RFin           <= '0';
			RFout          <= '0';
			IRin           <= '0';
			PCin           <= '0';
			Imm1_in        <= '0';
			Imm2_in        <= '1';
			RFaddr_rd      <= "11";
			RFaddr_wr      <= "11";
			PCsel          <= "10";
			ALUFN          <= "0101"; -- B = C
			done           <= '0';
			rst_control    <= '0';
			
			if(st_op = '1') then
				next_state <= I_state_st_1;
			elsif(ld_op = '1') then
				next_state <= I_state_ld_1;
			else
				next_state <= Fetch;
			end if;
----------------------------------------------------------------

		when I_state_ld_1 =>
		
			DTCM_wr        <= '0';
			DTCM_addr_sel  <= '0'; -- Bus A (after add)
			DTCM_addr_out  <= '1'; 
			DTCM_addr_in   <= '0';
			DTCM_out       <= '0';
			Ain            <= '0';
			RFin           <= '0';
			RFout          <= '1';
			IRin           <= '0';
			PCin           <= '0';
			Imm1_in        <= '0';
			Imm2_in        <= '0';
			RFaddr_rd      <= "01"; --Rb
			RFaddr_wr      <= "11";
			PCsel          <= "10";
			ALUFN          <= "0000"; -- ADD
			done           <= '0';
			rst_control    <= '0';
			
			next_state <= I_state_ld_2;
----------------------------------------------------------------

		when I_state_ld_2 =>
		
			DTCM_wr        <= '0';
			DTCM_addr_sel  <= '0';
			DTCM_addr_out  <= '0'; 
			DTCM_addr_in   <= '0';
			DTCM_out       <= '1';
			Ain            <= '0';
			RFin           <= '1';
			RFout          <= '0';
			IRin           <= '0';
			PCin           <= '0';
			Imm1_in        <= '0';
			Imm2_in        <= '0';
			RFaddr_rd      <= "11";
			RFaddr_wr      <= "00"; -- Ra
			PCsel          <= "10";
			ALUFN          <= "0101"; -- B = C
			done           <= '0';
			rst_control    <= '0';
			
			next_state <= Fetch;		
----------------------------------------------------------------

		when I_state_st_1 =>
		
			DTCM_wr        <= '0';
			DTCM_addr_sel  <= '0'; -- Bus A (after add)
			DTCM_addr_out  <= '0'; 
			DTCM_addr_in   <= '1';
			DTCM_out       <= '0';
			Ain            <= '0';
			RFin           <= '0';
			RFout          <= '1';
			IRin           <= '0';
			PCin           <= '0';
			Imm1_in        <= '0';
			Imm2_in        <= '0';
			RFaddr_rd      <= "01"; -- Rb
			RFaddr_wr      <= "11";
			PCsel          <= "10";
			ALUFN          <= "0000"; -- ADD
			done           <= '0';
			rst_control    <= '0';
			
			next_state <= I_state_st_2;			
----------------------------------------------------------------

		when I_state_st_2 =>
		
			DTCM_wr        <= '1';
			DTCM_addr_sel  <= '0';
			DTCM_addr_out  <= '0'; 
			DTCM_addr_in   <= '0';
			DTCM_out       <= '0';
			Ain            <= '0';
			RFin           <= '0';
			RFout          <= '1';
			IRin           <= '0';
			PCin           <= '0';
			Imm1_in        <= '0';
			Imm2_in        <= '0';
			RFaddr_rd      <= "00"; --Ra
			RFaddr_wr      <= "11";
			PCsel          <= "10";
			ALUFN          <= "ZZZZ";
			done           <= '0';
			rst_control    <= '0';
			
			next_state <= Fetch;	
	end case;
end process;

process(clk)
    begin
		if rising_edge(clk) then
			report "$$$$$$$$$$$$$$$$$$$$$$$$$control debug$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"
			& LF & "done = " & to_string(done)
			& LF & "ena =  " & to_string(ena)
			& LF & "ena =  " & to_string(current_state)
			& LF & "$$$$$$$$$$$$$$$$$$$$$$$$$ End $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$";
		end if;
end process;

end Control_dataflow;