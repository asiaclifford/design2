library ieee;                  
use ieee.std_logic_1164.all;	
entity ex1 IS					
port
	(
		A, B   :  in	bit;		
		Y  	:  out bit);
end ex1;

architecture behav of ex1 is  
begin
Y <= A or B;

end behav;	

