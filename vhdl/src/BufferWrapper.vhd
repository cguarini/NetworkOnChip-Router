library ieee;
use ieee.std_logic_1164.all;


entity BufferWrapper is
    generic (n : integer  := 10);
    Port (
        buffSel : in std_logic_vector(2 downto 0);
        transmit: in std_logic; -- Active high write enable
        reset   : in std_logic; -- Async reset, disabled when low
        clk     : in std_logic;
        full : out std_logic;
        nBufferOut: out std_logic_vector(n-1 downto 0) -- 1 output , n bits wide
    );
end BufferWrapper;


architecture struct of BufferWrapper is

    --Component Declarations
    component nVCBuffer is
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
            full : out std_logic;
            nFlitOut: out std_logic_vector(n-1 downto 0) -- 1 output , n bits wide
        );
    end component;

    component nBufferMux is
        generic (n : integer  := 10);
        Port (
            --General inputs
            buffSel : in std_logic_vector(2 downto 0); -- Select the buffer
            --Buffer inputs
            localIn  : in std_logic_vector(n-1 downto 0); -- local buffer
            northIn  : in std_logic_vector(n-1 downto 0); -- north buffer
            southIn  : in std_logic_vector(n-1 downto 0); -- south buffer
            eastIn  : in std_logic_vector(n-1 downto 0); -- east buffer
            westIn  : in std_logic_vector(n-1 downto 0); -- west buffer
            --Mux outputs
            muxOut : out std_logic_vector(n-1 downto 0) -- 1 output , n bits wide
        );
    end component;

    component BufferDemux is
        generic (n : integer  := 10);
        Port (
            --General inputs
            buffSel : in std_logic_vector(2 downto 0); -- Select the buffer
            transmit : in std_logic; -- transmit signal
    
            --Demux outputs, transmit to each buffer
            localTx  : out std_logic_vector(n-1 downto 0); -- local buffer
            northTx  : out std_logic_vector(n-1 downto 0); -- north buffer
            southTx  : out std_logic_vector(n-1 downto 0); -- south buffer
            eastTx   : out std_logic_vector(n-1 downto 0); -- east buffer
            westTx   : out std_logic_vector(n-1 downto 0)  -- west buffer
        );
    end component;
    
    --SIGNAL DECLARATIONS

    --buffer flit outputs
    signal localOut, northOut, southOut, eastOut, westOut : STD_LOGIC_VECTOR(n-1 downto 0);
    --transmit input
    signal localTx, northTx, southTx, eastTx, westTx : std_logic;
    --full
    signal localFull, northFull, southFull, eastFull, westFull : std_logic;

begin

    --Create Demux
    buffDemux : BufferDemux
    generic map (n=> 10)
    port map (
        buffSel => buffSel,
        transmit => transmit,
        localTx => localTx,
        northTx => northTx,
        southTx => southTx,
        eastTx => eastTx,
        westTx => westTx
    );

    --Create Mux
    bufferMux : nBufferMux
    generic map (n => 10)
    port map (
        buffSel => buffSel,
        localIn => localOut,
        northIn => northOut,
        southIn => southOut,
        eastIn => eastOut,
        westIn => westOut,
        muxOut => nBufferOut
    );

   --Create buffers

   localBuff : nVCBuffer
   generic map (n => 10)
   port map (
       nFlitIn => localIn,
       transmit => localTx,
       reset => reset,
       clk => clk,
       full => localFull,
       nFlitOut => localOut
   );

   northBuff : nVCBuffer
   generic map (n => 10)
   port map (
       nFlitIn => northIn,
       transmit => northTx,
       reset => reset,
       clk => clk,
       full => northFull,
       nFlitOut => northOut
   );

   southBuff : nVCBuffer
   generic map (n => 10)
   port map (
       nFlitIn => southIn,
       transmit => southTx,
       reset => reset,
       clk => clk,
       full => southFull,
       nFlitOut => southOut
   );

   eastBuff : nVCBuffer
   generic map (n => 10)
   port map (
       nFlitIn => eastIn,
       transmit => eastTx,
       reset => reset,
       clk => clk,
       full => eastFull,
       nFlitOut => eastOut
   );

   westBuff : nVCBuffer
   generic map (n => 10)
   port map (
       nFlitIn => westIn,
       transmit => westTx,
       reset => reset,
       clk => clk,
       full => westFull,
       nFlitOut => westOut
   );
    

end struct;



