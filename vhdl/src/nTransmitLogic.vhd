library ieee;
use ieee.std_logic_1164.all;

--Muxes the buffers, selecting one to go to output
entity nTransmitLogic is
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
end nTransmitLogic;


architecture logic of nTransmitLogic is

    signal tx : std_logic;

begin
    
    transmitProc : process (nFlitIn) begin

        if nFlitIn(1 downto 0) = "11" then
            --header flit, transmit this
            tx <= '1';
        elsif nFlitIn(1 downto 0) = "01" then
            --tail flit, stop transmitting
            tx <= '0';
        else
            tx <= tx;
        end if;

    end process transmitProc;


    flitOutProc : process (clk, reset) begin
        if reset = '0' then
            nFlitOut <= (others => '0');
        elsif clk'event and clk = '1' then
            nFlitOut <= nFlitIn;
        end if;
    end process flitOutProc;

    --Assign output
    transmit <= tx;


end logic;



