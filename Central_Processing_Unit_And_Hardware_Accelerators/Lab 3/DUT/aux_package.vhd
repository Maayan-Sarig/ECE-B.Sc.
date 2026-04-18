library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------
package aux_package is

-------------------------------------------------
	component Control is

	generic(mux_size: integer := 2; 
			ALUFN_size: integer := 4);

	port(	st_op, ld_op, mov_op, done_op, add_op, sub_op, jmp_op, jc_op, jnc_op, and_op, or_op, xor_op, unused_op, Zflag, Nflag, Cflag : in std_logic;
			rst, ena, clk                                                                                                               : in std_logic;
			DTCM_wr, DTCM_addr_sel, DTCM_addr_out, DTCM_addr_in, DTCM_out, Ain, RFin, RFout, IRin, PCin, Imm1_in, Imm2_in,rst_control   : out std_logic;
			RFaddr_rd, RFaddr_wr, PCsel : out std_logic_vector(mux_size - 1 downto 0);
			ALUFN                       : out std_logic_vector(ALUFN_size - 1 downto 0);
			done                        : out std_logic
			
	);
	end component;
	
-------------------------------------------------	
	component opc_decoder is

	generic(opc_size: integer := 4);

	port(	IR_opc : in std_logic_vector(opc_size-1 downto 0);	
			st_op, ld_op, mov_op, done_op, add_op, sub_op, jmp_op, jc_op, jnc_op, and_op, or_op, xor_op,unused_op : out std_logic
	);
	end component;
	
-------------------------------------------------	
	component IR is

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
	end component;

-------------------------------------------------
	
	component PC_unit is

	generic(immediate_size: integer := 8;
			memory_size   : integer := 6
	        );

	port(	IR_immediate : in std_logic_vector(immediate_size-1 downto 0);	
			PCsel        : in std_logic_vector(1 downto 0);	
			PCin, clk    : in std_logic;
			PCout        : out std_logic_vector(memory_size - 1 downto 0)
	);
	end component;
	
-------------------------------------------------
	
	component ALU is

	generic(word_size: integer := 16 ;
			ALUFN_size: integer := 4);

	port(	A, B                : in std_logic_vector(word_size-1 downto 0);	
			ALUFN, current_opc  : in std_logic_vector(ALUFN_size-1 downto 0);	
			Cflag, Zflag, Nflag : out std_logic;	
			C                   : out std_logic_vector(word_size-1 downto 0)
	);
	end component;
	
-------------------------------------------------

	component FA IS
	PORT (xi, yi, cin: IN std_logic;
			  s, cout: OUT std_logic);
	end component;

-------------------------------------------------
	component DataPath is

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
	end component;

-------------------------------------------------

	component top is

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
	end component;
	
-------------------------------------------------

	component ProgMem is
	generic( Dwidth: integer:=16;
			 Awidth: integer:=6;
			 dept:   integer:=64);
	port(	clk,memEn           : in std_logic;	
			WmemData            : in std_logic_vector(Dwidth-1 downto 0);
			WmemAddr,RmemAddr   : in std_logic_vector(Awidth-1 downto 0);
			RmemData            : out std_logic_vector(Dwidth-1 downto 0)
	);
	end component;
	
-------------------------------------------------	
	
	component RF is
	generic( Dwidth: integer:=16;
			 Awidth: integer:=4);
	port(	clk,rst,WregEn   :  in std_logic;	
			WregData         :	in std_logic_vector(Dwidth-1 downto 0);
			WregAddr,RregAddr:	in std_logic_vector(Awidth-1 downto 0);
			RregData         : 	out std_logic_vector(Dwidth-1 downto 0)
	);
	end component;

-------------------------------------------------
	
	component dataMem is
	generic( Dwidth: integer:=16;
			 Awidth: integer:=6;
			 dept:   integer:=64);
	port(	clk,memEn: in std_logic;	
			WmemData:	in std_logic_vector(Dwidth-1 downto 0);
			WmemAddr,RmemAddr:	
						in std_logic_vector(Awidth-1 downto 0);
			RmemData: 	out std_logic_vector(Dwidth-1 downto 0)
	);
	end component;
	
-------------------------------------------------	
	
		component BidirPin is
	generic( width: integer:=16 );
	port(   Dout: 	in 		std_logic_vector(width-1 downto 0);
			en:		in 		std_logic;
			IOpin: 	inout 	std_logic_vector(width-1 downto 0)
	);
	end component;

-------------------------------------------------
		
end aux_package;
