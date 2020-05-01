-- Testbench created online at:
--   www.doulos.com/knowhow/perl/testbench_creation/
-- Copyright Doulos Ltd
-- SD, 03 November 2002

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity NoCWrapper_tb is
end;

architecture bench of NoCWrapper_tb is

    constant n : integer := 10;

  component NoCWrapper
      generic (n : integer  := 10);
      Port (
          reset   : in std_logic;
          clk     : in std_logic;
          localIn : in std_logic_vector(n-1 downto 0);
          northIn : in std_logic_vector(n-1 downto 0);
          southIn : in std_logic_vector(n-1 downto 0);
          eastIn : in std_logic_vector(n-1 downto 0);
          westIn : in std_logic_vector(n-1 downto 0);
          localOut: out std_logic_vector(n-1 downto 0);
          northOut: out std_logic_vector(n-1 downto 0);
          southOut: out std_logic_vector(n-1 downto 0);
          eastOut: out std_logic_vector(n-1 downto 0);
          westOut: out std_logic_vector(n-1 downto 0)
      );
  end component;

  signal reset: std_logic;
  signal clk: std_logic;
  signal localIn: std_logic_vector(n-1 downto 0);
  signal northIn: std_logic_vector(n-1 downto 0);
  signal southIn: std_logic_vector(n-1 downto 0);
  signal eastIn: std_logic_vector(n-1 downto 0);
  signal westIn: std_logic_vector(n-1 downto 0);
  signal localOut: std_logic_vector(n-1 downto 0);
  signal northOut: std_logic_vector(n-1 downto 0);
  signal southOut: std_logic_vector(n-1 downto 0);
  signal eastOut: std_logic_vector(n-1 downto 0);
  signal westOut: std_logic_vector(n-1 downto 0) ;

begin

  -- Insert values for generic parameters !!
    uut: NoCWrapper
    generic map ( n => 10 )
    port map ( 
        reset    => reset,
        clk      => clk,
        --Router input
        localIn  => localIn,
        northIn  => northIn,
        southIn  => southIn,
        eastIn   => eastIn,
        westIn   => westIn,
        --Router output
        localOut => localOut,
        northOut => northOut,
        southOut => southOut,
        eastOut  => eastOut,
        westOut  => westOut 
    );

    --100ns clock period
    clk_proc : process
    begin
        if clk = '0' then
            clk <= '1';
        else 
            clk <= '0';
        end if;
        wait for 50 ns;
    end process;

  stimulus: process
  begin
  
    -- Put initialisation code here

    --Initialize buffer inputs
    localIn <= (others => '0');
    northIn <= (others => '0');
    southIn <= (others => '0');
    eastIn  <= (others => '0');
    westIn  <= (others => '0');

    -- Put test bench stimulus code here

    
    --reset
    reset <= '0';
    --Header packet, send to local
    localIn <= "0000000011";
    wait for 100 ns;
    reset <= '1';
    wait for 100 ns;
    --Body packet, 'H'
    localIn <= "0100100010";
    wait for 100 ns;
    --Tail packet, 'E'
    localIn <= "0100010101";
    wait for 100 ns;
    localIn <= (others => '0');

    wait;
  end process;


end;