library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.aux_package.all;

-------------------------------------------------
entity DataPath is

	generic(mux_size: integer := 2; 
			ALUFN_size: integer := 4;
			word_size: integer := 16;
			immediate_short_size: integer := 4;
			immediate_long_size: integer := 8;
			memory_size   : integer := 6;
			dept:   integer:=64
			);


port(	
		DTCM_wr, DTCM_addr_sel, DTCM_addr_out, DTCM_addr_in, DTCM_out, Ain, RFin, RFout, IRin, PCin, Imm1_in, Imm2_in, rst_control  : in std_logic;
		RFaddr_rd, RFaddr_wr, PCsel : in std_logic_vector(mux_size - 1 downto 0);
		ALUFN                       : in std_logic_vector(ALUFN_size - 1 downto 0);
		st_op, ld_op, mov_op, done_op, add_op, sub_op, jmp_op, jc_op, jnc_op, and_op, or_op, xor_op, unused_op, Zflag, Nflag, Cflag : out std_logic;
		
		-- test ports
		clk                                              : in std_logic;
		ITCM_tb_wr                                       : in std_logic;
		ITCM_tb_in                                       : in std_logic_vector(word_size - 1 downto 0);
		ITCM_tb_addr_in                                  : in std_logic_vector(memory_size - 1 downto 0);
		DTCM_tb_wr, TBactive                             : in std_logic;
		DTCM_tb_in                                       : in std_logic_vector(word_size - 1 downto 0);
		DTCM_tb_addr_in, DTCM_tb_addr_out                : in std_logic_vector(memory_size - 1 downto 0);
		DTCM_tb_out                                      : out std_logic_vector(word_size - 1 downto 0)
);
end DataPath;

-------------------------------------------------
architecture Datapath_dataflow of DataPath is
	--IR
	signal immediate_1_IR                                          : std_logic_vector(immediate_long_size - 1 downto 0);
	signal immediate_2_IR                                          : std_logic_vector(immediate_short_size - 1 downto 0);
	signal Ra_IR, Rb_IR, Rc_IR, opc_IR                             : std_logic_vector(immediate_short_size - 1 downto 0);
	--RF 
	signal read_addr_RF, write_addr_RF                             : std_logic_vector(3 downto 0);
	signal data_in_RF, data_out_RF                                 : std_logic_vector(word_size - 1 downto 0);
	--Data Memory
	signal data_out_data_memory, data_in_data_memory               : std_logic_vector(word_size - 1 downto 0);
	signal wren_data_memory                                        : std_logic;
	signal read_addr_data_memory, write_addr_data_memory           : std_logic_vector(memory_size - 1 downto 0);
	signal read_addr_data_memory_prev, write_addr_data_memory_prev : std_logic_vector(word_size - 1 downto 0);
	
	--Program Mermory
	signal data_out_program_memory                                 : std_logic_vector(word_size - 1 downto 0);
	signal read_addr_program_memory                                : std_logic_vector(memory_size - 1 downto 0) := (others => '0');
	
	--ALU
	signal reg_A_ALU                                               : std_logic_vector(word_size - 1 downto 0);
	signal A_ALU, B_ALU,C_ALU                                      : std_logic_vector(word_size - 1 downto 0);
	signal Nflag_temp, Cflag_temp, Zflag_temp                      : std_logic;
	--Buses
	signal bus_A                                                   : std_logic_vector(word_size - 1 downto 0);
	signal bus_B                                                   : std_logic_vector(word_size - 1 downto 0);

	--Others 
	signal immediate_extended                                      : std_logic_vector(word_size - 1 downto 0);
	
begin

----------------------------------------------------------------------------------------------------

ALUModule:		ALU			generic map(word_size, ALUFN_size)	port map (A_ALU, B_ALU, ALUFN, opc_IR, Cflag, Zflag, Nflag, C_ALU);	
	
OPCdecModule:	opc_decoder generic map(ALUFN_size)				port map(opc_IR, st_op, ld_op, mov_op, done_op, add_op, sub_op, jmp_op, jc_op, jnc_op, and_op, or_op, xor_op,unused_op);

ProgMemModule:	ProgMem 	generic map(word_size, memory_size, dept)	port map (clk, ITCM_tb_wr, ITCM_tb_in, ITCM_tb_addr_in, read_addr_program_memory, data_out_program_memory);

PCLogicModule:	PC_unit 	generic map(immediate_long_size, memory_size) port map(immediate_1_IR, PCsel, PCin, clk, read_addr_program_memory);

IRModule:		IR			generic map(word_size, ALUFN_size, immediate_long_size)	port map(data_out_program_memory, IRin, Ra_IR, Rb_IR, Rc_IR, opc_IR, immediate_1_IR, immediate_2_IR);

DataMemModule:	dataMem 	generic map(word_size, memory_size, dept)	port map (clk, wren_data_memory, data_in_data_memory, write_addr_data_memory, read_addr_data_memory, data_out_data_memory);

RegFileModule:	RF			generic map(word_size, ALUFN_size)			port map (clk, rst_control, RFin, data_in_RF, write_addr_RF, read_addr_RF, data_out_RF);

---------------------------------------------------------------------------------------------------

RF_to_Bus_B          : BidirPin generic map(word_size) port map(data_out_RF, RFout, bus_B);
Data_Memory_to_Bus_B : BidirPin generic map(word_size) port map(data_out_data_memory, DTCM_out, bus_B);
Immediate_1_to_Bus_B : BidirPin generic map(word_size) port map(immediate_extended, Imm1_in, bus_B);
Immediate_2_to_Bus_B : BidirPin generic map(word_size) port map(immediate_extended, Imm2_in, bus_B);

---------------------------------------------------------------------------------------

	immediate_extended <= sxt(immediate_1_IR, word_size) when Imm1_in = '1' else
						  sxt(immediate_2_IR, word_size) when Imm2_in = '1' else
						  unaffected;
						  
---------------------------------------------------------------------------------------
	
	read_addr_RF       <= Ra_IR when RFaddr_rd = "00" else
						  Rb_IR when RFaddr_rd = "01" else
						  Rc_IR when RFaddr_rd = "10" else
						  unaffected;

	write_addr_RF      <= Ra_IR when RFaddr_wr = "00" else
						  Rb_IR when RFaddr_wr = "01" else
						  Rc_IR when RFaddr_wr = "10" else
						  unaffected;
						  
---------------------------------------------------------------------------------------
	
ALU_A_reload : process(clk)
	begin
		if(clk'event and clk = '1' and Ain = '1') then
			reg_A_ALU <= bus_A;
		end if;
	end process;

-------------Muxes-----------------------------------------------------------------

	read_addr_data_memory_prev  <= bus_A when (DTCM_addr_sel = '0' and DTCM_addr_out = '1') else
								   bus_B when (DTCM_addr_sel = '1' and DTCM_addr_out = '1') else
								   unaffected;

	write_addr_data_memory_prev <= bus_A when (DTCM_addr_sel = '0' and DTCM_addr_in = '1') else
								   bus_B when (DTCM_addr_sel = '1' and DTCM_addr_in = '1') else
								   unaffected;

	read_addr_data_memory       <= read_addr_data_memory_prev(memory_size - 1 downto 0) when (TBactive = '0') else
								   DTCM_tb_addr_out;

	write_addr_data_memory      <= write_addr_data_memory_prev(memory_size - 1 downto 0) when (TBactive = '0') else
								   DTCM_tb_addr_in;

	wren_data_memory            <= DTCM_wr when (TBactive = '0') else
								   DTCM_tb_wr;

	data_in_data_memory         <= bus_B when (TBactive = '0') else
								   DTCM_tb_in;
						
						
---------------------------------------------------------------------------------------

	DTCM_tb_out <= data_out_data_memory;
	bus_A       <= C_ALU;
	B_ALU       <= bus_B;
	A_ALU       <= reg_A_ALU;
	data_in_RF  <= bus_A;

process(clk)
    begin
		if rising_edge(clk) then
			report "***************************************New Cycle debug***********************************************"
			& LF & "time =      " & to_string(now) 
			& LF & "Immidiate = " & to_string(immediate_extended)
			& LF & "A =         " & to_string(A_ALU)
			& LF & "A =         " & to_string(A_ALU)
			& LF & "B =         " & to_string(B_ALU)
			& LF & "C =         " & to_string(C_ALU)
			& LF & "Cflag =     " & to_string(Cflag)
			& LF & "Nflag =     " & to_string(Nflag)
			& LF & "Zflag =     " & to_string(Zflag)			
			& LF & "OPC =       " & to_string(ALUFN)
			& LF & "IRop =                  " & to_string(opc_IR)
			& LF & "Ra_IR =                 " & to_string(Ra_IR)
			& LF & "Rb_IR =                 " & to_string(Rb_IR)
			& LF & "Rc_IR =                 " & to_string(Rc_IR)
			& LF & "Write Data to RF =      " & to_string(RFin) 
			& LF & "Read Data from RF =     " & to_string(RFout) 
			& LF & "RFaddr_rd =             " & to_string(RFaddr_rd) 
			& LF & "RFaddr_wr =             " & to_string(RFaddr_wr) 
			& LF & "BusA =                  " & to_string(Bus_A) 
			& LF & "BusB =                  " & to_string(bus_B) 
			& LF & "write_addr_data_memory_prev =" & to_string(write_addr_data_memory_prev)	
			& LF & "DTCM_addr_in ="           & to_string(DTCM_addr_in)	
			& LF & "DTCM_addr_out ="           & to_string(DTCM_addr_out)	
			& LF & "read_addr_data_memory_prev =" & to_string(read_addr_data_memory_prev)	
			& LF & "read_addr_data_memory =" & to_string(read_addr_data_memory)				
			& LF & "DTCM_addr_sel ="          & to_string(DTCM_addr_sel)			
			& LF & "write_addr_data_memory =" & to_string(write_addr_data_memory) 		
			& LF & "data_in_data_memory =   " & to_string(data_in_data_memory)
			& LF & "DTCM_wr =   " & to_string(DTCM_wr)
			& LF & "Ain =       " & to_string(Ain)
			& LF & "IRin =      " & to_string(IRin) 
			& LF & "PCin =      " & to_string(PCin) 
			& LF & "PCsel =     " & to_string(PCsel) 
			& LF & "Imm1_in =   " & to_string(Imm1_in) 
			& LF & "Imm2_in =   " & to_string(Imm2_in)
			& LF & "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ End @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@";
		end if;
end process;

end Datapath_dataflow;