library ieee;
use ieee.std_logic_1164.all;

--Muxes the buffers, selecting one to go to output
entity MuxSelectLogic is
    Port (
        --General inputs
        reset   : in std_logic; -- Async reset, disabled when low
        clk     : in std_logic;
        enable  : in std_logic;

        --Outputs
        buffSel : out std_logic_vector(2 downto 0) -- Select the buffer
    );
end MuxSelectLogic;


architecture logic of MuxSelectLogic is

    signal count : std_logic_vector(2 downto 0);

begin
    
    --Circular counter from 0 to 4
    count_proc : process (clk, reset) begin

        if reset = '0' then
            buffSel <= (others => '0');
        elsif clk'event and clk = '1' then
            if enable = '1' then
                if count = "000" then
                    count <= "001";
                elsif count = "001" then
                    count <="010";
                elsif count = "010" then
                    count <= "011";
                elsif count = "011" then
                    count <= "100";
                else
                    count <= "000";
                end if;
            end if;
        end if;

    end process count_proc;

    buffSel <= count;

end logic;



