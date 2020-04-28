library ieee;
use ieee.std_logic_1164.all;

--Muxes the buffers, selecting one to go to output
entity inverter is
    Port (
        --inputs
        A : in std_logic; -- inverter input
        Y : out std_logic -- inverter output, ~A
    );
end inverter;


architecture gate of inverter is

begin
    
    Y <= (not A);

end gate;



