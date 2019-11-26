library ieee; use ieee.std_logic_1164.all;
entity MIXED_LOGIC is port(
	A,B,C_L,D_L:	in std_logic;
	X_L,Y:		out std_logic);
end MIXED_LOGIC ;
architecture behavior of MIXED_LOGIC is
signal X, C, D: std_logic;
begin
	-- Define inputs
		C <= not C_L; D <= not D_L;
	-- Define outputs
		X_L <= not X;
	-- Define logic equations
	-- (No _L in below equations)
		X <= A and B;
		Y <= C or D;
end behavior;
