library ieee;
use ieee.std_logic_1164.all;

--Muxes the buffers, selecting one to go to output
entity nCrossbar is
    generic (n : integer  := 10);
    Port (
        --inputs
        nFlitIn : in std_logic_vector(n-1 downto 0); -- n bits to store in the register
        portSel : in std_logic_vector(2 downto 0); -- Which port to route packet to, from LUT

        --outputs
        localOut: out std_logic_vector(n-1 downto 0); -- local output
        northOut: out std_logic_vector(n-1 downto 0); -- north output
        southOut: out std_logic_vector(n-1 downto 0); -- south output
        eastOut: out std_logic_vector(n-1 downto 0); -- east output
        westOut: out std_logic_vector(n-1 downto 0) -- west output
    );
end nCrossbar;


architecture logic of nCrossbar is

begin
    
    --Sets output to input if this port is selected, otherwise 0
    localProc : process (portSel, nFlitIn) begin

        if portSel = "000" then
            localOut <= nFlitIn;
        else
            localOut <= (others => '0');
        end if;

    end process localProc;

    --Sets output to input if this port is selected, otherwise 0
    northProc : process (portSel, nFlitIn) begin


        if portSel = "001" then
            northOut <= nFlitIn;
        else
            northOut <= (others => '0');
        end if;


    end process northProc;

    --Sets output to input if this port is selected, otherwise 0
    southProc : process (portSel, nFlitIn) begin


        if portSel = "010" then
            southOut <= nFlitIn;
        else
            southOut <= (others => '0');
        end if;


    end process southProc;

    --Sets output to input if this port is selected, otherwise 0
    eastProc : process (portSel, nFlitIn) begin

        if portSel = "011" then
            eastOut <= nFlitIn;
        else
            eastOut <= (others => '0');
        end if;


    end process eastProc;

    --Sets output to input if this port is selected, otherwise 0
    westProc : process (portSel, nFlitIn) begin

        if portSel = "100" then
            westOut <= nFlitIn;
        else
            westOut <= (others => '0');
        end if;


    end process westProc;


end logic;



