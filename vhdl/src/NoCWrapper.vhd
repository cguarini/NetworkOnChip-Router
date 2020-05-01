library ieee;
use ieee.std_logic_1164.all;


entity NoCWrapper is
    generic (n : integer  := 10);
    Port (
        nFlitIn : in std_logic_vector(n-1 downto 0); -- n bits to store in the register
        transmit: in std_logic; -- Active high write enable
        reset   : in std_logic; -- Async reset, disabled when low
        clk     : in std_logic;
        --buffer flit inputs
        localIn : in std_logic_vector(n-1 downto 0);
        northIn : in std_logic_vector(n-1 downto 0);
        southIn : in std_logic_vector(n-1 downto 0);
        eastIn : in std_logic_vector(n-1 downto 0);
        westIn : in std_logic_vector(n-1 downto 0);
        --outputs
        localOut: out std_logic_vector(n-1 downto 0); -- local output
        northOut: out std_logic_vector(n-1 downto 0); -- north output
        southOut: out std_logic_vector(n-1 downto 0); -- south output
        eastOut: out std_logic_vector(n-1 downto 0); -- east output
        westOut: out std_logic_vector(n-1 downto 0) -- west output
    );
end NoCWrapper;


architecture struct of NoCWrapper is

    --Component Declarations
    component nCrossbar is
        generic (n : integer  := 10);
        Port (
            --inputs
            nFlitIn : in std_logic_vector(n-1 downto 0); -- n bits to store in the register
            portSel : in std_logic_vector(2 downto 0); -- Which port to route packet to, from LUT
            reset   : in std_logic; -- Async reset, active low
            clk     : in std_logic;
            transmit: in std_logic; -- Transmit this signal
            --outputs
            localOut: out std_logic_vector(n-1 downto 0); -- local output
            northOut: out std_logic_vector(n-1 downto 0); -- north output
            southOut: out std_logic_vector(n-1 downto 0); -- south output
            eastOut: out std_logic_vector(n-1 downto 0); -- east output
            westOut: out std_logic_vector(n-1 downto 0) -- west output
        );
    end component;

    component RoutingLogicWrapper is
        generic (n : integer  := 10);
        Port (
            nFlitIn : in std_logic_vector(n-1 downto 0);
            reset   : in std_logic; -- Async reset, disabled when low
            clk     : in std_logic;
            transmit: out std_logic; -- Active high write enable
            buffSel : out std_logic_vector(2 downto 0);
            portSel : out std_logic_vector(2 downto 0); --Which port to route the packet to
            nFlitOut: out std_logic_vector(n-1 downto 0) -- 1 output , n bits wide
        );
    end component;

    component BufferWrapper is
        generic (n : integer  := 10);
        Port (
            buffSel : in std_logic_vector(2 downto 0);
            transmit: in std_logic; -- Active high write enable
            reset   : in std_logic; -- Async reset, disabled when low
            clk     : in std_logic;
            --buffer flit inputs
            localIn : in std_logic_vector(n-1 downto 0);
            northIn : in std_logic_vector(n-1 downto 0);
            southIn : in std_logic_vector(n-1 downto 0);
            eastIn : in std_logic_vector(n-1 downto 0);
            westIn : in std_logic_vector(n-1 downto 0);
            nBufferOut: out std_logic_vector(n-1 downto 0) -- 1 output , n bits wide
        );
    end component;




    --SIGNAL DECLARATIONS
    signal bufferSelect : std_logic_vector(2 downto 0);
    signal tx : std_logic;
    signal bufferOutput : std_logic_vector(n-1 downto 0);
    signal portSelect : std_logic_vector(2 downto 0);
    signal routingOutput : std_logic_vector(n-1 downto 0);
    

begin

    buffer0 : BufferWrapper
    generic map (n => 10)
    port map (
        buffSel => bufferSelect,
        transmit => tx,
        reset => reset,
        clk => clk,
        localIn => localIn,
        northIn => northIn,
        southIn => southIn,
        eastIn => eastIn,
        westIn => westIn,
        nBufferOut => bufferOutput
    );

    router0 : RoutingLogicWrapper
    generic map (n => 10)
    port map (
        nFlitIn => bufferOutput,
        reset => reset,
        clk => clk,
        transmit => tx,
        buffSel => bufferSelect,
        portSel => portSelect,
        nFlitOut => routingOutput
    );
    

    crossbar0 : nCrossbar
    generic map (n=> 10)
    port map(
        nFlitIn => routingOutput,
        portSel => portSelect,
        reset => reset,
        clk => clk,
        transmit => tx,
        localOut => localOut,
        northOut => northOut,
        southOut => southOut,
        eastOut => eastOut,
        westOut => westOut
    );

end struct;



