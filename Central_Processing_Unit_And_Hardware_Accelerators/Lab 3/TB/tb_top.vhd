library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
use std.textio.all;
use IEEE.STD_LOGIC_TEXTIO.all;

---------------------------------------------------------
entity top_tb is

	constant mux_size             : integer := 2;
	constant ALUFN_size           : integer := 4;
	constant word_size            : integer := 16;
	constant memory_size          : integer := 6;
	constant immediate_short_size : integer := 4;
	constant immediate_long_size  : integer := 8;
	constant dept                 : integer := 64;

	constant dataMemLocation: 	string(1 to 44) := "C:\hardware lab\lab3\DataFiles\DTCMinit4.txt";
	
	constant progMemLocation: 	string(1 to 44) := "C:\hardware lab\lab3\DataFiles\ITCMinit4.txt";
	
	constant dataMemResult:	 	string(1 to 39) := "C:\hardware lab\lab3\DataFiles\RES4.txt";
	
end top_tb;
---------------------------------------------------------
architecture top_tb_dataflow of top_tb is

	signal	rst, ena, clk                                  : std_logic;	
	signal	ITCM_tb_wr                                     : std_logic;
	signal	ITCM_tb_in                                     : std_logic_vector(word_size - 1 downto 0);
	signal	ITCM_tb_addr_in                                : std_logic_vector(memory_size - 1 downto 0);
	signal	DTCM_tb_wr, TBactive                           : std_logic;
	signal	DTCM_tb_addr_in, DTCM_tb_addr_out              : std_logic_vector(memory_size - 1 downto 0);
	signal  DTCM_tb_in                                     : std_logic_vector(word_size - 1 downto 0);
	signal	done                                           : std_logic;
	signal	DTCM_tb_out                                    : std_logic_vector(word_size - 1 downto 0);
	signal  done_PM, done_DM   	                           : boolean;
	
begin
	
top_define : top generic map(mux_size, ALUFN_size, word_size, memory_size, immediate_short_size, immediate_long_size, dept)
                 port map (rst, ena, clk, ITCM_tb_wr, ITCM_tb_in, ITCM_tb_addr_in, DTCM_tb_wr, TBactive, DTCM_tb_addr_in, DTCM_tb_addr_out, DTCM_tb_in,
		             done, DTCM_tb_out);
						
    
-------------------------------------
	gen_rst : process
	begin
	  rst <='1','0' after 100 ns;
	  wait;
	end process;
	
-------------------------------------
	gen_clk : process
	begin
	  clk <= '0';
	  wait for 50 ns;
	  clk <= not clk;
	  wait for 50 ns;
	end process;
	
---------------------------------------
	gen_TB : process
        begin
		 TBactive <= '1';
		 wait until done_PM and done_DM;  
		 TBactive <= '0';
		 wait until done = '1';  
		 TBactive <= '1';	
        end process;	
	
				
				
	----------- Data memory --------------
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
		
		
	----------- Program memory --------------
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
	

	ena <= '1' when (done_DM and done_PM) else '0';
	
		
	------------------------ Writing ---------------------
saveData: process 
		file       out_file_DM  : text open write_mode is dataMemResult;
		variable   L 			: line;
		variable   temp_address	: std_logic_vector(memory_size-1 downto 0) ; 
		variable   count		: integer;
	begin 
		wait until done = '1';  
		temp_address := (others => '0');
		count := 1;
		while count < 43 loop
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
		

end architecture top_tb_dataflow;

