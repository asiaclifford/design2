library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

---------------------------------------------------------------------------------------
-- The purpose of this FT240x controller is to act as a synchronous interface.
---------------------------------------------------------------------------------------
entity FT240X is
    PORT
    (
        ---------------------------------------------------------------------------------------
        -- General Inputs
        ---------------------------------------------------------------------------------------
        clk, rst, ftdi_en,
            rw                  : in    std_logic;

        ---------------------------------------------------------------------------------------
        -- FTDI Control Signals
        ---------------------------------------------------------------------------------------
        RXF_n, TXE_n            : in    std_logic;
        RD_n, WR_n              : out   std_logic;
        
        -- Flags
        RXF, TXE                : out   std_logic;
        RD, WR                  : out   std_logic;

        ---------------------------------------------------------------------------------------
        -- Data Buses
        ---------------------------------------------------------------------------------------
        data_ftdi               : inout std_logic_vector(7 downto 0);
        data_RX                 : out   std_logic_vector(7 downto 0);
        data_TX                 : in    std_logic_vector(7 downto 0)
    );
end FT240X;

architecture BHV of FT240X is
    -- State Machine
    type state_type is (IDLE, R1, R2, W1, W2);
    signal state, next_state : state_type;

    -- Bidirectional Bus
    signal tri                      : std_logic;
    signal data_ftdi2fabric         : std_logic_vector(7 downto 0);

    -- Flags
    signal RXF_flag, TXE_flag
                                    : std_logic;

begin
    ---------------------------------------------------------------------------------------
    ---------------------------------------------------------------------------------------
    -- This interface is designed around the FT240x 12MHz clock. Running this driver any
    --  faster may induce race conditions. Theoretocal max speed is 20MHz.
    ---------------------------------------------------------------------------------------
    ---------------------------------------------------------------------------------------

    ---------------------------------------------------------------------------------------
    -- This process handles instanciation of the DFFs for the buffers and state machine.
    ---------------------------------------------------------------------------------------
    process(clk, rst)
    begin
        if(rst = '1') then
            state <= IDLE;
            RXF_flag            <= '1';
            TXE_flag            <= '1';
        elsif(clk'event and clk = '1') then
            state               <= next_state;
            RXF_flag            <= RXF_n;
            TXE_flag            <= TXE_n;
        end if;
    end process;

    ---------------------------------------------------------------------------------------
    -- The actual FSM.
    ---------------------------------------------------------------------------------------
    process(state, data_ftdi, data_ftdi2fabric, ftdi_en, rw, TXE_n, RXF_n)
    begin
        RD      <= '0';  -- Simple flag to signal valid data on bus
        WR      <= '0';  -- Simple flag to signal write is complete
        
        WR_n    <= '0';
        RD_n    <= '1';
        
        tri     <= '1';
        
        case state is
            when IDLE =>
                -- ftdi_en is used to start the reading or writing process.
                --  If ftdi_en is low, then stay in the idle state.
                if (ftdi_en = '0') then
                    next_state <= IDLE;
                else
                    -- Once ftdi_en is high, make sure one of the operations is available.
                    if ((rw = '0') and (TXE_n = '0')) then
                        -- If r_/w is 0, then make sure that FTDI is able to transmit.
                        --  If so, then go to W1
                        next_state <= W1;
                    elsif ((rw = '1') and (RXF_n = '0')) then
                        -- If r_/w is 1, then make sure that FTDI is able to recieve.
                        --  If so, then go to R1
                        next_state <= R1;
                    else
                        -- If neither writing nor reading is available, then stay in IDLE.
                        next_state <= IDLE;
                    end if;
                end if;

            when R1 =>
                -- Reading requires that the RD_n strobe is low for at least 50ns. The data
                --  will be valid at this point. 1 clock cycle at 12 MHz is 83 ns.
                RD_n <= '0';
                next_state <= R2;

            when R2 =>
                -- This is the retrieve state. The output RD indicated that the data on the
                --  data_RX bus is valid data.
                RD_n <= '0';
                RD <= '1';
                
                -- The user may use FTDI_en to control how long this data sits on the bus. As
                --  long as ftdi_en is held high, the data will stay.
                if (ftdi_en = '1') then
                    next_state <= R2;
                else
                    -- If ftdi_en goes low, then the controller goes to the last state, which
                    --  waits until the FTDI signals show complete.
                    next_state <= IDLE;
                end if;

            when W1 =>
                -- To read, WR_n must be high for at least 50 ns. This state is used to hold it high
                --  for one clock cycle (should be about 83 ns).
                WR <= '1';
                WR_n <= '1';
                tri <= '0';
                next_state <= W2;

            when W2 =>
                -- The falling edge of WR_n occurs here. This is the finial state of the write
                --  cycle.
                WR <= '1';
                if (TXE_n = '0') then
                    next_state <= IDLE;
                else
                    next_state <= W2;
                end if;

            when OTHERS =>
                null;

        end case;
    end process;
    
    ---------------------------------------------------------------------------------------
    -- FTDI 240x Flags
    ---------------------------------------------------------------------------------------
    RXF <= not RXF_flag;
    TXE <= not TXE_flag;

    ---------------------------------------------------------------------------------------
    -- I/O for FTDI 240x
    ---------------------------------------------------------------------------------------
    data_ftdi <= data_tx when tri = '0'
        else (others => 'Z');

    ---------------------------------------------------------------------------------------
    -- RX for fabric
    ---------------------------------------------------------------------------------------
    data_RX <= data_ftdi;

end BHV;