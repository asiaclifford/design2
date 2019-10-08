entity NAND2a is
	port(
	A,B: in bit;
	C: out bit);
end NAND2a;

architecture behavior of NAND2a is 
signal COut: bit;
begin
	COut <= A and B;
	C<= not COut;
end behavior;
