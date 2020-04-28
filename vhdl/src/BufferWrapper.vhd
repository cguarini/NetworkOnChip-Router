library ieee;
use ieee.std_logic_1164.all;


entity BufferWrapper is
    generic (n : integer  := 10);
    Port (
        nFlitIn : in std_logic_vector(n-1 downto 0); -- n bits to store in the register
        transmit: in std_logic; -- Active high write enable
        reset   : in std_logic; -- Async reset, disabled when low
        clk     : in std_logic;
        full : out std_logic;
        nFlitOut: out std_logic_vector(n-1 downto 0) -- 1 output , n bits wide
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
    --SIGNAL DECLARATIONS
    --flit links
    signal reg0In, reg0Out, reg1Out, reg2Out : STD_LOGIC_VECTOR(n-1 downto 0);
    --Allow data to move from register to register
    signal flush : STD_LOGIC;

begin

    --VC Controller, handles moving flits through the buffer
    control : nVCControl
    generic map ( n => 10)
    port map(
        topFlit => reg2Out,
        transmit => transmit,
        reset => reset,
        clk => clk,
        full => full,
        flushFlits => flush
    );

    --Entry register
    Reg0 : nBitRegister_32
    generic map( n => 10)
    port map(nBitIn => reg0In,
        WE => flush, 
        clk => clk, 
        reset => reset, 
        Y => reg0Out
    );

    --Middle register
    Reg1 : nBitRegister_32
    generic map( n => 10)
    port map(nBitIn => reg0Out,
        WE => flush, 
        clk => clk, 
        reset => reset, 
        Y => reg1Out
    );

    --Output register
    Reg1 : nBitRegister_32
    generic map( n => 10)
    port map(nBitIn => reg1Out,
        WE => flush, 
        clk => clk, 
        reset => reset, 
        Y => reg2Out
    );

    --Assign input and output signals
    reg0In <= nFlitIn;
    nFlitOut <= reg2Out;
    

end struct;



