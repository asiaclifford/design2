-- file = "mux41.vhd" , VHDL Representation of 4:1 Mux 
-- note: these two dashes are used to creat a comment line in VHDL
-- VHDL is very syntax specific; Pay close attention to the details below.
library ieee;	-- Specific VHDL library we will use that has definitions
				-- of the variable types shown in the PORT statement below.
				-- This library also supports the functions (and, OR & not) 
				-- we will use in the ARCHITECTURE section.
use ieee.std_logic_1164.all;	-- The package that containing several libraries (including ieee).
								-- This is like an include statement in 'C'.

entity MUX41 is		-- Similar to the project name... it must match the file name 
					-- for MaxPlusII to compile this file properly.	

    port					-- Inputs & Outputs of the design
        (
		S1  :  in	bit;	-- input S1 is signal type "bit" ... like variable declarations in 'C'
		S0  :  in	bit;	-- input S0 is signal type "bit" 
		D3  :  in	bit;	-- input D3 is signal type "bit" 
		D2  :  in	bit;	-- input D2 is signal type "bit" 
		D1  :  in	bit;	-- input D1 is signal type "bit" 
		D0  :  in	bit;	-- input D0 is signal type "bit" 
		Y   :  out	bit		-- output Y is signal type "bit", note: this line does NOT have a ;
        );
end MUX41;

architecture logic of MUX41 is	-- This is where we define the circuit function.
begin
						-- Y = (D0 * /S1 * /S0) + (D1 * /S1 *  S0) +
						--     (D2 *  S1 * /S0) + (D3 *  S1 *  S0).
						-- The parenthesis are added to make the code easier to read.
	y 	<= 	(D0 and (not S1) and (not S0)) or 
			(D1 and (not S1) and      S0 ) or 
			(D2 and      S1  and (not S0)) or 
			(D3 and      S1  and      S0 ) ; 
end logic;	

