library ieee;
use ieee.std_logic_1164.all;

--Muxes the buffers, selecting one to go to output
entity nRouterMux is
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
end nRouterMux;


architecture logic of nRouterMux is

begin

    mux_proc : process (buffSel, localIn, northIn, southIn, eastIn, westIn) begin

        case buffSel is
            when "000" =>
                muxOut <= localIn;
            when "001" =>
                muxOut <= northIn;
            when "010" =>
                muxOut <= southIn;
            when "011" =>
                muxOut <= eastIn;
            when others =>
                muxOut <= westIn;
        end case;

    end process mux_proc;



end logic;



