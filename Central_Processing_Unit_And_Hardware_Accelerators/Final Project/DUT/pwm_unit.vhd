LIBRARY ieee;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.aux_package.all;
-------------------------------------
entity Basic_Timer is
  generic (n : integer := 16;
		   k : integer := 3;   -- k=log2(n)
		   m : integer := 4	); -- m=2^(k-1)
  port 
  (    
		BTCCR0_i, BTCCR1_i 		: in  std_logic_vector(31 downto 0); 
		BTHOLD_i, BTCLR_i   	: in  std_logic;
		MCLK_i                  : in  std_logic;
		BTSSELX_i, BTIPx_i      : in  std_logic_vector(1 downto 0);
		BTOUTMD_i, BTOUTEN_i    : in  std_logic;
		BTCNT_io                : inout  std_logic_vector(31 downto 0):= X"00000000";
		BTIFG_o, PWM_out_o      : out std_logic

  );
  
end Basic_Timer;
--------------------------------------
architecture pwm_unit_dataflow of Basic_Timer is 
	
	signal BTCL0, BTCL1 		  : std_logic_vector(31 downto 0);
	signal MCLK_2, MCLK_4, MCLK_8 : std_logic := '0';
	signal HEU0         		  : std_logic;
	signal clk         			  : std_logic;
	signal pwm_sig     			  : std_logic := '0';   	
	signal modulo_MCLK_w          : std_logic_vector(2 downto 0) := "000";
	
begin
	
	
	process (MCLK_i)
		begin
		if falling_edge(MCLK_i) then
			if (BTCNT_io = X"00000000") then
				BTCL0 <= BTCCR0_i;
				BTCL1 <= BTCCR1_i;
			end if;
		end if;	
	end process;
	
	process (clk, BTCLR_i)
	begin
		if (BTCLR_i = '1') then
			BTCNT_io <= (others => '0');
		elsif rising_edge(clk) then 
			if (BTHOLD_i = '0') then
				if (BTCNT_io >= BTCL0) then
					BTCNT_io <= (others => '0');
				else
					BTCNT_io <= BTCNT_io + 1;
				end if;
			end if;
		end if;
	end process;
	
	process (clk)
    begin
        if (rising_edge(clk)) then
		    if (BTCNT_io < BTCL1) then
				pwm_sig <= '0';
				HEU0    <= '0';
			elsif(BTCNT_io < BTCL0) then
				pwm_sig <= '1';
				HEU0    <= '0';		
			else
				pwm_sig <= '0';
				HEU0    <= '1';
			end if;
			if (BTOUTMD_i = '1') then
				pwm_sig <= not(pwm_sig);
			end if;
	    end if;
    end process;
	
	PWM_out_o  <=	 pwm_sig WHEN BTOUTEN_i = '1' ELSE 
					 '0';
	
	process (MCLK_i)
		begin
		if rising_edge(MCLK_i) then 
			if(modulo_MCLK_w(0) = '0') then
				MCLK_2 <= not(MCLK_2);
			end if;
			if(modulo_MCLK_w(1 downto 0) = "00") then
				MCLK_4 <= not(MCLK_4);	
			end if;
			if(modulo_MCLK_w(2 downto 0) = "000") then
				MCLK_8 <= not(MCLK_8);	
			end if;
			-- if(modulo_MCLK_w < 7) then
				modulo_MCLK_w <= modulo_MCLK_w + 1;
			-- else
				-- modulo_MCLK_w <= "000";
			-- end if;
		end if;
	end process;
	
	clk 	<=  MCLK_i when BTSSELX_i = "00" else
				MCLK_2 when BTSSELX_i = "01" else
				MCLK_4 when BTSSELX_i = "10" else
				MCLK_8;
	
	
	BTIFG_o <=  HEU0   	  	 when BTIPx_i = "00" else
				BTCNT_io(23) when BTIPx_i = "01" else
				BTCNT_io(27) when BTIPx_i = "10" else
				BTCNT_io(31);	

end pwm_unit_dataflow;

