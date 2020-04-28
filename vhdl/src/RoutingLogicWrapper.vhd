library ieee;
use ieee.std_logic_1164.all;


entity RoutingLogicWrapper is
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
end RoutingLogicWrapper;


architecture struct of RoutingLogicWrapper is

    --Component Declarations
    component inverter is
        Port (
            --inputs
            A : in std_logic; -- inverter input
            Y : out std_logic -- inverter output, ~A
        );
    end component;

    component MuxSelectLogic is
        Port (
            --General inputs
            reset   : in std_logic; -- Async reset, disabled when low
            clk     : in std_logic;
            enable  : in std_logic;
    
            --Outputs
            buffSel : out std_logic_vector(2 downto 0) -- Select the buffer
        );
    end component;

    component nTransmitLogic is
        generic (n : integer  := 10);
        Port (
            --inputs
            nFlitIn : in std_logic_vector(n-1 downto 0); -- n bits to store in the register
            reset   : in std_logic; -- Async reset, active low
            clk     : in std_logic;
            --outputs
            transmit: out std_logic; -- Transmit this signal
            nFlitOut : out std_logic_vector(n-1 downto 0) -- Flit signal
        );
    end component;

    component nRouterLUT is
        generic (n : integer  := 10);
        Port (
            --inputs
            nFlitIn : in std_logic_vector(n-1 downto 0); -- n bits to store in the register
            transmit : in std_logic;
            reset : in std_logic;
            clk : in std_logic;
            --outputs
            portSel: out std_logic_vector(2 downto 0); --Which port to route the packet to
            nFlitOut : out std_logic_vector(n-1 downto 0) -- Flit signal
        );
    end component;
   
    
    --SIGNAL DECLARATIONS
    signal tx, txNot : std_logic;
    signal txFlitOut : std_logic_vector(n-1 downto 0);


begin

    txLogic : nTransmitLogic
    generic map (n => 10)
    port map (
        nFlitIn => nFlitIn,
        reset => reset,
        clk => clk,
        transmit => tx,
        nFlitOut => txFlitOut
    );

    inv0 : inverter
    port map (
        A => tx,
        Y => txNot
    );

    muxSel0 : MuxSelectLogic
    port map (
        reset => reset,
        clk => clk,
        enable => txNot,
        buffSel => buffSel
    );

    LUT0 : nRouterLut
    generic map (n => 10);
    port map (
        nFlitIn => txFlitOut,
        transmit => tx,
        reset => reset,
        clk => clk,
        portSel => portSel,
        nFlitOut => nFlitOut
    )
    

end struct;



