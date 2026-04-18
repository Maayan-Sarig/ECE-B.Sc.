library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
---------------------------------------------------------
entity tb_Control is
	generic(mux_size: integer := 2; 
			ALUFN_size: integer := 4);
end tb_Control;
---------------------------------------------------------
architecture tb_Control_dataflow of tb_Control is
	signal	st_op, ld_op, mov_op, done_op, add_op, sub_op, jmp_op, jc_op, jnc_op, and_op, or_op, xor_op, unused_op, Zflag, Nflag, Cflag : std_logic;
	signal	rst, ena, clk 				: std_logic;
	signal	DTCM_wr, DTCM_addr_sel, DTCM_addr_out, DTCM_addr_in, DTCM_out, Ain, RFin, RFout, IRin, PCin, Imm1_in, Imm2_in,rst_control : std_logic;
	signal 	RFaddr_rd, RFaddr_wr, PCsel : std_logic_vector(mux_size - 1 downto 0);
	signal  ALUFN                       : std_logic_vector(ALUFN_size - 1 downto 0);
	signal  done                        : std_logic := '0';  
	
---------------------------------------------------------
begin
controltb: Control generic map(mux_size, ALUFN_size)	port map(st_op, ld_op, mov_op, done_op, add_op, sub_op, jmp_op, jc_op, jnc_op, and_op, or_op, xor_op, unused_op, Zflag, Nflag, Cflag,
																 rst, ena, clk, DTCM_wr, DTCM_addr_sel, DTCM_addr_out, DTCM_addr_in, DTCM_out, Ain, RFin, RFout, IRin, PCin, Imm1_in, Imm2_in,
																 rst_control, RFaddr_rd, RFaddr_wr, PCsel, ALUFN, done
																 );
	
rst_ch :process	
        begin
		  rst <='1','0' after 100 ns;
		  wait;
        end process; 
		
		
clk_ch :process
        begin
		  clk <= '1';
		  wait for 50 ns;
		  clk <= not clk;
		  wait for 50 ns;
        end process;
		
		ena <= '1';

---------------------------------------------------------
		
add_cmd : process
        begin
		  add_op <='0', '1' after 100 ns, '0' after 500 ns;
		  wait;
        end process; 
		
xor_cmd : process
        begin
		  xor_op <='0','1' after 500 ns, '0' after 900 ns;
		  wait;
        end process;
		
jnc_cmd : process
        begin
		  jnc_op <='0','1' after 900 ns, '0' after 1200 ns;
		  wait;
        end process;
		
jc_cmd : process
        begin
		  jc_op <='0','1' after 1200 ns, '0' after 1500 ns;
		  wait;
        end process;
		
jmp_cmd : process
        begin
		  jmp_op <='0','1' after 1500 ns, '0' after 1800 ns;
		  wait;
        end process;
		
sub_cmd : process
        begin
		  sub_op <='0','1' after 1800 ns, '0' after 2200 ns;
		  wait;
        end process;
		
mov_cmd : process
        begin
		  mov_op <='0','1' after 2200 ns, '0' after 2500 ns;
		  wait;
        end process;
		
ld_cmd : process
        begin
		  ld_op <='0','1' after 2500 ns, '0' after 3000 ns;
		  wait;
        end process;
		
st_cmd : process
        begin
		  st_op <='0','1' after 3000 ns, '0' after 3500 ns;
		  wait;
        end process;
		
or_cmd : process
        begin
		  or_op <='0','1' after 3500 ns, '0' after 3900 ns;
		  wait;
        end process;
		
and_cmd : process
        begin
		  and_op <='0','1' after 3900 ns, '0' after 4300 ns;
		  wait;
        end process;
		
done_cmd : process
        begin
		  done_op <='0','1' after 4300 ns, '0' after 4500 ns;
		  wait;
        end process;
		
end architecture tb_Control_dataflow;
