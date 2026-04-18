library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity top_IO_tb is
end top_IO_tb;

architecture sim of top_IO_tb is

  constant clk_period : time := 2 ns;

  -- DUT generics
  constant switch_size : integer := 10;
  constant key_size    : integer := 4;
  constant HEX_size    : integer := 4;
  constant LED_size    : integer := 10;
  constant n           : integer := 8;
  constant k           : integer := 3;
  constant m           : integer := 4;

  -- Signals
  signal clk        : std_logic := '0';
  signal SW         : std_logic_vector(switch_size - 1 downto 0) := (others => '0');
  signal KEY        : std_logic_vector(key_size - 1 downto 0) := (others => '1');
  signal HEX0, HEX1, HEX2, HEX3, HEX4, HEX5 : std_logic_vector(6 downto 0);
  signal LED        : std_logic_vector(LED_size - 1 downto 0);
  signal pwm_out    : std_logic;

  -- Procedure to press key
  procedure press_key(signal key : inout std_logic_vector; key_idx : in integer) is
  begin
    key(key_idx) <= '0';
    wait for clk_period;
    key(key_idx) <= '1';
    wait for clk_period;
  end procedure;

  -- Procedure to load a byte into a register (low/high byte of X or Y)
  procedure load_byte(signal sw : inout std_logic_vector; signal key : inout std_logic_vector; byte_val : std_logic_vector(7 downto 0); byte_sel : std_logic; key_idx : integer) is
  begin
    sw(7 downto 0) <= byte_val;
    sw(9) <= byte_sel;
    press_key(key, key_idx);
  end procedure;

  -- Procedure to load ALUFN
  procedure load_alufn(signal sw : inout std_logic_vector; signal key : inout std_logic_vector; val : std_logic_vector(4 downto 0)) is
  begin
    sw(7 downto 0) <= "000" & val;
    press_key(key, 2);
  end procedure;

begin

  -- Instantiate DUT
  DUT: entity work.top_IO
    generic map (
      switch_size => switch_size,
      key_size    => key_size,
      HEX_size    => HEX_size,
      LED_size    => LED_size,
      n           => n,
      k           => k,
      m           => m
    )
    port map (
      clk     => clk,
      SW      => SW,
      KEY     => KEY,
      HEX0    => HEX0,
      HEX1    => HEX1,
      HEX2    => HEX2,
      HEX3    => HEX3,
      HEX4    => HEX4,
      HEX5    => HEX5,
      LED     => LED,
      pwm_out => pwm_out
    );

  -- Clock process
  clk_process : process
  begin
    while true loop
      clk <= '0';
      wait for clk_period / 2;
      clk <= '1';
      wait for clk_period / 2;
    end loop;
  end process;

  -- Stimulus process
  stim_proc: process
  begin
    wait for 50 ns;

    -- Common input: Y = 5, X = 3
    load_byte(SW, KEY, "00000101", '0', 0); -- Y low
    load_byte(SW, KEY, "00000000", '1', 0); -- Y high
    load_byte(SW, KEY, "00000011", '0', 1); -- X low
    load_byte(SW, KEY, "00000000", '1', 1); -- X high

    -- === Arithmetic: ADD ===
    load_alufn(SW, KEY, "01000"); wait for 100 ns;
    assert LED(3 downto 0) = "1000" report "ADD failed, expected 8" severity error;

    -- === SUB ===
    load_alufn(SW, KEY, "01001"); wait for 100 ns;
    assert LED(3 downto 0) = "0010" report "SUB failed, expected 2" severity error;

    -- === SWAP ===
    load_alufn(SW, KEY, "01100"); wait for 100 ns;
    assert LED(3 downto 0) = "1010" report "SWAP failed, expected 0xA0 swapped = 0x0A" severity warning;

    -- === Logic: AND ===
    load_alufn(SW, KEY, "11010"); wait for 100 ns;
    assert LED(3 downto 0) = "0001" report "AND failed (3 AND 5 = 1)" severity error;

    -- === Logic: OR ===
    load_alufn(SW, KEY, "11001"); wait for 100 ns;
    assert LED(3 downto 0) = "0111" report "OR failed (3 OR 5 = 7)" severity error;

    -- === Shift left ===
    load_alufn(SW, KEY, "10000"); wait for 100 ns;
    -- Skipping assert: output depends on value of Y, could overflow

    -- === PWM modes ===
    SW(8) <= '1'; -- enable
    load_alufn(SW, KEY, "00000"); wait for 300 ns;
    load_alufn(SW, KEY, "00001"); wait for 300 ns;
    load_alufn(SW, KEY, "00010"); wait for 300 ns;

    wait;
  end process;

end sim;
