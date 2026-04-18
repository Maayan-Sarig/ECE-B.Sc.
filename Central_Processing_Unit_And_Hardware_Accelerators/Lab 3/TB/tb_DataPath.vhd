library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
use std.textio.all;
use IEEE.std_logic_textio.all;
---------------------------------------------------------
entity tb_DataPath is

	generic(mux_size             : integer := 2; 
			ALUFN_size           : integer := 4;
			word_size            : integer := 16;
			immediate_short_size : integer := 4;
			immediate_long_size  : integer := 8;
			memory_size          : integer := 6;
			dept                 : integer := 64
			);
	
	constant dataMemLocation: 	string(1 to 44) := "C:\hardware lab\lab3\DataFiles\DTCMinit2.txt";
	
	constant progMemLocation: 	string(1 to 44) := "C:\hardware lab\lab3\DataFiles\ITCMinit2.txt";
	
	constant dataMemResult:	 	string(1 to 39) := "C:\hardware lab\lab3\DataFiles\RES2.txt";
	
end tb_DataPath;
----------
architecture tb_DataPath_Dataflow of tb_DataPath is

signal  DTCM_wr, DTCM_addr_sel, DTCM_addr_out, DTCM_addr_in, DTCM_out, Ain, RFin, RFout, IRin, PCin, Imm1_in, Imm2_in, rst_control  : std_logic;
signal  RFaddr_rd, RFaddr_wr, PCsel : std_logic_vector(mux_size - 1 downto 0);
signal  ALUFN                       : std_logic_vector(ALUFN_size - 1 downto 0);
signal  st_op, ld_op, mov_op, done_op, add_op, sub_op, jmp_op, jc_op, jnc_op, and_op, or_op, xor_op, unused_op, Zflag, Nflag, Cflag : std_logic;
signal	done                                             : std_logic;
signal	clk                                              : std_logic;
signal	ITCM_tb_wr                                       : std_logic;
signal	ITCM_tb_in                                       : std_logic_vector(word_size - 1 downto 0);
signal	ITCM_tb_addr_in                                  : std_logic_vector(memory_size - 1 downto 0);
signal	DTCM_tb_wr, TBactive                             : std_logic;
signal	DTCM_tb_in                                       : std_logic_vector(word_size - 1 downto 0);
signal	DTCM_tb_addr_in, DTCM_tb_addr_out                : std_logic_vector(memory_size - 1 downto 0);
signal	DTCM_tb_out                                      : std_logic_vector(word_size - 1 downto 0);
signal  done_PM, done_DM   	                             : boolean;

begin 

DataPathUnit: Datapath generic map(mux_size, ALUFN_size, word_size, immediate_short_size, immediate_long_size, memory_size, dept)  
					   port map(DTCM_wr, DTCM_addr_sel, DTCM_addr_out, DTCM_addr_in, DTCM_out, Ain, RFin, RFout, IRin, PCin, Imm1_in, Imm2_in, rst_control,
					            RFaddr_rd, RFaddr_wr, PCsel, ALUFN, st_op, ld_op, mov_op, done_op, add_op, sub_op, jmp_op, jc_op, jnc_op, and_op, or_op, 
								xor_op, unused_op, Zflag, Nflag, Cflag, clk, ITCM_tb_wr, ITCM_tb_in, ITCM_tb_addr_in, DTCM_tb_wr, TBactive, DTCM_tb_in,                                     
								DTCM_tb_addr_in, DTCM_tb_addr_out, DTCM_tb_out);
													


---------------------------
gen_clk : process
	begin
	  clk <= '0';
	  wait for 50 ns;
	  clk <= not clk;
	  wait for 50 ns;
	end process;

-----------------------------
gen_rst : process
        begin
		  rst_control <='1','0' after 100 ns;
		  wait;
        end process;	
------------------------------
gen_TB : process
	begin
	 TBactive <= '1';
	 wait until done_PM and done_DM;  
	 TBactive <= '0';
	 wait until done = '1';  
	 TBactive <= '1';	
	end process;	
	
	
---------------------------------------------------------------
loadData: process 
		file      in_file_DM    : text open read_mode is dataMemLocation;
		variable  data_mem	    : std_logic_vector(word_size-1 downto 0);
		variable  good		    : boolean;
		variable  L 		    : line;
		variable  temp_address	: std_logic_vector(memory_size-1 downto 0) ;
	begin 
		done_DM <= false;
		temp_address := (others => '0');
		while not endfile(in_file_DM) loop
			readline(in_file_DM,L);
			hread(L,data_mem,good);
			next when not good;
			DTCM_tb_wr       <= '1';
			DTCM_tb_addr_in  <= temp_address;
			DTCM_tb_in       <= data_mem;
			wait until rising_edge(clk);
			temp_address := temp_address +1;
		end loop ;
		DTCM_tb_wr <= '0';
		done_DM    <= true;
		file_close(in_file_DM);
		wait;
	end process;
	
	
----------------------------------------------------------------------
LoadPM  : process 
		file      in_file_PM    : text open read_mode is progMemLocation;
		variable  data_mem	    : std_logic_vector(word_size-1 downto 0); 
		variable  good		    : boolean;
		variable  L 			: line;
		variable  temp_address  : std_logic_vector(memory_size-1 downto 0) ;
	begin 
		done_PM <= false;
		temp_address := (others => '0');
		while not endfile(in_file_PM) loop
			readline(in_file_PM,L);
			hread(L,data_mem,good);
			next when not good;
			ITCM_tb_wr      <= '1';
			ITCM_tb_addr_in <= temp_address;
			ITCM_tb_in      <= data_mem;
			wait until rising_edge(clk);
			temp_address := temp_address +1;
		end loop ;
		ITCM_tb_wr <= '0';
		done_PM    <= true;
		file_close(in_file_PM);
		wait;
	end process;


--------- Start Test Bench ---------------------
StartTb : process
	begin
	
		wait until done_PM and done_DM;  

------------- Reset ------------------------		
	 --reset
		wait until clk'EVENT and clk='1';
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
		
---------------------- Instruction For Load - C100-----------------------------		
-- Fetch
		
		wait until clk'EVENT and clk='1'; 
		
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
			
-- Decode
    	wait until clk'EVENT and clk='1'; 
		
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
			
------------- mov  ------------------------
-- I_state_mov
		wait until clk'EVENT and clk='1'; 
		
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
			
---------------------- Instruction For Load - C20E-----------------------------		
-- Fetch
		
		wait until clk'EVENT and clk='1'; 
		
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
			
-- Decode
    	wait until clk'EVENT and clk='1'; 
		
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
			
------------- mov  ------------------------
-- I_state_mov
		wait until clk'EVENT and clk='1'; 
		
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
---------------------- Instruction For Load - C31C-----------------------------		
-- Fetch
		
		wait until clk'EVENT and clk='1'; 
		
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
			
-- Decode
    	wait until clk'EVENT and clk='1'; 
		
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
			
------------- mov  ------------------------
-- I_state_mov
		wait until clk'EVENT and clk='1'; 
		
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

---------------------- Instruction For Load - C400-----------------------------		
-- Fetch
		
		wait until clk'EVENT and clk='1'; 
		
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
			
-- Decode
    	wait until clk'EVENT and clk='1'; 
		
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
			
------------- mov  ------------------------
-- I_state_mov
		wait until clk'EVENT and clk='1'; 
		
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

---------------------- Instruction For Load - C501-----------------------------		
-- Fetch
		
		wait until clk'EVENT and clk='1'; 
		
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
			
-- Decode
    	wait until clk'EVENT and clk='1'; 
		
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
			
------------- mov  ------------------------
-- I_state_mov
		wait until clk'EVENT and clk='1'; 
		
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

---------------------- Instruction For Load - C60E-----------------------------		
-- Fetch
		
		wait until clk'EVENT and clk='1'; 
		
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
			
-- Decode
    	wait until clk'EVENT and clk='1'; 
		
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
			
------------- mov  ------------------------
-- I_state_mov
		wait until clk'EVENT and clk='1'; 
		
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

---------------------- Instruction For Load - D710-----------------------------		
-- Fetch
		
		wait until clk'EVENT and clk='1'; 
		
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
			
-- Decode
    	wait until clk'EVENT and clk='1'; 
		
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
			
------------- LD  ------------------------
-- I_state_ld_st_0
		wait until clk'EVENT and clk='1'; 
		
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
			
----------------------------------------------------------------

		wait until clk'EVENT and clk='1'; 
		
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
			
----------------------------------------------------------------

		wait until clk'EVENT and clk='1'; 
		
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
			
---------------------- Instruction For Load - D820-----------------------------		
-- Fetch
		
		wait until clk'EVENT and clk='1'; 
		
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
			
-- Decode
    	wait until clk'EVENT and clk='1'; 
		
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
			
------------- LD  ------------------------
-- I_state_ld_st_0
		wait until clk'EVENT and clk='1'; 
		
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
			
----------------------------------------------------------------

		wait until clk'EVENT and clk='1'; 
		
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
			
----------------------------------------------------------------

		wait until clk'EVENT and clk='1'; 
		
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
			
---------------------- Instruction For Load - 0978-----------------------------		
-- Fetch
		
		wait until clk'EVENT and clk='1'; 
		
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
			
-- Decode
		wait until clk'EVENT and clk='1'; 
		
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

-- R_state_0

		wait until clk'EVENT and clk='1'; 
		
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
			
-- R_state_1

		wait until clk'EVENT and clk='1'; 

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
			ALUFN 		   <= "0000";   
			done           <= '0';
			rst_control    <= '0';

---------------------- Instruction For Load - E930-----------------------------		
-- Fetch
		
		wait until clk'EVENT and clk='1'; 
		
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
			
-- Decode
    	wait until clk'EVENT and clk='1'; 
		
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
			
------------- LD  ------------------------
-- I_state_ld_st_0

		wait until clk'EVENT and clk='1'; 
		
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
			
----------------------------------------------------------------

		wait until clk'EVENT and clk='1'; 
		
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
			
----------------------------------------------------------------

		wait until clk'EVENT and clk='1'; 
		
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

---------------------- Instruction For Load - F000-----------------------------		
-- Fetch
		
		wait until clk'EVENT and clk='1'; 
		
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
			
-- Decode
    	wait until clk'EVENT and clk='1'; 
		
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
			PCsel          <= "10";
			ALUFN          <= "ZZZZ";    
			done           <= '1';
			rst_control    <= '0';	

	end process;
			
saveData: process 
		file       out_file_DM  : text open write_mode is dataMemResult;
		variable   L 			: line;
		variable   temp_address	: std_logic_vector(memory_size-1 downto 0) ; 
		variable   count		: integer;
	begin 
		wait until done = '1';  
		temp_address := (others => '0');
		count := 1;
		while count < 42 loop
			DTCM_tb_addr_out <= temp_address;
			wait until rising_edge(clk);
			wait until rising_edge(clk);
			hwrite(L,DTCM_tb_out);
			writeline(out_file_DM,L);
			temp_address := temp_address +1;
			count := count +1;
		end loop ;
		file_close(out_file_DM);
		wait;
	end process;


end tb_DataPath_Dataflow;
