library IEEE;
use IEEE.std_logic_1164.all;

-------------------------------------------------------------------------------------------
-- This is just a very basic, generic, 2-to-1 mux
-------------------------------------------------------------------------------------------
entity mux2to1 is
    GENERIC 
    (
        width : positive    := 8
    );

    PORT
    (
        sel                 : in std_logic;
        A, B                : in std_logic_vector(width-1 downto 0);
        output              : out STD_LOGIC_VECTOR(WIDTH-1 downto 0)
    );
end mux2to1;

architecture BHV of mux2to1 is
begin
    process(sel, A, B)
    begin
        case sel is
            WHEN '0' =>
                output <= A;
            WHEN '1' =>
                output <= B;
            WHEN OTHERS =>
                output <= (OTHERS => '0');
        end case;
    end process;
end BHV;