library ieee;
use ieee.std_logic_1164.all;
entity MUX2to1d is port(
	A, B:	in	std_logic_vector(7 downto 0);
	Sel:	in	std_logic;
	Y: 	out	std_logic_vector(7 downto 0));
end MUX2to1d;

architecture behavior of MUX2to1d is
begin
	with Sel select
	Y <= B  when '1',
	     A when '0',    -- can remove either this line
	     A when others; --   or this line (but ; at end)
end behavior;
