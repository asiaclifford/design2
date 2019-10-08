library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

---------------------------------------------------------------------------------------
-- Top level interface for flash modules. Based roughly on the ATMEL AT28C256.
---------------------------------------------------------------------------------------
entity flashInterface is
    PORT
    (
        ---------------------------------------------------------------------------------------
        -- General inputs
        ---------------------------------------------------------------------------------------
        
        CLK, RST                    : in std_logic;

        ---------------------------------------------------------------------------------------
        -- User Interface
        ---------------------------------------------------------------------------------------
        -- Control Signals
        CEn, OEn, WEn               : in std_logic;

        -- Data Bus
        IO                          : out std_logic_vector(7 downto 0);

        -- Address Bus
        A                           : in std_logic_vector(14 downto 0);
        
        ---------------------------------------------------------------------------------------
        -- Fabric Interface
        ---------------------------------------------------------------------------------------
        FL_CEn, FL_OEn, FL_WEn,
            FL_ALE                  : out std_logic;
        FL_IO                       : inout std_logic_vector(7 downto 0);
        FL_AddrOut                  : out std_logic_vector(10 downto 0)
    );
end flashInterface;

architecture TOP of flashInterface is
    ---------------------------------------------------------------------------------------
    -- state Machine Initializations
    ---------------------------------------------------------------------------------------
    type state_type is (IDLE,
                        READ_FLASH
                        );
    signal state, next_state        : state_type;
    
    ---------------------------------------------------------------------------------------
    -- Interface Signals
    ---------------------------------------------------------------------------------------
    -- Flash control
    signal FL_EN                    : std_logic := '0';
    
    -- Data
    signal FL_RX                    : std_logic_vector(7 downto 0) := (others => '0');
    
    -- Address
    signal addr                     : std_logic_vector(18 downto 0);
          
begin
    -- The actual flash module has 19 address lines, not 15. To accomodate this, we simply
    --  use an intermediate signal to resize the address bus.
    addr <= std_logic_vector(resize(unsigned(A), 19));

    -- This is the actual flash interfect designed specifically for the SST39SF series of
    --  flash chips. This is the interface that will handle the latching of the address
    --  bus to get the full range.
FLASH   : entity work.SST39SF
            PORT MAP
            (
                -- General
                CLK         => CLK,
                RST         => RST,
                -- Inputs
                FL_EN       => FL_EN,

                -- Outputs
                FL_CEn      => FL_CEn,
                FL_OEn      => FL_OEn,
                FL_WEn      => FL_WEn,
                FL_ALE      => FL_ALE,
                -- Data Buses
                FL_IO       => FL_IO,
                FL_RX       => FL_RX,

                -- Address Buses
                FL_addrIn   => addr,
                FL_addrOut  => FL_addrOut
          
            );
            
    -- This is the first process of the two process state machine. It handles the reset
    --  conditon and the changing of the states.
    process(CLK, RST)
    begin
        if(RST = '1') then
            state               <= IDLE;
        elsif(rising_edge(CLK)) then
            state               <= next_state;
        end if;
    end process;
    
    -- This is the second process of the two process state machine. All this interface does
    --  is enable the read cycle when the signals are telling it to read. Otherwise, it sits
    --  in IDLE and does nothing.
    process(state, CEn, WEn, OEn)
    begin
        FL_EN       <= '0';
        
        case state is
            when IDLE =>
                if (CEn = '0' and OEn = '0' and WEn = '1') then
                    next_state <= READ_FLASH;
                else
                    next_state <= IDLE;
                end if;
                
            when READ_FLASH =>
                FL_EN <= '1';
                
                if (CEn = '0' and OEn = '0' and WEn = '1') then
                    next_state  <= READ_FLASH;
                else
                    next_state <= IDLE;
                end if;
                
            when OTHERS =>
                null;
        end case;
    end process;
    
    IO <= FL_RX;
    
end TOP;