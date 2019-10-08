library ieee; 
use ieee.std_logic_1164.all;
entity MUX2to1a is port(
	A, B:	in	std_logic_vector(7 downto 0);
	Sel:	in	std_logic;
	Y: 	out	std_logic_vector(7 downto 0));
end MUX2to1a;

architecture behavior of MUX2to1a is
begin
	Y(0) <= ( B(0)  and Sel ) or
	        ( A(0) and not(Sel) );
	Y(1) <= ( B(1)  and Sel ) or
	        ( A(1) and not(Sel) );
	Y(2) <= ( B(2)  and Sel ) or
	        ( A(2) and not(Sel) );
	Y(3) <= ( B(3)  and Sel ) or
	        ( A(3) and not(Sel) );
	Y(4) <= ( B(4)  and Sel ) or
	        ( A(4) and not(Sel) );
	Y(5) <= ( B(5)  and Sel ) or
	        ( A(5) and not(Sel) );
	Y(6) <= ( B(6)  and Sel ) or
	        ( A(6) and not(Sel) );
	Y(7) <= ( B(7)  and Sel ) or
	        ( A(7) and not(Sel) );
end behavior;
