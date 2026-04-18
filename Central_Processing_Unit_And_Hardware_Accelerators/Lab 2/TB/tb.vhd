library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.aux_package.all;

entity tb is
    constant n : integer := 8;
end tb;

architecture rtb of tb is
    signal rst, clk, repeat : std_logic;
    signal upperBound       : std_logic_vector(n-1 downto 0);
    signal count            : std_logic_vector(n-1 downto 0);
    signal busy             : std_logic;
begin

    L0 : top generic map (n) port map(rst, clk, repeat, upperBound, count, busy);

    gen_clk : process
    begin
        while true loop
            clk <= '0';
            wait for 50 ns;
            clk <= '1';
            wait for 50 ns;
        end loop;
    end process;

    gen_rst : process
    begin
        rst <= '1'; wait for 150 ns;
        rst <= '0'; wait for 800 ns;
        rst <= '1'; wait for 200 ns;
        rst <= '0'; wait;
    end process;

    gen_repeat : process
    begin
        repeat <= '1';
        wait for 2000 ns;
        repeat <= '0';
        wait for 1000 ns;
        repeat <= '1';
        wait for 600 ns;
        repeat <= '0';
        wait;
    end process;

    gen_check : process
    begin
        upperBound <= "00000010";
        wait for 800 ns;

        upperBound <= upperBound + 2;
        wait for 800 ns;

        upperBound <= (others => '0');
        wait for 800 ns;

        upperBound <= "00000001";
        wait for 800 ns;

        upperBound <= "00001111";
        wait for 800 ns;

        upperBound <= "00000001";
        wait for 800 ns;

        upperBound <= "00000101";
        wait for 1000 ns;

        wait;
    end process;

end architecture rtb;
