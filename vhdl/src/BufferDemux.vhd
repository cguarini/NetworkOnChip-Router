library ieee;
use ieee.std_logic_1164.all;

--Muxes the buffers, selecting one to go to output
entity BufferDemux is
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
end BufferDemux;


architecture logic of BufferDemux is

begin

    localProc : process (buffSel, transmit) begin

        case buffSel is
            when "000" =>
                localTx <= transmit;
            when others =>
                localTx <= '0';
        end case;

    end process localProc;

    northProc : process (buffSel, transmit) begin

        case buffSel is
            when "001" =>
                northTx <= transmit;
            when others =>
                northTx <= '0';
        end case;

    end process northProc;

    southProc : process (buffSel, transmit) begin

        case buffSel is
            when "010" =>
                southTx <= transmit;
            when others =>
                southTx <= '0';
        end case;

    end process southProc;

    eastProc : process (buffSel, transmit) begin

        case buffSel is
            when "011" =>
                eastTx <= transmit;
            when others =>
                eastTx <= '0';
        end case;

    end process eastProc;

    westProc : process (buffSel, transmit) begin

        case buffSel is
            when "100" =>
                westTx <= transmit;
            when others =>
                westTx <= '0';
        end case;

    end process westProc;



end logic;



