library ieee;
use ieee.std_logic_1164.all;


entity nVCControl is
    generic (n : integer  := 32);
    Port (
        topFlit : in std_logic_vector(n-1 downto 0); -- output of top register
        transmit     : in std_logic; -- Active high write enable
        reset  : in std_logic; -- Async reset, disabled when low
        clk    : in std_logic;
        flushFlits : out std_logic; -- allow flits to move through buffer
        full : out std_logic -- buffer is full
    );
end nVCControl;


architecture logic of nVCControl is


begin

    flushProc : process (clk, reset) begin

        if reset = '0' then
            --Reset, no need to flush
            flushFlits <= '0';
        elsif clk'event and clk = '1' then
            --rising clock edge
            if transmit = '1' then
                --Transmit all flits to router
                flushFlits <= '1';
            elsif transmit = '0' then
                --We're not transmitting, get the header to the top flit
                if topFlit(1 downto 0) = "11" then
                    --Header is at the top flit, stop flushing
                    flushFlits <= '0';
                else
                    --keep flishing until header is at top flit
                    flushFlits <= '1';
                end if;
            end if;
        end if;

    end process flushProc;

    fullProc : process (clk, reset) begin

        if reset = '0' then
            --Reset, buffer is empty
            full <= '0';
        elsif clk'event and clk = '1' then
            --rising clock edge
            if transmit = '1' then
                --Buffer is not full while transmitting
                --NOTE, this may cause problems
                full <= '0';
            elsif transmit = '0' then
                --We're not transmitting, check if full
                if topFlit(1 downto 0) = "11" then
                    --Header is at the top flit, buffer is full
                    full <= '1';
                else
                    --Header is not top flit, buffer not full
                    full <= '0';
                end if;
            end if;
        end if;

    end process fullProc;



end logic;



