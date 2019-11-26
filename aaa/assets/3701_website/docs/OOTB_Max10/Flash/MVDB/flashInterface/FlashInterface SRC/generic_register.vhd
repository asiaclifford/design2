library IEEE;
use IEEE.std_logic_1164.all;

-------------------------------------------------------------------------------------------
-- A simple implementation of a generic-width register.
-------------------------------------------------------------------------------------------
entity generic_register is
    GENERIC 
    (
        WIDTH : POSITIVE    := 8
    );

    PORT
    (
        clk, rst, ld        : in STD_LOGIC;
        input               : in STD_LOGIC_VECTOR(WIDTH-1 downto 0);
        output              : out STD_LOGIC_VECTOR(WIDTH-1 downto 0)
    );
end generic_register;

architecture generic_register of generic_register is
    signal output_signal, input_signal : STD_LOGIC_VECTOR(WIDTH-1 downto 0);
begin

    -- 2-to-1 mux to load or hold the register value
    process(ld, input, output_signal)
    begin
        case ld is
            WHEN '0' =>
                input_signal <= output_signal;
            WHEN '1' =>
                input_signal <= input;
            WHEN OTHERS =>
                input_signal <= (OTHERS => '0');
        end case;
    end process;

    -- This process is used to create the DFFs for the register.
    process(clk, rst)
    begin
        if(rst = '0') then
            if(rising_edge(clk)) then
                output_signal <= input_signal;
            end if;
        else
            output_signal <= (others => '0');
        end if;
    end process;

    -- Connect the internal output signal to the output signal.
    output <= output_signal;

end generic_register;