library ieee; use ieee.std_logic_1164.all;
entity MUX41b is port (
		S1, S0:		in	std_logic;	
		D3, D2, D1, D0:	in	std_logic_vector;
		Y:			out	std_logic
);
end MUX41b;
architecture logic OF MUX41b IS
begin
-- Y = (D0 * /S1 * /S0) + (D1 * /S1 *  S0) +     (D2 *  S1 * /S0) + (D3 *  S1 *  S0).
	Y <=	(D(0) and (not S1) and (not S0)) or 
		(D(1) and (not S1) and      S0 ) or 
		(D(2) and      S1  and (not S0)) or 
		(D(3) and      S1  and      S0 ) ; 
end logic;
