library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
-- This is the SST39SF synchronous interface for the SST39SF01A, SST39SF020A and
--  SST39SF040 flash modules. This interface handles the address latching required
--  for the Out of the Box MAX-V Dev Board. Current implementation only handles the
--  read operation.
---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
entity SST39SF is
    PORT
    (
        ---------------------------------------------------------------------------------------
        -- General inputs
        ---------------------------------------------------------------------------------------
        CLK, RST                    : in  std_logic;
        
        ---------------------------------------------------------------------------------------
        -- Flash Control
        ---------------------------------------------------------------------------------------
        -- Go flag for state machine
        FL_EN                       : in std_logic;

        -- SST39SF Control Signals
        FL_CEn, FL_OEn, FL_WEn,
            FL_ALE                  : out std_logic;

        -- Data Buses
        FL_IO                       : inout std_logic_vector(7 downto 0);
        FL_RX                       : out   std_logic_vector(7 downto 0);

        -- Address Buses
        FL_addrIn                   : in std_logic_vector(18 downto 0);
        FL_addrOut                  : out std_logic_vector(10 downto 0)
    );

end SST39SF;

architecture BHV of SST39SF is
    ---------------------------------------------------------------------------------------
    -- state Machine Initializations
    ---------------------------------------------------------------------------------------
    type state_type is (IDLE,
                        R1, R2, R3
                        );
                        
    signal state, next_state : state_type;
    
    ---------------------------------------------------------------------------------------
    --  Internal Signals
    ---------------------------------------------------------------------------------------
    -- Bidirectional Bus Control
    signal flash2fabric         : std_logic_vector(7 downto 0);
    signal tri                  : std_logic;
    
    -- Buffers
    alias  FL_addrLow   is FL_addrIn(7 downto 0);
    alias  FL_addrHigh  is FL_addrIn(18 downto 8);
    signal FL_IObuff            : std_logic_vector(7  downto 0);
    
begin

    ---------------------------------------------------------------------------------------
    --  State Machine
    ---------------------------------------------------------------------------------------
    
    -- This is the first process of the two process state machine. It handles the reset
    --  conditon and the changing of the states. This process also loads the flash2fabric
    --  buffer when in state R3.
    process(CLK, RST)
    begin
        if(RST = '1') then
            state           <= IDLE;
            
            flash2fabric    <= (others => '0');
            
        elsif(rising_edge(CLK)) then
            state           <= next_state;
            
            if (state = R3) then
                flash2fabric    <=  FL_IO;
            end if;
        end if;
    end process;
    
    -- This is the second process of the two process state machine. It is responsible for
    --  waiting for the go signal, FL_EN, then handling the latch and bidirectional bus.
    --  It is currently only configured to read from the SST39SF flash module.
    process(state, FL_EN, FL_addrIn, FL_IO)
    begin       
        FL_IObuff   <= (others => ('0'));
        
        tri         <= '1';
        FL_CEn      <= '1';
        FL_OEn      <= '1';
        FL_WEn      <= '1';
        FL_ALE      <= '0';
        
        case state is
        -- Idle state is here to make sure there is enough time between operations to meet
        --  timing requirements. FL_EN is an active high signal used to signal the start of
        --  a read.
            when IDLE =>
                if (FL_EN = '1') then
                    next_state  <= R1;
                else
                    next_state <= IDLE;
                end if;
             
            -- Read state 1 (R1) is used to set up the address. During this time, OE should be 
            --  high to insure the data bus is high Z. 
            when R1 =>
                next_state  <= R2;
                
            when R2 =>
                -- Since the latch is transparent, the full address should be on the address bus. This 
                --  also insures that after this state, the data on the data bus should be valid.
                FL_IObuff   <= FL_addrLow;
                
                FL_CEn      <= '0';
                FL_ALE      <= '1';
                
                tri         <= '0';
                
                next_state  <= R3;
            
            -- Read state 3 (R3) is the actual read state. At this point in time, the data on FL_IO
            --  should be valid. Because every read will require a change in direction of FL_IO, the
            --  read data is stored in a buffer (flash2fabric). This makes it so the user may continuously
            --  read FL_RX without hiccups.
            when R3 =>                
                -- DEVELOPER NOTE: Originally, this was going to go back to R1. However, the time between
                --  when OE or CE goes high and when the output of the data bus is high Z is 25ns. Chances
                --  are, there will be a race condition with outputting the lower address lines and the FLASH
                --  having data on the lines. Since it may not want to read again anyway, it's best to return
                --  to IDLE and check the FL_EN flag to give it some extra time.

                FL_CEn      <= '0';
                FL_OEn      <= '0';
                
                next_state  <= IDLE;
                

            when OTHERS =>
                null;
                
        end case;        
    end process;
    
    ---------------------------------------------------------------------------------------
    -- Additional Housekeeping
    ---------------------------------------------------------------------------------------
    FL_addrOut  <= FL_addrHigh;
    
    FL_IO       <= FL_IObuff when tri = '0'
                    else (others => 'Z');
                    
    FL_RX       <= flash2fabric;
 
end BHV;