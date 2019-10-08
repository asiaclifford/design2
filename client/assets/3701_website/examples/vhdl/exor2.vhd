-- file = "exor2.vhd" , VHDL Representation of simple two input EXOR Gate

library ieee;                  
use ieee.std_logic_1164.all;	

entity EXOR2 IS					
port
	(
		A	:	in	bit;		
		B	:	in	bit;	
		Y	:	out	bit		
        );
end EXOR2;

architecture logic of EXOR2 is  
begin
	y 	<= 	(not A and B) or (A and not B);
end logic;	


