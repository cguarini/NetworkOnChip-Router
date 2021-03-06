library ieee;
use ieee.std_logic_1164.all;

--Look up table to select which way to send the packet
entity nRouterLUT is
    generic (n : integer  := 10);
    Port (
        --inputs
        nFlitIn : in std_logic_vector(n-1 downto 0); -- n bits to store in the register
        reset : in std_logic;
        clk : in std_logic;
        --outputs
        portSel: out std_logic_vector(2 downto 0); --Which port to route the packet to
        nFlitOut : out std_logic_vector(n-1 downto 0) -- Flit signal
    );
end nRouterLUT;


architecture logic of nRouterLUT is

    signal routerRank : std_logic_vector(2 downto 0);
    signal transmit : std_logic;

begin

    --Double check, may not work
    routerRank <= nFlitIn(4 downto 2);

    --Determine if packet should be transmitted
    txProc : process(nFlitIn) begin
        if nFlitIn(1 downto 0) = "00" then
            transmit <= '0';
        else
            transmit <= '1';
        end if;
    end process txProc;

    --Lookup the destination rank and set the portSel signal
    lookupProc : process (clk, reset) begin
        if reset = '0' then
            portSel <= "111"; --points to nothing
        elsif clk'event and clk = '1' then
            if nFlitIn(1 downto 0) = "11" then
                if routerRank = "000" and transmit = '1' then
                    portSel <= "000";
                elsif routerRank = "001" and transmit = '1' then
                    portSel <= "001";
                elsif routerRank = "010" and transmit = '1' then
                    portSel <= "010";
                elsif routerRank = "011" and transmit = '1' then
                    portSel <= "011";
                elsif routerRank = "100" and transmit = '1' then
                    portSel <= "100";    
                else
                    --Only 5 routers in network, all others go to null
                    portSel <= "111";
                end if;
            elsif transmit = '0' then
                portSel <= "111";
            end if;
        end if;
    end process lookupProc;

    --Clock the flit out
    outputProc : process (clk, reset) begin
        if reset = '0' then
            nFlitOut <= (others => '0'); 
        elsif clk'event and clk = '1' then
            if transmit = '1' then
                nFlitOut <= nFlitIn;
            else
                nFlitOut <= (others => '0');
            end if;
        end if;
    end process outputProc;

end logic;



