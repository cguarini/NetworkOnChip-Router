library ieee;
use ieee.std_logic_1164.all;

--Look up table to select which way to send the packet
entity nRouterLUT is
    generic (n : integer  := 10);
    Port (
        --inputs
        nFlitIn : in std_logic_vector(n-1 downto 0); -- n bits to store in the register
        transmit : in std_logic;
        reset : in std_logic;
        clk : in std_logic;
        --outputs
        portSel: out std_logic; --Which port to route the packet to
        nFlitOut : out std_logic_vector(n-1 downto 0) -- Flit signal
    );
end nRouterLUT;


architecture logic of nRouterLUT is

    signal routerRank <= nFlitIn(4 downto 2);

begin

    --Lookup the destination rank and set the portSel signal
    lookupProc : process (clk, reset) begin
        if reset = '0' then
            portSel <= "111"; --points to nothing
        elsif clk'event and clk = '1' then
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
        end if;
    end process lookupProc;

    --Clock the flit out
    lookupProc : process (clk, reset) begin
        if reset = '0' then
            nFlitOut <= (others => '0'); 
        elsif clk'event and clk = '1' then
            if transmit = '1' then
                nFlitOut <= nFlitIn;
            else
                nFlitOut <= (others => '0');
            end if;
        end if;
    end process lookupProc;

end logic;



