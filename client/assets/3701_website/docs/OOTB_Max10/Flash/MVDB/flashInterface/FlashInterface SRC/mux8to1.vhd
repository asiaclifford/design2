library IEEE;
use IEEE.std_logic_1164.all;

-------------------------------------------------------------------------------------------
-- This is just a very basic, generic, 8-to-1 mux
-------------------------------------------------------------------------------------------
entity mux8to1 is
    GENERIC 
    (
        width : positive        := 8
    );

    PORT
    (
        sel                     : in std_logic_vector(2 downto 0);
        A, B, C, D, E, F, G, H  : in std_logic_vector(width-1 downto 0);
        output                  : out STD_LOGIC_VECTOR(WIDTH-1 downto 0)
    );
end mux8to1;

architecture BHV of mux8to1 is
begin
    process(sel, A, B, C, D, E, F, G, H)
    begin
        case sel is
            WHEN "000" =>
                output <= A;
            WHEN "001" =>
                output <= B;
            WHEN "010" =>
                output <= C;
            WHEN "011" =>
                output <= D;
            WHEN "100" =>
                output <= E;
            WHEN "101" =>
                output <= F;
            WHEN "110" =>
                output <= G;
            WHEN "111" =>
                output <= H;
            WHEN OTHERS =>
                output <= (OTHERS => '0');
        end case;
    end process;
end BHV;