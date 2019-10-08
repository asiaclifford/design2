library ieee;
use ieee.std_logic_1164.all;
entity MUX2to1c is port(
	A, B:	in	std_logic_vector(7 downto 0);
	Sel:	in	std_logic;
	Y: 	out	std_logic_vector(7 downto 0));
end MUX2to1c;

architecture behavior of MUX2to1c is
begin
	Y <= B when (Sel = '1') else A; --'Y<=' not repeated
end behavior;
