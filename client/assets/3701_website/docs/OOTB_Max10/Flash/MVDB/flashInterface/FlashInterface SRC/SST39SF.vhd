library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-------------------------------------------------------------------------------------------
-- This is the SST39SF synchronous interface for the SST39SF01A, SST39SF020A and
--  SST39SF040 flash modules.
-------------------------------------------------------------------------------------------
entity SST39SF is
    PORT
    (
        -- General Inputs
        clk, rst, write_en,
         flash_en, chip_erase       : in  std_logic;

        -- SST39SF Control Signals
        CE_n, OE_n, WE_n, ALE       : out std_logic;
        
        -- Flags
        writing, reading, polling   : out std_logic;

        -- Data Buses
        data_flash                  : inout std_logic_vector(7 downto 0);
        data_in                     : out   std_logic_vector(7 downto 0);
        data_out                    : in    std_logic_vector(7 downto 0);

        -- Address Buses
        addr_in                     : in std_logic_vector(18 downto 0);
        addr_out                    : out std_logic_vector(10 downto 0)
    );

end SST39SF;

architecture BHV of SST39SF is
    -- State Machine
    type state_type is (IDLE,
                        R1, R2, R3, R4, R5,
                        W1 , W2 , W3 , W4 , W5 , W6 , W7 , W8 , W9 , W10, W11, W12,
                        W13, W14, W15, W16, W17, W18, W19, W20, W21, W22, W23, W24,
                        CE1 , CE2 , CE3 , CE4 , CE5 , CE6 , CE7 , CE8 , CE9 , CE10, CE11, CE12,
                        CE13, CE14, CE15, CE16, CE17, CE18, CE19, CE20, CE21, CE22, CE23, CE24,
                        CE25, CE26, CE27, CE28, CE29, CE30, CE31, CE32, CE33, CE34, CE35, CE36,
                        POLL1, POLL2, POLL3, POLL4, POLL5,
                        W_POLL1, W_POLL2, W_POLL3, W_POLL4, W_POLL5
                        );
    signal state, next_state : state_type;

    ---------------------------------------------------------------------------------------
    --  All buses and SST39SF control signals will go through buffers to prevent glitches.
    ---------------------------------------------------------------------------------------
    -- Bidirectional Bus
    signal data_flash2fabric    : std_logic_vector(7 downto 0);
    signal data_fabric2flash    : std_logic_vector(7 downto 0);
    signal tri_buf, tri_reg	    : std_logic;

    -- Control
    signal CE_buf, CE_reg       : std_logic;
    signal OE_buf, OE_reg       : std_logic;
    signal WE_buf, WE_reg       : std_logic;
    signal ALE_buf, ALE_reg     : std_logic;

    -- Buffers
    signal addr_buf, addr_reg   : std_logic_vector(10 downto 0);
    alias addr_in_lw is addr_in(7 downto 0);
    alias addr_in_hi is addr_in(18 downto 8);
    signal data_buf             : std_logic_vector(7  downto 0);
    signal poll_buf             : std_logic_vector(7  downto 0);
    
begin

    ---------------------------------------------------------------------------------------
    --  This process handles instanciation of the DFFs for the buffers and state machine.
    ---------------------------------------------------------------------------------------
    process(clk, rst)
    begin
        if(rst = '1') then
            state                   <= IDLE;
            tri_reg                 <= '1';
            CE_reg                  <= '1';
            OE_reg                  <= '1';
            WE_reg                  <= '1';
            ALE_reg                 <= '0';
            addr_reg                <= (others => '0');
            data_flash2fabric       <= (others => '0');
            data_fabric2flash       <= (others => '0');
            poll_buf                <= (others => '0');
        elsif(clk'event and clk = '1') then
            state                   <= next_state;
            tri_reg                 <= tri_buf;
            CE_reg                  <= CE_buf;
            OE_reg                  <= OE_buf;
            WE_reg                  <= WE_buf;
            ALE_reg                 <= ALE_buf;
            addr_reg                <= addr_buf;
            data_fabric2flash       <= data_buf;

            if (state = R5) then
                data_flash2fabric   <= data_flash;
            end if;

            if (state = W_POLL4 OR
                state = POLL4
                ) then
                poll_buf <= data_flash;
            end if;

        end if;
    end process;

    ---------------------------------------------------------------------------------------
    -- The actual Finite Stae Machine (FSM). This state machine is used to handle sending
    --  the SST39SF the byte commands for operation. It also handles the address latching
    --  per the implementation of the OOTB MAX-V board.
    ---------------------------------------------------------------------------------------
    process(state, write_en, flash_en, chip_erase, addr_in, data_out, data_flash, poll_buf)
    begin
        next_state  <= state;
        addr_buf    <= addr_in_hi;
        data_buf    <= (others => ('0'));
        writing     <= '0';
        reading     <= '0';
        polling     <= '0';

        case state is
        ---------------------------------------------------------------------------------------
        -- Idle state is here to make sure there is enough time between operations to meet
        --  timing requirements. flash_en is an active high signal used to make it so you can
        --  disable the flash for setting up writes and chip erase. The default behavior of this
        --  interface is to set the flash to READ mode. write_en is an active high flag to
        --  signal the intent to write a byte of data into the flash module.
        ---------------------------------------------------------------------------------------
            when IDLE =>
                if (flash_en = '1') then
                    if (chip_erase = '1') then
                        writing     <= '1';
                        next_state  <= CE1;
                    elsif (write_en = '1') then
                        writing     <= '1';
                        next_state  <= W1;
                    else
                        next_state  <= R1;
                    end if;
                else
                    next_state <= IDLE;
                end if;

            ---------------------------------------------------------------------------------------
            ---------------------------------------------------------------------------------------
            --                                    READ STATES                                    --
            ---------------------------------------------------------------------------------------
            ---------------------------------------------------------------------------------------

            ---------------------------------------------------------------------------------------
            -- Read states 1 through 3 (R1 - R3) are used to set up the address. During this time,
            --  OE should be high to insure the data bus is high Z. 
            ---------------------------------------------------------------------------------------
            when R1 =>
                data_buf    <= addr_in_lw;
                next_state  <= R2;

            ---------------------------------------------------------------------------------------
            -- Since the latch is transparent, the full address should be on the address bus. The 
            --  R2 state will hold the data on the bus to satisfy the set-up time for the latch.
            ---------------------------------------------------------------------------------------
            when R2 =>
                data_buf    <= addr_in_lw;
                next_state  <= R3;

            ---------------------------------------------------------------------------------------
            -- The R3 state will continue to output the lower 8-bits of the address to satisy the
            --  hold time of the latch.
            ---------------------------------------------------------------------------------------
            when R3 =>
                next_state  <= R4;

            ---------------------------------------------------------------------------------------
            -- R4 is here to ensure that all required control signals and the address are set
            --  correctly and meet all set-up times.
            ---------------------------------------------------------------------------------------
            when R4 =>
                next_state  <= R5;

            ---------------------------------------------------------------------------------------
            -- Read state 5 (R5) is the actual read state. At this point in time, the data on the
            --  bus should be valid. The data that is read will be put into a register.
            --
            -- Developer note: The way I load the register, I shouldn't actually need this. The
            --  register loads at the end of the state, meaning that it should be good to go at
            --  the end of R4. I'll leave this here for now, and remove if it's a problem.
            --------------------------------------------------------------------------------------- 
            when R5 =>
                reading     <= '1'; 
                next_state  <= IDLE;

            ---------------------------------------------------------------------------------------
            ---------------------------------------------------------------------------------------
            --                                   WRITE STATES                                    --
            ---------------------------------------------------------------------------------------
            ---------------------------------------------------------------------------------------

            ---------------------------------------------------------------------------------------
            -- This interface uses the WE# controlled programming cycle. The following pattern is
            --  is used while strobing the WE_n flag:
            --      1) Write 0xAA to address 0x5555
            --      2) Write 0x55 to address 0x2AAA
            --      3) Write 0xA0 to address 0x5555
            --      4) Write DATA to address ADDR
            --
            --  The setup and hold times are as follows:
            --      Twp:    WE# pulse width         -   40nS
            --      Twph:   WE# pulse width high    -   30nS
            --      Tas:    Address setup time      -   00nS
            --      Tah:    Address hold time       -   30nS
            --      Tcs:    WE# and CE# setup time  -   00nS
            --      Tch:    WE# and CE# hold time   -   00nS
            --      Tds:    Data setup time         -   40nS
            --      Tdh:    Data hold time          -   00nS
            ---------------------------------------------------------------------------------------

            ---------------------------------------------------------------------------------------
            -- Write states W1, W2, and W3 are primarily used to set up the address in the latch.
            --  The first state, W1, primes the output buffers.
            ---------------------------------------------------------------------------------------
            when W1 =>
                writing     <= '1';

                addr_buf    <= std_logic_vector(to_unsigned(16#55#, addr_buf'length));
                data_buf    <= std_logic_vector(to_unsigned(16#55#, data_buf'length));

                next_state  <= W2;

            ---------------------------------------------------------------------------------------
            -- The address should be fully output at this time, since the address latch is trans-
            --  parent.I have one more address state after this to ensure 0x5555 is locked in.
            ---------------------------------------------------------------------------------------
            when W2 =>
                writing     <= '1'; 

                addr_buf    <= std_logic_vector(to_unsigned(16#55#, addr_buf'length));
                data_buf    <= std_logic_vector(to_unsigned(16#55#, data_buf'length));

                next_state  <= W3;

            ---------------------------------------------------------------------------------------
            -- The last address state is here to satisfy the latch hold time. Since the data is
            --  coming out of a buffer, we can prime data_buf with the data we wish to write. Also,
            --  since the address has been stable since the last cycle, the address setup time
            --  should be satisfied.
            ---------------------------------------------------------------------------------------
            when W3 =>
                writing <= '1';

                addr_buf    <= std_logic_vector(to_unsigned(16#55#, addr_buf'length));
                data_buf    <= std_logic_vector(to_unsigned(16#AA#, data_buf'length));

                next_state <= W4;

            ---------------------------------------------------------------------------------------
            -- This is the first write state. The WE bit will go true, latching the address. The
            --  data to write should now be output on the bus as well.
            ---------------------------------------------------------------------------------------
            when W4 =>
                writing <= '1';

                addr_buf    <= std_logic_vector(to_unsigned(16#55#, addr_buf'length));
                data_buf    <= std_logic_vector(to_unsigned(16#AA#, data_buf'length));

                next_state <= W5;

            ---------------------------------------------------------------------------------------
            -- Depending on how fast the clock this, another state may be needed to meet the 40nS
            --  setup time. The WE bit is still true.
            ---------------------------------------------------------------------------------------
            when W5 =>
                writing <= '1';

                addr_buf    <= std_logic_vector(to_unsigned(16#55#, addr_buf'length));
                data_buf    <= std_logic_vector(to_unsigned(16#AA#, data_buf'length));

                next_state <= W6;

            ---------------------------------------------------------------------------------------
            -- This is the last write state. The data and address will still be output. The WE bit
            --  will now go false, latching in the 
            ---------------------------------------------------------------------------------------
            when W6 =>
                writing <= '1';

                next_state <= W7;

-------------------------------------------------------------------------------------------------------
            ---------------------------------------------------------------------------------------
            -- Write states W1, W2, and W3 are primarily used to set up the address in the latch.
            --  The first state, W1, primes the output buffers.
            ---------------------------------------------------------------------------------------
            when W7 =>
                writing     <= '1';

                addr_buf    <= std_logic_vector(to_unsigned(16#2A#, addr_buf'length));
                data_buf    <= std_logic_vector(to_unsigned(16#AA#, data_buf'length));

                next_state  <= W8;

            ---------------------------------------------------------------------------------------
            -- The address should be fully output at this time, since the address latch is trans-
            --  parent.I have one more address state after this to ensure 0x5555 is locked in.
            ---------------------------------------------------------------------------------------
            when W8 =>
                writing     <= '1'; 

                addr_buf    <= std_logic_vector(to_unsigned(16#2A#, addr_buf'length));
                data_buf    <= std_logic_vector(to_unsigned(16#AA#, data_buf'length));

                next_state  <= W9;

            ---------------------------------------------------------------------------------------
            -- The last address state is here to satisfy the latch hold time. Since the data is
            --  coming out of a buffer, we can prime data_buf with the data we wish to write. Also,
            --  since the address has been stable since the last cycle, the address setup time
            --  should be satisfied.
            ---------------------------------------------------------------------------------------
            when W9 =>
                writing <= '1';

                addr_buf    <= std_logic_vector(to_unsigned(16#2A#, addr_buf'length));
                data_buf    <= std_logic_vector(to_unsigned(16#55#, data_buf'length));

                next_state <= W10;

            ---------------------------------------------------------------------------------------
            -- This is the first write state. The WE bit will go true, latching the address. The
            --  data to write should now be output on the bus as well.
            ---------------------------------------------------------------------------------------
            when W10 =>
                writing <= '1';

                addr_buf    <= std_logic_vector(to_unsigned(16#2A#, addr_buf'length));
                data_buf    <= std_logic_vector(to_unsigned(16#55#, data_buf'length));

                next_state <= W11;

            ---------------------------------------------------------------------------------------
            -- Depending on how fast the clock this, another state may be needed to meet the 40nS
            --  setup time. The WE bit is still true.
            ---------------------------------------------------------------------------------------
            when W11 =>
                writing <= '1';

                addr_buf    <= std_logic_vector(to_unsigned(16#2A#, addr_buf'length));
                data_buf    <= std_logic_vector(to_unsigned(16#55#, data_buf'length));

                next_state <= W12;

            ---------------------------------------------------------------------------------------
            -- This is the last write state. The data and address will still be output. The WE bit
            --  will now go false, latching in the 
            ---------------------------------------------------------------------------------------
            when W12 =>
                writing <= '1';

                next_state <= W13;

-------------------------------------------------------------------------------------------------------
            ---------------------------------------------------------------------------------------
            -- Write states W1, W2, and W3 are primarily used to set up the address in the latch.
            --  The first state, W1, primes the output buffers.
            ---------------------------------------------------------------------------------------
            when W13 =>
                writing     <= '1';

                addr_buf    <= std_logic_vector(to_unsigned(16#55#, addr_buf'length));
                data_buf    <= std_logic_vector(to_unsigned(16#55#, data_buf'length));

                next_state  <= W14;

            ---------------------------------------------------------------------------------------
            -- The address should be fully output at this time, since the address latch is trans-
            --  parent.I have one more address state after this to ensure 0x5555 is locked in.
            ---------------------------------------------------------------------------------------
            when W14 =>
                writing     <= '1'; 

                addr_buf    <= std_logic_vector(to_unsigned(16#55#, addr_buf'length));
                data_buf    <= std_logic_vector(to_unsigned(16#55#, data_buf'length));

                next_state  <= W15;

            ---------------------------------------------------------------------------------------
            -- The last address state is here to satisfy the latch hold time. Since the data is
            --  coming out of a buffer, we can prime data_buf with the data we wish to write. Also,
            --  since the address has been stable since the last cycle, the address setup time
            --  should be satisfied.
            ---------------------------------------------------------------------------------------
            when W15 =>
                writing <= '1';

                addr_buf    <= std_logic_vector(to_unsigned(16#55#, addr_buf'length));
                data_buf    <= std_logic_vector(to_unsigned(16#A0#, data_buf'length));

                next_state <= W16;

            ---------------------------------------------------------------------------------------
            -- This is the first write state. The WE bit will go true, latching the address. The
            --  data to write should now be output on the bus as well.
            ---------------------------------------------------------------------------------------
            when W16 =>
                writing <= '1';

                addr_buf    <= std_logic_vector(to_unsigned(16#55#, addr_buf'length));
                data_buf    <= std_logic_vector(to_unsigned(16#A0#, data_buf'length));

                next_state <= W17;

            ---------------------------------------------------------------------------------------
            -- Depending on how fast the clock this, another state may be needed to meet the 40nS
            --  setup time. The WE bit is still true.
            ---------------------------------------------------------------------------------------
            when W17 =>
                writing <= '1';

                addr_buf    <= std_logic_vector(to_unsigned(16#55#, addr_buf'length));
                data_buf    <= std_logic_vector(to_unsigned(16#A0#, data_buf'length));

                next_state <= W18;

            ---------------------------------------------------------------------------------------
            -- This is the last write state. The data and address will still be output. The WE bit
            --  will now go false, latching in the 
            ---------------------------------------------------------------------------------------
            when W18 =>
                writing <= '1';

                next_state <= W19;

-------------------------------------------------------------------------------------------------------
            ---------------------------------------------------------------------------------------
            -- Write states W1, W2, and W3 are primarily used to set up the address in the latch.
            --  The first state, W1, primes the output buffers.
            ---------------------------------------------------------------------------------------
            when W19 =>
                writing     <= '1';

                data_buf    <= addr_in_lw;

                next_state  <= W20;

            ---------------------------------------------------------------------------------------
            -- The address should be fully output at this time, since the address latch is trans-
            --  parent.I have one more address state after this to ensure 0x5555 is locked in.
            ---------------------------------------------------------------------------------------
            when W20 =>
                writing     <= '1'; 

                data_buf    <= addr_in_lw;

                next_state  <= W21;

            ---------------------------------------------------------------------------------------
            -- The last address state is here to satisfy the latch hold time. Since the data is
            --  coming out of a buffer, we can prime data_buf with the data we wish to write. Also,
            --  since the address has been stable since the last cycle, the address setup time
            --  should be satisfied.
            ---------------------------------------------------------------------------------------
            when W21 =>
                writing <= '1';

                data_buf    <= data_out;

                next_state <= W22;

            ---------------------------------------------------------------------------------------
            -- This is the first write state. The WE bit will go true, latching the address. The
            --  data to write should now be output on the bus as well.
            ---------------------------------------------------------------------------------------
            when W22 =>
                writing <= '1';

                data_buf    <= data_out;

                next_state <= W23;

            ---------------------------------------------------------------------------------------
            -- Depending on how fast the clock this, another state may be needed to meet the 40nS
            --  setup time. The WE bit is still true.
            ---------------------------------------------------------------------------------------
            when W23 =>
                writing <= '1';

                data_buf    <= data_out;

                next_state <= W24;

            ---------------------------------------------------------------------------------------
            -- This is the last write state. The data and address will still be output. The WE bit
            --  will now go false, latching in the 
            ---------------------------------------------------------------------------------------
            when W24 =>
                writing <= '1';

                next_state <= W_POLL1;

-------------------------------------------------------------------------------------------------------





            ---------------------------------------------------------------------------------------
            -- Write states W1, W2, and W3 are primarily used to set up the address in the latch.
            --  The first state, W1, primes the output buffers.
            ---------------------------------------------------------------------------------------
            when CE1 =>
                writing     <= '1';

                addr_buf    <= std_logic_vector(to_unsigned(16#55#, addr_buf'length));
                data_buf    <= std_logic_vector(to_unsigned(16#55#, data_buf'length));

                next_state  <= CE2;

            ---------------------------------------------------------------------------------------
            -- The address should be fully output at this time, since the address latch is trans-
            --  parent.I have one more address state after this to ensure 0x5555 is locked in.
            ---------------------------------------------------------------------------------------
            when CE2 =>
                writing     <= '1'; 

                addr_buf    <= std_logic_vector(to_unsigned(16#55#, addr_buf'length));
                data_buf    <= std_logic_vector(to_unsigned(16#55#, data_buf'length));

                next_state  <= CE3;

            ---------------------------------------------------------------------------------------
            -- The last address state is here to satisfy the latch hold time. Since the data is
            --  coming out of a buffer, we can prime data_buf with the data we wish to write. Also,
            --  since the address has been stable since the last cycle, the address setup time
            --  should be satisfied.
            ---------------------------------------------------------------------------------------
            when CE3 =>
                writing <= '1';

                addr_buf    <= std_logic_vector(to_unsigned(16#55#, addr_buf'length));
                data_buf    <= std_logic_vector(to_unsigned(16#AA#, data_buf'length));

                next_state <= CE4;

            ---------------------------------------------------------------------------------------
            -- This is the first write state. The WE bit will go true, latching the address. The
            --  data to write should now be output on the bus as well.
            ---------------------------------------------------------------------------------------
            when CE4 =>
                writing <= '1';

                addr_buf    <= std_logic_vector(to_unsigned(16#55#, addr_buf'length));
                data_buf    <= std_logic_vector(to_unsigned(16#AA#, data_buf'length));

                next_state <= CE5;

            ---------------------------------------------------------------------------------------
            -- Depending on how fast the clock this, another state may be needed to meet the 40nS
            --  setup time. The WE bit is still true.
            ---------------------------------------------------------------------------------------
            when CE5 =>
                writing <= '1';

                addr_buf    <= std_logic_vector(to_unsigned(16#55#, addr_buf'length));
                data_buf    <= std_logic_vector(to_unsigned(16#AA#, data_buf'length));

                next_state <= CE6;

            ---------------------------------------------------------------------------------------
            -- This is the last write state. The data and address will still be output. The WE bit
            --  will now go false, latching in the 
            ---------------------------------------------------------------------------------------
            when CE6 =>
                writing <= '1';

                next_state <= CE7;

-------------------------------------------------------------------------------------------------------
            ---------------------------------------------------------------------------------------
            -- Write states W1, W2, and W3 are primarily used to set up the address in the latch.
            --  The first state, W1, primes the output buffers.
            ---------------------------------------------------------------------------------------
            when CE7 =>
                writing     <= '1';

                addr_buf    <= std_logic_vector(to_unsigned(16#2A#, addr_buf'length));
                data_buf    <= std_logic_vector(to_unsigned(16#AA#, data_buf'length));

                next_state  <= CE8;

            ---------------------------------------------------------------------------------------
            -- The address should be fully output at this time, since the address latch is trans-
            --  parent.I have one more address state after this to ensure 0x5555 is locked in.
            ---------------------------------------------------------------------------------------
            when CE8 =>
                writing     <= '1'; 

                addr_buf    <= std_logic_vector(to_unsigned(16#2A#, addr_buf'length));
                data_buf    <= std_logic_vector(to_unsigned(16#AA#, data_buf'length));

                next_state  <= CE9;

            ---------------------------------------------------------------------------------------
            -- The last address state is here to satisfy the latch hold time. Since the data is
            --  coming out of a buffer, we can prime data_buf with the data we wish to write. Also,
            --  since the address has been stable since the last cycle, the address setup time
            --  should be satisfied.
            ---------------------------------------------------------------------------------------
            when CE9 =>
                writing <= '1';

                addr_buf    <= std_logic_vector(to_unsigned(16#2A#, addr_buf'length));
                data_buf    <= std_logic_vector(to_unsigned(16#55#, data_buf'length));

                next_state <= CE10;

            ---------------------------------------------------------------------------------------
            -- This is the first write state. The WE bit will go true, latching the address. The
            --  data to write should now be output on the bus as well.
            ---------------------------------------------------------------------------------------
            when CE10 =>
                writing <= '1';

                addr_buf    <= std_logic_vector(to_unsigned(16#2A#, addr_buf'length));
                data_buf    <= std_logic_vector(to_unsigned(16#55#, data_buf'length));

                next_state <= CE11;

            ---------------------------------------------------------------------------------------
            -- Depending on how fast the clock this, another state may be needed to meet the 40nS
            --  setup time. The WE bit is still true.
            ---------------------------------------------------------------------------------------
            when CE11 =>
                writing <= '1';

                addr_buf    <= std_logic_vector(to_unsigned(16#2A#, addr_buf'length));
                data_buf    <= std_logic_vector(to_unsigned(16#55#, data_buf'length));

                next_state <= CE12;

            ---------------------------------------------------------------------------------------
            -- This is the last write state. The data and address will still be output. The WE bit
            --  will now go false, latching in the 
            ---------------------------------------------------------------------------------------
            when CE12 =>
                writing <= '1';

                next_state <= CE13;

-------------------------------------------------------------------------------------------------------
            ---------------------------------------------------------------------------------------
            -- Write states W1, W2, and W3 are primarily used to set up the address in the latch.
            --  The first state, W1, primes the output buffers.
            ---------------------------------------------------------------------------------------
            when CE13 =>
                writing     <= '1';

                addr_buf    <= std_logic_vector(to_unsigned(16#55#, addr_buf'length));
                data_buf    <= std_logic_vector(to_unsigned(16#55#, data_buf'length));

                next_state  <= CE14;

            ---------------------------------------------------------------------------------------
            -- The address should be fully output at this time, since the address latch is trans-
            --  parent.I have one more address state after this to ensure 0x5555 is locked in.
            ---------------------------------------------------------------------------------------
            when CE14 =>
                writing     <= '1'; 

                addr_buf    <= std_logic_vector(to_unsigned(16#55#, addr_buf'length));
                data_buf    <= std_logic_vector(to_unsigned(16#55#, data_buf'length));

                next_state  <= CE15;

            ---------------------------------------------------------------------------------------
            -- The last address state is here to satisfy the latch hold time. Since the data is
            --  coming out of a buffer, we can prime data_buf with the data we wish to write. Also,
            --  since the address has been stable since the last cycle, the address setup time
            --  should be satisfied.
            ---------------------------------------------------------------------------------------
            when CE15 =>
                writing <= '1';

                addr_buf    <= std_logic_vector(to_unsigned(16#55#, addr_buf'length));
                data_buf    <= std_logic_vector(to_unsigned(16#80#, data_buf'length));

                next_state <= CE16;

            ---------------------------------------------------------------------------------------
            -- This is the first write state. The WE bit will go true, latching the address. The
            --  data to write should now be output on the bus as well.
            ---------------------------------------------------------------------------------------
            when CE16 =>
                writing <= '1';

                addr_buf    <= std_logic_vector(to_unsigned(16#55#, addr_buf'length));
                data_buf    <= std_logic_vector(to_unsigned(16#80#, data_buf'length));

                next_state <= CE17;

            ---------------------------------------------------------------------------------------
            -- Depending on how fast the clock this, another state may be needed to meet the 40nS
            --  setup time. The WE bit is still true.
            ---------------------------------------------------------------------------------------
            when CE17 =>
                writing <= '1';

                addr_buf    <= std_logic_vector(to_unsigned(16#55#, addr_buf'length));
                data_buf    <= std_logic_vector(to_unsigned(16#80#, data_buf'length));

                next_state <= CE18;

            ---------------------------------------------------------------------------------------
            -- This is the last write state. The data and address will still be output. The WE bit
            --  will now go false, latching in the 
            ---------------------------------------------------------------------------------------
            when CE18 =>
                writing <= '1';

                next_state <= CE19;

-------------------------------------------------------------------------------------------------------
            ---------------------------------------------------------------------------------------
            -- Write states W1, W2, and W3 are primarily used to set up the address in the latch.
            --  The first state, W1, primes the output buffers.
            ---------------------------------------------------------------------------------------
            when CE19 =>
                writing     <= '1';

                addr_buf    <= std_logic_vector(to_unsigned(16#55#, addr_buf'length));
                data_buf    <= std_logic_vector(to_unsigned(16#55#, data_buf'length));

                next_state  <= CE20;

            ---------------------------------------------------------------------------------------
            -- The address should be fully output at this time, since the address latch is trans-
            --  parent.I have one more address state after this to ensure 0x5555 is locked in.
            ---------------------------------------------------------------------------------------
            when CE20 =>
                writing     <= '1'; 

                addr_buf    <= std_logic_vector(to_unsigned(16#55#, addr_buf'length));
                data_buf    <= std_logic_vector(to_unsigned(16#55#, data_buf'length));

                next_state  <= CE21;

            ---------------------------------------------------------------------------------------
            -- The last address state is here to satisfy the latch hold time. Since the data is
            --  coming out of a buffer, we can prime data_buf with the data we wish to write. Also,
            --  since the address has been stable since the last cycle, the address setup time
            --  should be satisfied.
            ---------------------------------------------------------------------------------------
            when CE21 =>
                writing <= '1';

                addr_buf    <= std_logic_vector(to_unsigned(16#55#, addr_buf'length));
                data_buf    <= std_logic_vector(to_unsigned(16#AA#, data_buf'length));

                next_state <= CE22;

            ---------------------------------------------------------------------------------------
            -- This is the first write state. The WE bit will go true, latching the address. The
            --  data to write should now be output on the bus as well.
            ---------------------------------------------------------------------------------------
            when CE22 =>
                writing <= '1';

                addr_buf    <= std_logic_vector(to_unsigned(16#55#, addr_buf'length));
                data_buf    <= std_logic_vector(to_unsigned(16#AA#, data_buf'length));

                next_state <= CE23;

            ---------------------------------------------------------------------------------------
            -- Depending on how fast the clock this, another state may be needed to meet the 40nS
            --  setup time. The WE bit is still true.
            ---------------------------------------------------------------------------------------
            when CE23 =>
                writing <= '1';

                addr_buf    <= std_logic_vector(to_unsigned(16#55#, addr_buf'length));
                data_buf    <= std_logic_vector(to_unsigned(16#AA#, data_buf'length));

                next_state <= CE24;

            ---------------------------------------------------------------------------------------
            -- This is the last write state. The data and address will still be output. The WE bit
            --  will now go false, latching in the 
            ---------------------------------------------------------------------------------------
            when CE24 =>
                writing <= '1';

                next_state <= CE25;

-------------------------------------------------------------------------------------------------------
            ---------------------------------------------------------------------------------------
            -- Write states W1, W2, and W3 are primarily used to set up the address in the latch.
            --  The first state, W1, primes the output buffers.
            ---------------------------------------------------------------------------------------
            when CE25 =>
                writing     <= '1';

                addr_buf    <= std_logic_vector(to_unsigned(16#2A#, addr_buf'length));
                data_buf    <= std_logic_vector(to_unsigned(16#AA#, data_buf'length));

                next_state  <= CE26;

            ---------------------------------------------------------------------------------------
            -- The address should be fully output at this time, since the address latch is trans-
            --  parent.I have one more address state after this to ensure 0x5555 is locked in.
            ---------------------------------------------------------------------------------------
            when CE26 =>
                writing     <= '1'; 

                addr_buf    <= std_logic_vector(to_unsigned(16#2A#, addr_buf'length));
                data_buf    <= std_logic_vector(to_unsigned(16#AA#, data_buf'length));

                next_state  <= CE27;

            ---------------------------------------------------------------------------------------
            -- The last address state is here to satisfy the latch hold time. Since the data is
            --  coming out of a buffer, we can prime data_buf with the data we wish to write. Also,
            --  since the address has been stable since the last cycle, the address setup time
            --  should be satisfied.
            ---------------------------------------------------------------------------------------
            when CE27 =>
                writing <= '1';

                addr_buf    <= std_logic_vector(to_unsigned(16#2A#, addr_buf'length));
                data_buf    <= std_logic_vector(to_unsigned(16#55#, data_buf'length));

                next_state <= CE28;

            ---------------------------------------------------------------------------------------
            -- This is the first write state. The WE bit will go true, latching the address. The
            --  data to write should now be output on the bus as well.
            ---------------------------------------------------------------------------------------
            when CE28 =>
                writing <= '1';

                addr_buf    <= std_logic_vector(to_unsigned(16#2A#, addr_buf'length));
                data_buf    <= std_logic_vector(to_unsigned(16#55#, data_buf'length));

                next_state <= CE29;

            ---------------------------------------------------------------------------------------
            -- Depending on how fast the clock this, another state may be needed to meet the 40nS
            --  setup time. The WE bit is still true.
            ---------------------------------------------------------------------------------------
            when CE29 =>
                writing <= '1';

                addr_buf    <= std_logic_vector(to_unsigned(16#2A#, addr_buf'length));
                data_buf    <= std_logic_vector(to_unsigned(16#55#, data_buf'length));

                next_state <= CE30;

            ---------------------------------------------------------------------------------------
            -- This is the last write state. The data and address will still be output. The WE bit
            --  will now go false, latching in the 
            ---------------------------------------------------------------------------------------
            when CE30 =>
                writing <= '1';

                next_state <= CE31;

-------------------------------------------------------------------------------------------------------
            ---------------------------------------------------------------------------------------
            -- Write states W1, W2, and W3 are primarily used to set up the address in the latch.
            --  The first state, W1, primes the output buffers.
            ---------------------------------------------------------------------------------------
            when CE31 =>
                writing     <= '1';

                addr_buf    <= std_logic_vector(to_unsigned(16#55#, addr_buf'length));
                data_buf    <= std_logic_vector(to_unsigned(16#55#, data_buf'length));

                next_state  <= CE32;

            ---------------------------------------------------------------------------------------
            -- The address should be fully output at this time, since the address latch is trans-
            --  parent.I have one more address state after this to ensure 0x5555 is locked in.
            ---------------------------------------------------------------------------------------
            when CE32 =>
                writing     <= '1'; 

                addr_buf    <= std_logic_vector(to_unsigned(16#55#, addr_buf'length));
                data_buf    <= std_logic_vector(to_unsigned(16#55#, data_buf'length));

                next_state  <= CE33;

            ---------------------------------------------------------------------------------------
            -- The last address state is here to satisfy the latch hold time. Since the data is
            --  coming out of a buffer, we can prime data_buf with the data we wish to write. Also,
            --  since the address has been stable since the last cycle, the address setup time
            --  should be satisfied.
            ---------------------------------------------------------------------------------------
            when CE33 =>
                writing <= '1';

                addr_buf    <= std_logic_vector(to_unsigned(16#55#, addr_buf'length));
                data_buf    <= std_logic_vector(to_unsigned(16#10#, data_buf'length));

                next_state <= CE34;

            ---------------------------------------------------------------------------------------
            -- This is the first write state. The WE bit will go true, latching the address. The
            --  data to write should now be output on the bus as well.
            ---------------------------------------------------------------------------------------
            when CE34 =>
                writing <= '1';

                addr_buf    <= std_logic_vector(to_unsigned(16#55#, addr_buf'length));
                data_buf    <= std_logic_vector(to_unsigned(16#10#, data_buf'length));

                next_state <= CE35;

            ---------------------------------------------------------------------------------------
            -- Depending on how fast the clock this, another state may be needed to meet the 40nS
            --  setup time. The WE bit is still true.
            ---------------------------------------------------------------------------------------
            when CE35 =>
                writing <= '1';

                addr_buf    <= std_logic_vector(to_unsigned(16#55#, addr_buf'length));
                data_buf    <= std_logic_vector(to_unsigned(16#10#, data_buf'length));

                next_state <= CE36;

            ---------------------------------------------------------------------------------------
            -- This is the last write state. The data and address will still be output. The WE bit
            --  will now go false, latching in the 
            ---------------------------------------------------------------------------------------
            when CE36 =>
                writing <= '1';

                next_state <= POLL1;

-------------------------------------------------------------------------------------------------------


            ---------------------------------------------------------------------------------------
            ---------------------------------------------------------------------------------------
            --                                    POLL STATES                                    --
            ---------------------------------------------------------------------------------------
            ---------------------------------------------------------------------------------------

            ---------------------------------------------------------------------------------------
            --  The setup and hold times are as follows:
            --      Toeh:   OE# high hold time          -   10nS
            --      Tce:    Chip enable access time     -   70nS
            --      Toe:    Output enable access time   -   35nS
            --      Toes:   OE# high setup time         -   00nS
            ---------------------------------------------------------------------------------------
            when W_POLL1 =>
                polling     <= '1';
                
                next_state  <= W_POLL2;

            when W_POLL2 =>
                polling     <= '1';
                
                next_state <= W_POLL3;

            when W_POLL3 =>
                polling <= '1';
                
                next_state <= W_POLL4;

            when W_POLL4 =>
                polling <= '1';
                
                next_state <= W_POLL5;

            when W_POLL5 =>
                polling <= '1';

                if (poll_buf(7) = data_out(7)) then
                    next_state <= IDLE;
                else
                    next_state <= W_POLL1;
                end if;

            when POLL1 =>
                polling     <= '1';
                
                next_state  <= POLL2;

            when POLL2 =>
                polling     <= '1';
                
                next_state <= POLL3;

            when POLL3 =>
                polling <= '1';
                
                next_state <= POLL4;

            when POLL4 =>
                polling <= '1';
                
                next_state <= POLL5;

            when POLL5 =>
                polling <= '1';

                if (poll_buf(7) = '1') then
                    next_state <= IDLE;
                else
                    next_state <= POLL1;
                end if;

            when OTHERS =>
                null;
        end case;
    end process;

    ---------------------------------------------------------------------------------------
    -- Look-ahead logic
    --  Devloper Note: This was more-or-less and experiment with using look-ahead logic.
    --  Not sure if I'd implement it in this way again, since it doubles the code length,
    --  but it did allow me a intuitive way to get the buffered signals when I wanted them.
    ---------------------------------------------------------------------------------------
    process(next_state)
    begin
        tri_buf <= '1';
        CE_buf  <= '1';
        OE_buf  <= '1';
        WE_buf  <= '1';
        ALE_buf <= '0';

        case next_state is
            when IDLE =>
                null;

            ---------------------------------------------------------------------------------------
            ---------------------------------------------------------------------------------------
            --                                    READ STATES                                    --
            ---------------------------------------------------------------------------------------
            ---------------------------------------------------------------------------------------
            when R1 =>
                ---------------------------------------------------------------------------------------
                -- Since we have to latch data, and the data bus itself is already latched, we need an
                --  extra state to get the address ready. This is to get the data ready internally.
                ---------------------------------------------------------------------------------------
                null;

            when R2 =>
                ---------------------------------------------------------------------------------------
                -- To write the address to the latch, OE must be high and the tri-state buffer must be
                --  enabled. The latch enable should go high to allow data to pass.
                ---------------------------------------------------------------------------------------
                tri_buf <= '0';
                ALE_buf <= '1';

            when R3 =>
                ---------------------------------------------------------------------------------------
                -- We use R3 to ensure the hold time of the latch is met. We continue to output the
                --  lower 8-bits of the address while we drive the latch enable low. We can go ahead
                --  and start turning the EEPROM on since the data bus should be HIGH-Z.
                ---------------------------------------------------------------------------------------
                tri_buf <= '0';
                CE_buf  <= '0';

            when R4 =>
                ---------------------------------------------------------------------------------------
                -- The R4 state is more-or-less a hold state to ensure that the hold times for the
                --  EEPROM are met at higher frequencies.
                ---------------------------------------------------------------------------------------
                CE_buf  <= '0';
                OE_buf  <= '0';

            when R5 =>
                ---------------------------------------------------------------------------------------
                -- R5 is the "read" state. It hold the data on the bus to be latched.
                ---------------------------------------------------------------------------------------
                CE_buf <= '0';
                OE_buf <= '0';

            ---------------------------------------------------------------------------------------
            ---------------------------------------------------------------------------------------
            --                                   WRITE STATES                                    --
            ---------------------------------------------------------------------------------------
            ---------------------------------------------------------------------------------------
            when W1 =>
                null;
                
            when W2 =>
                ALE_buf <= '1';
                CE_buf  <= '0';
                tri_buf <= '0';

            when W3 =>
                CE_buf  <= '0';
                tri_buf <= '0';

            when W4 =>
                CE_buf  <= '0';
                tri_buf <= '0';
                WE_buf  <= '0';

            when W5 =>
                CE_buf  <= '0';
                tri_buf <= '0';
                WE_buf  <= '0';

            when W6 =>
                CE_buf  <= '0';
                tri_buf <= '0';

-------------------------------------------------------------------------------------------------------
            when W7 =>
                null;
                
            when W8 =>
                ALE_buf <= '1';
                CE_buf  <= '0';
                tri_buf <= '0';

            when W9 =>
                CE_buf  <= '0';
                tri_buf <= '0';

            when W10 =>
                CE_buf  <= '0';
                tri_buf <= '0';
                WE_buf  <= '0';

            when W11 =>
                CE_buf  <= '0';
                tri_buf <= '0';
                WE_buf  <= '0';

            when W12 =>
                CE_buf  <= '0';
                tri_buf <= '0';

-------------------------------------------------------------------------------------------------------
            when W13 =>
                null;
                
            when W14 =>
                ALE_buf <= '1';
                CE_buf  <= '0';
                tri_buf <= '0';

            when W15 =>
                CE_buf  <= '0';
                tri_buf <= '0';

            when W16 =>
                CE_buf  <= '0';
                tri_buf <= '0';
                WE_buf  <= '0';

            when W17 =>
                CE_buf  <= '0';
                tri_buf <= '0';
                WE_buf  <= '0';

            when W18 =>
                CE_buf  <= '0';
                tri_buf <= '0';

-------------------------------------------------------------------------------------------------------
            when W19 =>
                null;
                
            when W20 =>
                ALE_buf <= '1';
                CE_buf  <= '0';
                tri_buf <= '0';

            when W21 =>
                CE_buf  <= '0';
                tri_buf <= '0';

            when W22 =>
                CE_buf  <= '0';
                tri_buf <= '0';
                WE_buf  <= '0';

            when W23 =>
                CE_buf  <= '0';
                tri_buf <= '0';
                WE_buf  <= '0';

            when W24 =>
                CE_buf  <= '0';
                tri_buf <= '0';

-------------------------------------------------------------------------------------------------------

            when CE1 =>
                null;
                
            when CE2 =>
                ALE_buf <= '1';
                CE_buf  <= '0';
                tri_buf <= '0';

            when CE3 =>
                CE_buf  <= '0';
                tri_buf <= '0';

            when CE4 =>
                CE_buf  <= '0';
                tri_buf <= '0';
                WE_buf  <= '0';

            when CE5 =>
                CE_buf  <= '0';
                tri_buf <= '0';
                WE_buf  <= '0';

            when CE6 =>
                CE_buf  <= '0';
                tri_buf <= '0';

-------------------------------------------------------------------------------------------------------
            when CE7 =>
                null;
                
            when CE8 =>
                ALE_buf <= '1';
                CE_buf  <= '0';
                tri_buf <= '0';

            when CE9 =>
                CE_buf  <= '0';
                tri_buf <= '0';

            when CE10 =>
                CE_buf  <= '0';
                tri_buf <= '0';
                WE_buf  <= '0';

            when CE11 =>
                CE_buf  <= '0';
                tri_buf <= '0';
                WE_buf  <= '0';

            when CE12 =>
                CE_buf  <= '0';
                tri_buf <= '0';

-------------------------------------------------------------------------------------------------------
            when CE13 =>
                null;
                
            when CE14 =>
                ALE_buf <= '1';
                CE_buf  <= '0';
                tri_buf <= '0';

            when CE15 =>
                CE_buf  <= '0';
                tri_buf <= '0';

            when CE16 =>
                CE_buf  <= '0';
                tri_buf <= '0';
                WE_buf  <= '0';

            when CE17 =>
                CE_buf  <= '0';
                tri_buf <= '0';
                WE_buf  <= '0';

            when CE18 =>
                CE_buf  <= '0';
                tri_buf <= '0';

-------------------------------------------------------------------------------------------------------
            when CE19 =>
                null;
                
            when CE20 =>
                ALE_buf <= '1';
                CE_buf  <= '0';
                tri_buf <= '0';

            when CE21 =>
                CE_buf  <= '0';
                tri_buf <= '0';

            when CE22 =>
                CE_buf  <= '0';
                tri_buf <= '0';
                WE_buf  <= '0';

            when CE23 =>
                CE_buf  <= '0';
                tri_buf <= '0';
                WE_buf  <= '0';

            when CE24 =>
                CE_buf  <= '0';
                tri_buf <= '0';

-------------------------------------------------------------------------------------------------------
            when CE25 =>
                null;
                
            when CE26 =>
                ALE_buf <= '1';
                CE_buf  <= '0';
                tri_buf <= '0';

            when CE27 =>
                CE_buf  <= '0';
                tri_buf <= '0';

            when CE28 =>
                CE_buf  <= '0';
                tri_buf <= '0';
                WE_buf  <= '0';

            when CE29 =>
                CE_buf  <= '0';
                tri_buf <= '0';
                WE_buf  <= '0';

            when CE30 =>
                CE_buf  <= '0';
                tri_buf <= '0';

-------------------------------------------------------------------------------------------------------
            when CE31 =>
                null;
                
            when CE32 =>
                ALE_buf <= '1';
                CE_buf  <= '0';
                tri_buf <= '0';

            when CE33 =>
                CE_buf  <= '0';
                tri_buf <= '0';

            when CE34 =>
                CE_buf  <= '0';
                tri_buf <= '0';
                WE_buf  <= '0';

            when CE35 =>
                CE_buf  <= '0';
                tri_buf <= '0';
                WE_buf  <= '0';

            when CE36 =>
                CE_buf  <= '0';
                tri_buf <= '0';

-------------------------------------------------------------------------------------------------------


            when POLL1 =>
                null;

            when POLL2 =>
                CE_buf  <= '0';

            when POLL3 =>
                CE_buf  <= '0';
                OE_buf  <= '0';

            when POLL4 =>
                CE_buf  <= '0';
                OE_buf  <= '0';

            when POLL5 =>
                CE_buf  <= '0';
                OE_buf  <= '0';

            when W_POLL1 =>
                null;

            when W_POLL2 =>
                CE_buf  <= '0';

            when W_POLL3 =>
                CE_buf  <= '0';
                OE_buf  <= '0';

            when W_POLL4 =>
                CE_buf  <= '0';
                OE_buf  <= '0';

            when W_POLL5 =>
                CE_buf  <= '0';
                OE_buf  <= '0';

            when OTHERS =>
                null;
            end case;
    end process;

    ---------------------------------------------------------------------------------------
    -- SST39SF Control Signals
    ---------------------------------------------------------------------------------------
    CE_n    <= CE_reg;
    OE_n    <= OE_reg;
    WE_n    <= WE_reg;
    ALE     <= ALE_reg;

    ---------------------------------------------------------------------------------------
    -- SST39SF Buses
    ---------------------------------------------------------------------------------------
    addr_out    <= addr_reg;
    data_flash  <= data_fabric2flash when tri_reg = '0'
                    else (others => 'Z');
    data_in     <= data_flash2fabric;
end BHV;