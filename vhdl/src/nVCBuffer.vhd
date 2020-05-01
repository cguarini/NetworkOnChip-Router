library ieee;
use ieee.std_logic_1164.all;


entity nVCBuffer is
    generic (n : integer  := 10);
    Port (
        nFlitIn : in std_logic_vector(n-1 downto 0); -- n bits to store in the register
        transmit: in std_logic; -- Active high write enable
        reset   : in std_logic; -- Async reset, disabled when low
        clk     : in std_logic;
        full : out std_logic;
        nFlitOut: out std_logic_vector(n-1 downto 0) -- 1 output , n bits wide
    );
end nVCBuffer;


architecture struct of nVCBuffer is

    --Component Declarations
    component nBitRegister_32 is
        generic(n : integer := 32);
        Port (
            nBitIn : in std_logic_vector(n-1 downto 0); -- n bits to store in the register
            WE     : in std_logic; -- Active high write enable
            reset  : in std_logic; -- Async reset, disabled when low
            clk    : in std_logic;
            Y : out std_logic_vector(n-1 downto 0) -- 1 output , n bits wide
        );
    end component;

    --Component Declarations
    component nVCControl is
        generic (n : integer  := 32);
        Port (
            topFlit : in std_logic_vector(n-1 downto 0); -- n bits to store in the register
            transmit     : in std_logic; -- Active high write enable
            reset  : in std_logic; -- Async reset, disabled when low
            clk    : in std_logic;
            full : out std_logic;
            flushFlits : out std_logic
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
    port map(
        nBitIn => reg0In,
        WE => flush, 
        clk => clk, 
        reset => reset, 
        Y => reg0Out
    );

    --Middle register
    Reg1 : nBitRegister_32
    generic map( n => 10)
    port map(
        nBitIn => reg0Out,
        WE => flush, 
        clk => clk, 
        reset => reset, 
        Y => reg1Out
    );

    --Output register
    Reg2 : nBitRegister_32
    generic map( n => 10)
    port map(
        nBitIn => reg1Out,
        WE => flush, 
        clk => clk, 
        reset => reset, 
        Y => reg2Out
    );

    --Assign input and output signals
    reg0In <= nFlitIn;
    nFlitOut <= reg2Out;
    

end struct;



