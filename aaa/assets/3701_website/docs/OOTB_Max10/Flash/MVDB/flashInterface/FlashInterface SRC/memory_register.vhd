library IEEE;
use IEEE.std_logic_1164.all;

-------------------------------------------------------------------------------------------
-- A 15-bit wide register using the generic register entity. The 8-bit register is used to
--  load the low byte first. When the user loads the high byte, it will load all 15-bits
--  at the same time. This prevents random data entering the IO bus while changing address
--  bits.
-------------------------------------------------------------------------------------------
entity memory_register is
    PORT
    (
        clk, rst, ld_l, ld_h    : in STD_LOGIC;
        input                   : in STD_LOGIC_VECTOR(7 downto 0);
        output                  : out STD_LOGIC_VECTOR(14 downto 0)
    );
end memory_register;

architecture BHV of memory_register is

signal addr_low     : std_logic_vector(7 downto 0);
signal addr_full    : std_logic_vector(14 downto 0);

begin

    ADDR_L_REG : entity work.generic_register
        GENERIC MAP 
        (
            width => 8
        )
        PORT MAP
        (
            clk     => clk,
            rst     => rst,
            ld      => ld_l,
            input   => input,
            output  => addr_low
        );
        
    ADDR_FULL_REG : entity work.generic_register
        GENERIC MAP 
        (
            width => 15
        )
        PORT MAP
        (
            clk     => clk,
            rst     => rst,
            ld      => ld_h,
            input   => addr_full,
            output  => output
        );
        
        addr_full <= (input(6 downto 0) & addr_low);
end BHV;
