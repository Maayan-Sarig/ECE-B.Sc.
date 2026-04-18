library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.aux_package.all;

-------------------------------------------------
entity opc_decoder is

	generic(opc_size: integer := 4);

	port(	IR_opc : in std_logic_vector(opc_size-1 downto 0);	
			st_op, ld_op, mov_op, done_op, add_op, sub_op, jmp_op, jc_op, jnc_op, and_op, or_op, xor_op,unused_op : out std_logic
	);
end opc_decoder;

--------------------------------------------------
architecture opc_dec_dataflow of opc_decoder is

begin

	add_op    <= '1' when IR_opc = "0000" else '0';
	sub_op    <= '1' when IR_opc = "0001" else '0';
	and_op    <= '1' when IR_opc = "0010" else '0';
	or_op     <= '1' when IR_opc = "0011" else '0';
	xor_op    <= '1' when IR_opc = "0100" else '0';
	jmp_op    <= '1' when IR_opc = "0111" else '0';
	jc_op     <= '1' when IR_opc = "1000" else '0';
	jnc_op    <= '1' when IR_opc = "1001" else '0';
	mov_op    <= '1' when IR_opc = "1100" else '0';
	ld_op     <= '1' when IR_opc = "1101" else '0';
	st_op     <= '1' when IR_opc = "1110" else '0';
	done_op   <= '1' when IR_opc = "1111" else '0';
	-- unused_op <='1' when IR_opc = '----' else '0';

end opc_dec_dataflow;