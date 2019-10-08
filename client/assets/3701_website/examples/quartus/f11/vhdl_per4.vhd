entity VHDL_PER4 is
	port(
	A,B,D: in bit;
	C: out bit);
end VHDL_PER4;

architecture behavior of VHDL_PER4 is 
begin
	C<= A and (B or not D);
end behavior;
