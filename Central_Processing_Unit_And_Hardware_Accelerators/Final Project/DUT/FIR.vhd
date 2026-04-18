LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.all;
USE work.const_package.all;
USE work.aux_package.all;


ENTITY FIR IS
   PORT( 	
		FIRIN_i 							 : in  std_logic_vector(31 downto 0);
		FIFORST_i, FIFOCLK_i, FIFOWEN_i		 : in  std_logic;
		FIRCLK_i, FIRRST_i, FIRENA_i      	 : in  std_logic;
		COEF0_i, COEF1_i, COEF2_i, COEF3_i	 : in  std_logic_vector(7 downto 0);
		COEF4_i, COEF5_i, COEF6_i, COEF7_i   : in  std_logic_vector(7 downto 0);
		FIROUT_read_DataBus_ctrl_i           : in  std_logic;
		GIE_i                                : in  std_logic;
		CLR_IRQ_r_i                          : in  std_logic_vector(7 downto 0);
		FIRIFG_o           					 : out std_logic;
		FIFOFULL_o, FIFOEMPTY_o				 : out std_logic;
		FIROUT_o                     		 : out std_logic_vector(31 downto 0)
	);
END FIR;

ARCHITECTURE behavior OF FIR IS

	signal  FIFOREN_w		    				  								    : std_logic := '0';
	signal  Din_Pulse_Sync_w 														: std_logic := '0';
	signal  Ds_Pulse_Sync_w, Dout_Pulse_Sync_w, D_zubi_sync_w  					    : std_logic := '0';
	signal  read_data_FIFO_w 														: std_logic_vector(23 downto 0);
	signal  x_n_0_w, x_n_1_w, x_n_2_w, x_n_3_w, x_n_4_w, x_n_5_w, x_n_6_w, x_n_7_w  : std_logic_vector(23 downto 0) := X"000000"; -- x_n_m_w = x(n-m)
	signal  FIR_x_n_sum_w, FIR_y_n_w                                                : std_logic_vector(31 downto 0);
	signal  FIRIFG_sig                                                              : std_logic := '0';
	signal  FIRENA_sig														        : std_logic := '0';
	signal  hold_fifo_read_w                                                        : std_logic_vector(23 downto 0) := X"000000";
	signal  fifo_output_flag_w                                                      : std_logic := '0';
	signal  data_FIR_out_w                                                          : std_logic_vector(31 downto 0);
	signal  fifo_empty_w                                   					        : std_logic := '0';
	signal  ready_to_read_w                                				            : std_logic := '1';
	signal  new_read_w                                                              : std_logic := '0';
	signal  fir_y_n_delay_w                                                         : std_logic_vector(31 downto 0) := X"00000000";
	signal  freeze_fifo_w                                                           : std_logic := '0';
	
BEGIN           

FIFO_connect : FIFO
	generic map(
		g_WIDTH => 24,
		g_DEPTH => 32
	)
	PORT MAP (	
    i_rst_sync => FIFORST_i,
    i_clk      => FIFOCLK_i,
    i_wr_en    => FIFOWEN_i,
    i_wr_data  => FIRIN_i(23 downto 0),
    o_full     => FIFOFULL_o,
    i_rd_en    => FIFOREN_w,
    o_rd_data  => read_data_FIFO_w,
    o_empty    => fifo_empty_w
	);

	
	process (FIRCLK_i, Dout_Pulse_Sync_w)
	begin
		if(Dout_Pulse_Sync_w = '1') then
			Din_Pulse_Sync_w <= '0';
		elsif rising_edge(FIRCLK_i) then
			Din_Pulse_Sync_w <= FIRENA_i;
	END IF;
end process;

	process (FIFOCLK_i, Dout_Pulse_Sync_w)
begin
	if rising_edge(FIFOCLK_i) then
		if(Dout_Pulse_Sync_w = '1') then
			Ds_Pulse_Sync_w   <= '0';
			Dout_Pulse_Sync_w <= '0';
		else
			Ds_Pulse_Sync_w   <= Din_Pulse_Sync_w;
			Dout_Pulse_Sync_w <= Ds_Pulse_Sync_w;
		END IF;
	END IF;
end process;


	FIFOREN_w  <= Dout_Pulse_Sync_w; --and not(FIRIFG_sig);


	
	FIR_x_n_sum_w <= std_logic_vector(ieee.NUMERIC_STD.UNSIGNED(COEF0_i) * ieee.NUMERIC_STD.UNSIGNED(x_n_0_w) + 
									  ieee.NUMERIC_STD.UNSIGNED(COEF1_i) * ieee.NUMERIC_STD.UNSIGNED(x_n_1_w) + 
									  ieee.NUMERIC_STD.UNSIGNED(COEF2_i) * ieee.NUMERIC_STD.UNSIGNED(x_n_2_w) + 
									  ieee.NUMERIC_STD.UNSIGNED(COEF3_i) * ieee.NUMERIC_STD.UNSIGNED(x_n_3_w) +
									  ieee.NUMERIC_STD.UNSIGNED(COEF4_i) * ieee.NUMERIC_STD.UNSIGNED(x_n_4_w) + 
									  ieee.NUMERIC_STD.UNSIGNED(COEF5_i) * ieee.NUMERIC_STD.UNSIGNED(x_n_5_w) +
									  ieee.NUMERIC_STD.UNSIGNED(COEF6_i) * ieee.NUMERIC_STD.UNSIGNED(x_n_6_w) + 
									  ieee.NUMERIC_STD.UNSIGNED(COEF7_i) * ieee.NUMERIC_STD.UNSIGNED(x_n_7_w));
	

					 
	process (FIRCLK_i, FIRENA_i, FIFOREN_w, ready_to_read_w)
	begin
		if(FIRRST_i = '1') then
			FIR_y_n_w  <= (others => '0') ;
			x_n_1_w 		<= (others => '0') ;
			x_n_2_w 		<= (others => '0') ;
			x_n_3_w 		<= (others => '0') ;
			x_n_4_w 		<= (others => '0') ;
			x_n_5_w 		<= (others => '0') ;
			x_n_6_w 		<= (others => '0') ;
			x_n_7_w 		<= (others => '0') ;
		elsif( FIFOREN_w = '1') then
			ready_to_read_w <= '1';
			FIRIFG_sig      <= '0';
		-- elsif( FIROUT_read_DataBus_ctrl_i = '1') then
			-- FIRIFG_sig      <= '0';
		elsif falling_edge(FIRCLK_i) then
			if(FIRENA_i ='1') then
				ready_to_read_w <= '0';
				if(ready_to_read_w = '1') then
					FIR_y_n_w 		<= X"00" & FIR_x_n_sum_w(31 downto 8);
					ready_to_read_w <= '0';
					FIRIFG_sig      <= '1';
					x_n_7_w 		<= x_n_6_w;
					x_n_6_w 		<= x_n_5_w;
					x_n_5_w 		<= x_n_4_w;
					x_n_4_w 		<= x_n_3_w;
					x_n_3_w 		<= x_n_2_w;
					x_n_2_w 		<= x_n_1_w;
					x_n_1_w 		<= x_n_0_w;
				end if;
			else
				FIR_y_n_w <= X"00000000";
			end if;	
		end if;
	end process;					 
	
	x_n_0_w         <= read_data_FIFO_w;
	
	FIRIFG_o        <= fifo_empty_w OR FIRIFG_sig;
	
	FIFOEMPTY_o     <= fifo_empty_w;
	
	FIROUT_o        <= FIR_y_n_w;
	
		-- process (FIRCLK_i, FIR_y_n_w)
	-- begin
		-- if rising_edge(FIRCLK_i) then
			-- fir_y_n_delay_w <= FIR_y_n_w;
	-- END IF;
-- end process;
	
	
	
END behavior;	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	-- FIFOREN_w  <= '0' when FIRENA_sig = '0' else 
				  -- Dout_Pulse_Sync_w;
	
------------------FIR forwarding------------------
	
	-- process (FIRCLK_i, FIROUT_read_DataBus_ctrl_i, FIFOREN_w)
-- begin
	-- if (FIRRST_i = '1') then 
		-- x_n_1_w   <=  X"000000";
		-- x_n_2_w   <=  X"000000";
		-- x_n_3_w   <=  X"000000";
		-- x_n_4_w   <=  X"000000";
		-- x_n_5_w   <=  X"000000";
		-- x_n_6_w   <=  X"000000";
		-- x_n_7_w   <=  X"000000";
		-- -- FIR_y_n_w <=  X"00000000";
	-- elsif (FIFOREN_w ='1') then 
		-- fifo_output_flag_w <= '1';
		-- FIRIFG_sig         <= '0';
	-- elsif falling_edge(FIRCLK_i) then
		-- if (FIRENA_i = '1') then 
			-- data_FIR_out_w <= X"00" & FIR_x_n_sum_w(31 downto 8);
			-- fifo_output_flag_w <= '0';
			
				-- if (fifo_output_flag_w = '1') then
					-- fifo_output_flag_w <= '0';
					-- FIRIFG_sig 	  <=  '1'; -- interupt flag after FIR calculation
					-- x_n_7_w    <= x_n_6_w;
					-- x_n_6_w    <= x_n_5_w;
					-- x_n_5_w    <= x_n_4_w;
					-- x_n_4_w    <= x_n_3_w;
					-- x_n_3_w    <= x_n_2_w;
					-- x_n_2_w    <= x_n_1_w;
					-- x_n_1_w    <= x_n_0_w;
				-- END IF;
				
		-- else
			-- data_FIR_out_w <= (others => '0');
		-- -- elsif ( FIROUT_read_DataBus_ctrl_i ='1') then 
			-- -- FIRIFG_sig 	  <=  '0'; -- interupt flag clear
		-- END IF;
	-- END IF;
-- end process;

	-- FIRIFG_o    <= FIRIFG_sig OR fifo_empty_w;
	-- FIFOEMPTY_o <= fifo_empty_w;
	-- -- FIRENA_sig <= FIRENA_i when	FIRIFG_sig = '0' else
				  -- -- '0';


			  
-- ---------------------------------------------------

	-- FIR_x_n_sum_w <= (COEF0_i * x_n_0_w) +
					 -- (COEF1_i * x_n_1_w) +
					 -- (COEF2_i * x_n_2_w) +
					 -- (COEF3_i * x_n_3_w) +
	                 -- (COEF4_i * x_n_4_w) +
					 -- (COEF5_i * x_n_5_w) +
					 -- (COEF6_i * x_n_6_w) +
					 -- (COEF7_i * x_n_7_w);
	
	-- x_n_0_w  <= read_data_FIFO_w;
	
	-- FIROUT_o   <= data_FIR_out_w;
	
-- END behavior;

