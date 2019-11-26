library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

---------------------------------------------------------------------------------------
-- Controller and entities involved in FTDI communications with the MAX-V CPLD.
--  The current design requries that all packets are the same size (5 bytes). This will
--  be modified later to accept variable length packets (if it proves to be more
--  efficient).
---------------------------------------------------------------------------------------
entity FTDI_coms is
    PORT
    (
        -- General Inputs
        clk, rst            : in  std_logic;

        -- FTDI Control Signals
        RXF_n, TXE_n        : in  std_logic;
        RD_n, WR_n          : out std_logic;
        SIWU                : out std_logic;

        -- Data Buses
        data_ftdi           : inout std_logic_vector(7 downto 0);
        FT_tx               : in    std_logic_vector(7 downto 0);
        FT_rx               : out   std_logic_vector(7 downto 0);
        
        -- Coms control
        FT_wrdy, FT_rrdy    : out std_logic;
        FT_wen, FT_pop,
            FT_flush        : in  std_logic;

        -- RX/TX LEDs
        FT_RX_LED, FT_TX_LED: out std_logic
    );
end FTDI_coms;

architecture BHV of FTDI_coms is
    ---------------------------------------------------------------------------------------
    -- State Machine.
    ---------------------------------------------------------------------------------------
    type state_type is (INIT, IDLE, R1, R2, W1, W2);
    signal state, next_state : state_type;

    ---------------------------------------------------------------------------------------
    -- Signals used to connect to and recieve data from the FT240x controller.
    ---------------------------------------------------------------------------------------
    signal ftdi_start               : std_logic := '0';
    signal rw                       : std_logic := '1';
    signal RXF, TXE, RD, WR         : std_logic := '0';
    signal data_RX                  : std_logic_vector(7 downto 0) := (others => '0');

    ---------------------------------------------------------------------------------------
    -- Signals used to control RXBUF.
    ---------------------------------------------------------------------------------------
    signal push, flush, FIFO_flush  : std_logic := '0';
    signal empty, full              : std_logic := '0';
    signal FT_rrdy_buf, FT_rrdy_reg : std_logic := '0';

begin
    FTDI: entity work.FT240X 
        port map 
        (
            clk         => clk,
            rst         => rst,
            ftdi_en     => ftdi_start,
            rw          => rw,
            RXF         => RXF,
            TXE         => TXE,
            RXF_n       => RXF_n,
            TXE_n       => TXE_n,
            RD          => RD,
            WR          => WR,
            RD_n        => RD_n,
            WR_n        => WR_n,
            data_ftdi   => data_ftdi,
            data_RX     => data_RX,
            data_TX     => FT_tx
        );

---------------------------------------------------------------------------------------
-- Currently using a 8x8 FIFO that signals almost full at 5 elements. Eventually this
--  can be reworked to accept packets that are less than or equal to 8 elements.
---------------------------------------------------------------------------------------
    RXBUF: ENTITY work.FIFO8x8_5
        PORT MAP
        (
            aclr        => rst,
            clock       => clk,
            data        => data_RX,
            rdreq       => FT_pop,
            sclr        => FIFO_flush,
            wrreq       => push,
            almost_full => full, -- almost full at 5
            empty       => empty,
            q           => FT_rx
        );

    -- FIFO is able to be flushed from either inside or outside the controller.
    FIFO_flush <= (flush or FT_flush);

    ---------------------------------------------------------------------------------------
    --  This process handles the DFFs for the state machine.
    ---------------------------------------------------------------------------------------
    process(clk, rst)
    begin
        if(rst = '1') then
            state       <= INIT;
        elsif(clk'event and clk = '1') then
            state <= next_state;
        end if;
    end process;

    ---------------------------------------------------------------------------------------
    -- The actual FSM.
    ---------------------------------------------------------------------------------------
    process(state, RXF, RD, WR, TXE, empty, full, TXE_n, RXF_n, data_RX, FT_wen, FT_rrdy_reg)
    begin
        ftdi_start  <= '0'; -- Signal used to start read or write to FTDI device
        rw          <= '1'; -- R_/W signal, default to read
        FT_wrdy     <= '0'; -- signal used to signal out the controller is ready to write

        -- FIFO
        push        <= '0'; -- Signals a push to the FIFO when reading
        flush       <= '0'; -- sync flush of FIFO

        -- LEDs
        FT_RX_LED   <= '1';
        FT_TX_LED   <= '1';

        case state is
            when INIT =>
                flush <= '1';
                next_state <= IDLE;

            when IDLE =>
                if (FT_wen = '0') then
                    -- If the FTDI_coms is set to read (default)
                    if (RXF = '1' and FT_rrdy_reg = '0') then
                        -- If there is data to be read, and the packet FIFO requires more data,
                        --  go to R1
                        next_state <= R1;
                    else
                        -- If there is nothing to read, IDLE.
                        next_state <= IDLE;
                    end if;
                else
                    -- If the FTDI_coms is set to write
                    if (TXE = '1') then
                        -- If there is data that can be written, try to write.
                        next_state <= W1;
                    else
                        -- If there is nothing to write, IDLE.
                        next_state <= IDLE;
                    end if;
                end if;

            ---------------------------------------------------------------------------------------
            -- Read Cycle
            ---------------------------------------------------------------------------------------    
            when R1 =>
                if (RD = '1') then
                    if (empty = '1' and data_RX = x"55") then
                        -- Push the data into the FIFO
                        push   <= '1';
                    elsif (empty = '0' and full = '0') then
                        push <= '1';
                    end if;

                    -- Turn on the RX LED
                    FT_RX_LED   <= '0';
                    next_state  <= R2;
                else
                    -- To initialize a read, ftdi_start must be true and r_/w must be 1.
                    --  Holding these signals will keep the data ready until it can be
                    --  pushed to the FIFO.
                    ftdi_start <= '1';
                    rw <= '1';
                    
                    next_state  <= R1;
                end if;

            -- This state is a fragment left over from something else.
            when R2 =>
                -- Turn on the RX LED
                FT_RX_LED   <= '0';
                next_state <= IDLE;

            ---------------------------------------------------------------------------------------
            -- Write Cycle
            ---------------------------------------------------------------------------------------
            when W1 =>
                -- FT_wrdy indicated that the coms controller is in write mode and is ready for data to
                --  transmit.
                FT_wrdy <= '1';

                -- To trigger a write, the user must put the proper data on the bus then toggle ft_wen
                --  from high to low.
                if (ft_wen = '1') then
                    -- If ft_wen is still high, wait.
                    next_state <= W1;
                else
                    -- To initilize the write, ftdi_start must be trie and r_/w must be 0.
                    ftdi_start <= '1';
                    rw <= '0';

                    -- Turn on the TX LED
                    FT_TX_LED   <= '0';
                    next_state <= W2;
                end if;

                
            when W2 =>
                -- This state polls the WR flag, which indicates that the write is in progress.
                if ( WR = '1') then
                    -- While write is in progress, wait.
                    next_state <= W2;
                else
                    -- When write is complete, IDLE.
                    next_state <= IDLE;
                end if;

                -- Turn on the TX LED
                FT_TX_LED   <= '0';

            when OTHERS =>
                null;
        end case;
    end process;

    ---------------------------------------------------------------------------------------
    -- Send Immediate/Wake up (active low)
    --  Still not sure what this pin is really good for... For now it's best to pull this
    --  pin high.
    ---------------------------------------------------------------------------------------
    SIWU <= '1';

    ---------------------------------------------------------------------------------------
    -- Packet Ready Flag
    --  This flag is used to signal that a complete packet has been recieved and is ready
    --  to be processed. At this time, the COMS driver should NOT try to load more data.
    --  The flag is set when the FIFO is full and cleared when the FIFO is empty. Anything
    --  in between the DFF will hold its current value.
    ---------------------------------------------------------------------------------------
    process(rst, clk, full, empty, FT_rrdy_buf)
    begin
        if (rst = '1' or empty = '1') then
            FT_rrdy_reg <= '0';
        elsif ( full = '1') then
            FT_rrdy_reg <= '1';
        elsif (clk'event and clk = '1') then
            FT_rrdy_reg <= FT_rrdy_buf;
        end if;

    end process;

    FT_rrdy_buf <= FT_rrdy_reg;
    FT_rrdy <= FT_rrdy_reg;

end BHV;