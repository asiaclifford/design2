library ieee; use ieee.std_logic_1164.all;
entity VHDL_PER7 is port(
	A, B, C:	in	std_logic;
	Y: 	out	std_logic);
end VHDL_PER7;

architecture behavior of VHDL_PER7 is
begin
	Y <= (A and B) or not C;
end behavior;
