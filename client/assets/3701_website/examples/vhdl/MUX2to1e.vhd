library ieee;
use ieee.std_logic_1164.all;
entity MUX2to1e is port(
	A, B:	in	std_logic_vector(7 downto 0);
	Sel:	in	std_logic;
	Y: 	out	std_logic_vector(7 downto 0));
end MUX2to1e;

architecture behavior of MUX2to1e is
begin
	comb: process (Sel, A, B) -- rerun process if any changes
	begin
	   if (Sel = '1') then 
	      Y <= B;
	   else
	      Y <= A;
	   end if; -- note that *end if* is two words
	end process comb;
end behavior;
