-- file = "exor8.vhd" , VHDL Representation of 8 input EXOR Gate
-- instantiates exor2 component numerous times for creation of single 8 input gate EXOR
-- This is an example of **Structural** VHDL

library ieee;                  
use ieee.std_logic_1164.all;	
entity EXOR8 IS					
port
	(
		IN1   :  IN	BIT;		
		IN2   :  IN	BIT;	
		IN3   :  IN	BIT;		
		IN4   :  IN	BIT;	
		IN5   :  IN	BIT;		
		IN6   :  IN	BIT;	
		IN7   :  IN	BIT;		
		IN8   :  IN	BIT;	
		Y  	:  OUT	BIT		
	);
end EXOR8;

architecture logic of EXOR8 is  
-- Component Declaration
component EXOR2 port
	(
		A	:	in	bit;		
		B	:	in	bit;	
		Y	:	out	bit		
	);
end component ;

-- Temporary Intermediate Signals
signal temp1,temp2,temp3,temp4 	: bit;	-- first layer of XOR outputs
signal temp21,temp22			: bit;	-- second layer of XOR outputs

begin
-- component instantiation
exor_1:	exor2	port map(IN1,IN2,temp1);	-- first layer XORs
exor_2:	exor2	port map(IN3,IN4,temp2);
exor_3:	exor2	port map(IN5,IN6,temp3);
exor_4:	exor2	port map(IN7,IN8,temp4);
exor_5:	exor2	port map(temp1,temp2,temp21);	-- second layer XORs
exor_6:	exor2	port map(temp3,temp4,temp22);
exor_7:	exor2	port map(temp21,temp22,Y);	-- final output layer XOR
end logic;	

