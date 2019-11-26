library ieee;
use ieee.std_logic_1164.all;
entity MUX2to1b is port(
	A, B:	in	std_logic_vector(7 downto 0);
	Sel:	in	std_logic;
	Y: 	out	std_logic_vector(7 downto 0));
end MUX2to1b;

architecture behavior of MUX2to1b is
signal Temp:	std_logic_vector(7 downto 0);
begin
	Temp <= (Sel,Sel,others=>Sel); -- or could use Temp <= (others=>Sel);
--  Above DOES work in Quartus
--  Above does NOT work in MaxPlusII, but works in many other VHDL packages
	Y <= ( B and Temp ) or
	     ( A and (not Temp) ); -- must have same types for and & or
end behavior;
