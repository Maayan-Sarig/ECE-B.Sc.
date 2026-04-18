library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.aux_package.all;

-------------------------------------------------
entity top is

	generic(mux_size             : integer := 2;
			ALUFN_size           : integer := 4;
			word_size            : integer := 16;
			memory_size          : integer := 6;
			immediate_short_size : integer := 4;
			immediate_long_size  : integer := 8;
			dept                 : integer := 64
			);

	port(	rst, ena, clk                                    : in  std_logic;	
			ITCM_tb_wr                                       : in std_logic;
			ITCM_tb_in                                       : in std_logic_vector(word_size - 1 downto 0);
			ITCM_tb_addr_in                                  : in std_logic_vector(memory_size - 1 downto 0);
			DTCM_tb_wr, TBactive                             : in std_logic;
			DTCM_tb_addr_in, DTCM_tb_addr_out                : in std_logic_vector(memory_size - 1 downto 0);
			DTCM_tb_in                                       : in std_logic_vector(word_size - 1 downto 0);
			done                                             : out std_logic;
			DTCM_tb_out                                      : out std_logic_vector(word_size - 1 downto 0)
	);
end top;

--------------------------------------------------
architecture top_dataflow of top is

	signal DTCM_wr, DTCM_addr_sel, DTCM_addr_out, DTCM_addr_in, DTCM_out, Ain, RFin, RFout, IRin, PCin, Imm1_in, Imm2_in,rst_control : std_logic ;
	signal RFaddr_rd, RFaddr_wr, PCsel : std_logic_vector(mux_size - 1 downto 0);
	signal ALUFN                       : std_logic_vector(ALUFN_size - 1 downto 0);
	signal st_op, ld_op, mov_op, done_op, add_op, sub_op, jmp_op, jc_op, jnc_op, and_op, or_op, xor_op, unused_op, Zflag, Nflag, Cflag : std_logic;

begin

control_signals :  Control generic map(mux_size, ALUFN_size) port map(st_op, ld_op, mov_op, done_op, add_op, sub_op, jmp_op, jc_op, jnc_op, and_op, or_op, xor_op, unused_op, Zflag, Nflag, Cflag,
																	  rst, ena, clk, DTCM_wr, DTCM_addr_sel, DTCM_addr_out, DTCM_addr_in, DTCM_out, Ain, RFin, RFout, IRin, PCin, Imm1_in, Imm2_in,
																	  rst_control, RFaddr_rd, RFaddr_wr, PCsel, ALUFN, done);
	
datapath_signals : DataPath generic map(mux_size, ALUFN_size, word_size, immediate_short_size, immediate_long_size, memory_size, dept) 
						      port map(DTCM_wr, DTCM_addr_sel, DTCM_addr_out, DTCM_addr_in, DTCM_out, Ain, RFin, RFout, IRin, PCin, Imm1_in, Imm2_in, rst_control,
							           RFaddr_rd, RFaddr_wr, PCsel, ALUFN, st_op, ld_op, mov_op, done_op, add_op, sub_op, jmp_op, jc_op, jnc_op, and_op, or_op, 
									   xor_op, unused_op, Zflag, Nflag, Cflag, clk, ITCM_tb_wr, ITCM_tb_in, ITCM_tb_addr_in, DTCM_tb_wr, TBactive, DTCM_tb_in,
									   DTCM_tb_addr_in, DTCM_tb_addr_out, DTCM_tb_out);	

end top_dataflow;