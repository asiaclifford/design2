library ieee;
use ieee.std_logic_1164.all;
entity NAND2b is
	port(
		A,B: in std_logic;
		C: out std_logic);
end NAND2b;

architecture behavior of NAND2b is
signal COut: std_logic;

begin
	COut <= A and B;
	C <= not COut;
end behavior;

