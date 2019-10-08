library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-------------------------------------------------------------------------------------------
-- Controller for the flash programmer. Controls individual modules and the data path.
-------------------------------------------------------------------------------------------
entity flashProgrammer_controller is
    PORT
    (
        -----------------------------------------------------------------------------------
        -- General inputs
        -----------------------------------------------------------------------------------
        clk, rst                    : in std_logic;

        -----------------------------------------------------------------------------------
        -- Fabric inputs
        -----------------------------------------------------------------------------------
        ---- FTDI
        -- Flags
        FT_rrdy, FT_wrdy            : in std_logic;

        ---- FLASH
        -- Flags
        FL_writing                  : in std_logic;
        FL_polling                  : in std_logic;
        FL_reading                  : in std_logic;

        ---- DATA PATH
        DP_in                       : in std_logic_vector(7 downto 0);

        -- PROGRAMMER
        PROG_en                     : in std_logic;

        -----------------------------------------------------------------------------------
        -- Fabric outputs
        -----------------------------------------------------------------------------------
        ---- DATA PATH
        -- Select Lines
        DP_SEL                      : out std_logic_vector(2 downto 0);
        DP_ADDR_SEL                 : out std_logic;
        -- Register Control
        pckt_id_ld, FL_rd_ld,
        dp_addr_ld_l, dp_addr_ld_h  : out std_logic;
        -- Bus Control
        FL_IO_OUT_EN                : out std_logic;

        ---- FTDI
        FT_wen, FT_pop, FT_flush    : out std_logic;

        ---- FLASH
        CE_n                        : out std_logic;
        OE_n                        : out std_logic;
        WE_n                        : out std_logic
    );
end flashProgrammer_controller;

architecture BHV of flashProgrammer_controller is
    ---------------------------------------------------------------------------------------
    -- State Machine.
    ---------------------------------------------------------------------------------------
    type state_type is (INIT, IDLE,
                        DECODE1, DECODE2,
                        FLASH_READ1, FLASH_READ2, FLASH_READ3, FLASH_READ4, FLASH_READ5,
                            FLASH_READ6, FLASH_READ7, FLASH_READ8, FLASH_READ9, FLASH_READ10,
                        FLASH_WRITE1, FLASH_WRITE2, FLASH_WRITE3, FLASH_WRITE4,
                        FLASH_ERASE0, FLASH_ERASE1, FLASH_ERASE2,
                        SEND_ACK1, SEND_ACK2, SEND_ACK3, SEND_ACK4, SEND_ACK5, SEND_ACK6
                        );
    signal state, next_state : state_type;

    ---------------------------------------------------------------------------------------
    -- Constants
    ---------------------------------------------------------------------------------------
    -- Packet IDs
    constant CHIP_ERASE         : std_logic_vector(7 downto 0) := x"1F";
    constant READ_BYTE          : std_logic_vector(7 downto 0) := x"12";
    constant PROG_BYTE          : std_logic_vector(7 downto 0) := x"11";

    constant NACK               : std_logic_vector(7 downto 0) := x"30";
    constant ACK                : std_logic_vector(7 downto 0) := x"31";

    -- Select Lines
    constant DP_SEL_UNUSED      : std_logic_vector(2 downto 0) := "000";
    constant DP_SEL_FT_rx       : std_logic_vector(2 downto 0) := "001";
    constant DP_SEL_USER_in     : std_logic_vector(2 downto 0) := "010";
    constant DP_SEL_pckt_id     : std_logic_vector(2 downto 0) := "011";
    constant DP_SEL_HEADER      : std_logic_vector(2 downto 0) := "100";
    constant DP_SEL_NACK        : std_logic_vector(2 downto 0) := "101";
    constant DP_SEL_ACK         : std_logic_vector(2 downto 0) := "110";
    constant DP_SEL_FL_rd       : std_logic_vector(2 downto 0) := "111";

    constant DP_ADDR_SEL_USER   : std_logic := '0';
    constant DP_ADDR_SEL_ADDR   : std_logic := '1';
    
begin

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
    -- The actual Finite State Machine (FSM). Just a lot of control logic.
    ---------------------------------------------------------------------------------------
    process(state, PROG_en, FT_rrdy, FT_wrdy, DP_in, FL_reading, FL_polling)
    begin
        -- Default signal values
        DP_SEL          <= DP_SEL_FL_rd;
        DP_ADDR_SEL     <= DP_ADDR_SEL_USER;
        pckt_id_ld      <= '0';
        FL_rd_ld        <= '0';
        dp_addr_ld_l    <= '0';
        dp_addr_ld_h    <= '0';
        FL_IO_OUT_EN    <= '0';
        FT_wen          <= '0';
        FT_pop          <= '0';
        FT_flush        <= '0';
        CE_n            <= '1';
        OE_n            <= '1';
        WE_n            <= '1';
    
        case (state) is
            when INIT =>
                next_state <= IDLE;

            when IDLE =>
                if(PROG_en = '1') then
                    -- If the programmer is disabled, then the controller should remain
                    --  in idle and flush any incoming messages stored in the FT FIFO.
                    FT_flush    <= '1';
                    FL_rd_ld    <= '1';
                    next_state <= IDLE;
                else
                    if (FT_rrdy = '1') then
                        -- When FT_rrdy is true, there is a packet available to read.
                        --  The next step is to decode the packet.
                        --  This FT_pop is used to pop the 0x55 off the stack
                        FT_pop      <= '1';
                        next_state  <= DECODE1;
                    else
                        next_state <= IDLE;
                    end if;
                end if;

            when DECODE1 =>
                -- This second pop will be to pop the packet identifier.
                --  Since the pop is synchronous, the data will not be available
                --  until the next state.
                FT_pop <= '1';
                next_state <= DECODE2;

            when DECODE2 =>
                -- FT_rx should now have the packet ID on it.
                --  By setting DP_sel to DP_SEL_FT_rx, we can see which packet it
                --  is while at the same time storing it in the pckt_if register.
                DP_SEL      <= DP_SEL_FT_rx;
                pckt_id_ld  <= '1';

                case DP_in is
                    when READ_BYTE =>
                        -- This pop will be the lower byte of the address. It will be
                        --  loaded into the address register next state.
                        FT_pop <= '1';
                        next_state <= FLASH_READ1;

                    when PROG_BYTE =>
                        -- This pop will be the lower byte of the address. It will be
                        --  loaded into the address register next state.
                        FT_pop <= '1';
                        next_state <= FLASH_WRITE1;

                    when CHIP_ERASE =>
                        next_state <= FLASH_ERASE1;

                    when others =>
                        -- This state should never be reached. The FT FIFO should
                        --  be flushed and the state returned to IDLE.
                        FT_flush    <= '1';
                        next_state  <= IDLE;
                end case;

            -------------------------------------------------------------------------------
            -- FLASH READ STATES
            -------------------------------------------------------------------------------
            when FLASH_READ1 =>
                -- The low byte of the address should be on FT_rx. DP_SEL must be set
                --  to read it. The lower address should be loaded into the address
                --  register. FT_pop needs to be set to get the high byte of the
                --  address.
                DP_SEL          <= DP_SEL_FT_rx;
                dp_addr_ld_l    <= '1';

                FT_pop <= '1';

                next_state <= FLASH_READ2;

            when FLASH_READ2 =>
                -- The high byte of the address should be on the bus. Once it is loaded
                --  into the address register, a read can be performed.
                DP_SEL          <= DP_SEL_FT_rx;
                dp_addr_ld_h    <= '1';

                next_state <= FLASH_READ3;

            when FLASH_READ3 =>
                -- At this point, the address is in the address register. Everything is
                --  in place to perform a read. CE_n and OE_n need to be true. The address
                --  bus needs to be set to look at
                DP_ADDR_SEL <= DP_ADDR_SEL_ADDR;

                CE_n <= '0';
                OE_n <= '0';

                if (FL_reading = '1') then
                    -- FL_reading will be set when the flash finally has valid data to read.
                    --  Since it's latched, FLASH_READ4 will be used to read the data. We
                    --  can also flush the FIFO out.
                    FT_flush    <= '1';
                    next_state  <= FLASH_READ4;
                else
                    next_state  <= FLASH_READ3;
                end if;

            when FLASH_READ4 =>
                -- This state is used to load the data on FL_rx into the FL_rd register.
                --DP_SEL      <= DP_SEL_FL_rx;
                FL_rd_ld    <= '1';

                next_state <= FLASH_READ5;

            when FLASH_READ5 =>
                -- At this point, the flash should be held reading from the same address.
                --  We know that the data on FL_rx is the data we want. To send the data
                --  back, we must first transmit the packet header followed by the 8-bit
                --  data.
                DP_SEL      <= DP_SEL_HEADER;
                FT_wen      <= '1';

                if (FT_wrdy = '1') then
                    next_state <= FLASH_READ6;
                else
                    next_state <= FLASH_READ5;
                end if;

            when FLASH_READ6 =>
                -- This is similar to FLASH_READ4. This state waits until the 0x55 has been
                --  sent. Once 0x55 (packet header) has been sent, we can send the data. We
                --  hold the flash signals to insure that data stays valid.
                DP_SEL      <= DP_SEL_HEADER;

                if (FT_wrdy = '0') then
                    next_state <= FLASH_READ7;
                else
                    next_state <= FLASH_READ6;
                end if;

            when FLASH_READ7 =>
                -- Now that the packet header has been sent, we can send the data. This is
                --  handled similarly to READ_FLASH 4 and 5.
                FT_wen      <= '1';

                DP_SEL      <= DP_SEL_pckt_id;

                if (FT_wrdy = '1') then
                    next_state <= FLASH_READ8;
                else
                    next_state <= FLASH_READ7;
                end if;

            when FLASH_READ8 =>
                -- This is the last step. We just need to wait for the flash data to finish
                --  sending. Once this occurs, we can go back to IDLE.
                DP_SEL      <= DP_SEL_pckt_id;

                if (FT_wrdy = '0') then
                    next_state  <= FLASH_READ9;
                else
                    next_state  <= FLASH_READ8;
                end if;

            when FLASH_READ9 =>
                -- Now that the packet header has been sent, we can send the data. This is
                --  handled similarly to READ_FLASH 4 and 5.
                FT_wen      <= '1';

                DP_SEL      <= DP_SEL_FL_rd;

                if (FT_wrdy = '1') then
                    next_state <= FLASH_READ10;
                else
                    next_state <= FLASH_READ9;
                end if;

            when FLASH_READ10 =>
                -- This is the last step. We just need to wait for the flash data to finish
                --  sending. Once this occurs, we can go back to IDLE.
                DP_SEL      <= DP_SEL_FL_rd;

                if (FT_wrdy = '0') then
                    next_state  <= IDLE;
                else
                    next_state  <= FLASH_READ10;
                end if;

            -------------------------------------------------------------------------------
            -- FLASH WRITE STATES
            -------------------------------------------------------------------------------
            when FLASH_WRITE1 =>
                -- The low byte of the address should be on FT_rx. DP_SEL must be set
                --  to read it. The lower address should be loaded into the address
                --  register. FT_pop needs to be set to get the high byte of the
                --  address.
                DP_SEL          <= DP_SEL_FT_rx;
                dp_addr_ld_l    <= '1';

                FT_pop          <= '1';

                next_state      <= FLASH_WRITE2;

            when FLASH_WRITE2 =>
                -- The high byte of the address should be on the bus. Once it is loaded
                --  into the address register, the data to write can be popped.
                DP_SEL          <= DP_SEL_FT_rx;
                dp_addr_ld_h    <= '1';

                FT_pop          <= '1';

                next_state      <= FLASH_write3;

            when FLASH_WRITE3 =>
                -- The data to write is now on FT_rx. We can now trigger a write in flash. We want
                --  FT_rx to be sent on the data path to the flash. The  DP_ADDR mux needs to be
                --  set to the stored address. We hold these settings until the flash signals that
                --  it is polling.
                DP_SEL          <= DP_SEL_FT_rx;
                DP_ADDR_SEL     <= DP_ADDR_SEL_ADDR;

                FL_IO_OUT_EN    <= '1';

                CE_n            <= '0';
                WE_n            <= '0';

                if (FL_polling = '1') then
                    -- We are done with the packet, we can now flush the FIFO.
                    --FT_flush    <= '1';
                    next_state  <= FLASH_WRITE4;
                else
                    next_state  <= FLASH_WRITE3;
                end if;

            when FLASH_WRITE4 =>
                -- At this point, the write is technically complete. This state waits until the
                --  flash module is done polling. From here, the ack should be sent to let the
                --  PC know the write was successfull.
                DP_ADDR_SEL     <= DP_ADDR_SEL_ADDR;

                if (FL_polling = '0') then
                    next_state <= SEND_ACK1;
                else
                    next_state <= FLASH_WRITE4;
                end if;

            ---------------------------------------------------------------------------------------
            -- FLASH ERASE STATES
            ---------------------------------------------------------------------------------------
            -- Adding this state fixed a strange error. Without it, everything would appear to work.
            --  You could send commands and get the right response back. But erase and write would
            --  not actually do anything. This needs to be looked into.
            when FLASH_ERASE0=>
                next_state <= FLASH_ERASE1;

            when FLASH_ERASE1 =>
                -- There is nothing to pop for a chip erase. It's as simple as signaling the module
                --  to perform the erase and waiting for it to complete.
                WE_n <= '0';
                OE_n <= '0';
                CE_n <= '0';

                if (FL_polling = '1') then
                    -- Only because there will have to be a bunch of garbage in the FIFO.
                    FT_flush    <= '1';
                    next_state  <= FLASH_ERASE2;
                else
                    next_state <= FLASH_ERASE1;
                end if;

            when FLASH_ERASE2 =>
                -- The chip erase should be done at this point and we are just waiting for the
                --  polling to complete before we send the ack to the PC.
                if (FL_polling = '0') then
                    next_state <= SEND_ACK1;
                else
                    next_state <= FLASH_ERASE2;
                end if;

            -----------------------------------------------------------------------------------
            -- SEND ACK STATES
            -----------------------------------------------------------------------------------
            when SEND_ACK1 =>
                FT_wen <= '1';
                DP_SEL <= DP_SEL_HEADER;

                if (FT_wrdy = '1') then
                    next_state <= SEND_ACK2;
                else
                    next_state <= SEND_ACK1;
                end if;

            when SEND_ACK2 =>
                DP_SEL <= DP_SEL_HEADER;
               
                if (FT_wrdy = '0') then
                    next_state <= SEND_ACK3;
                else
                    next_state <= SEND_ACK2;
                end if;

            when SEND_ACK3 =>
                FT_wen <= '1';
                DP_SEL <= DP_SEL_pckt_id;
                
                if (FT_wrdy = '1') then
                    next_state <= SEND_ACK4;
                else
                    next_state <= SEND_ACK3;
                end if;

            when SEND_ACK4 =>
                DP_SEL <= DP_SEL_pckt_id;
                
                if (FT_wrdy = '0') then
                    next_state <= SEND_ACK5;
                else
                    next_state <= SEND_ACK4;
                end if;

            when SEND_ACK5 =>
                FT_wen <= '1';
                DP_SEL <= DP_SEL_ACK;
                
                if (FT_wrdy = '1') then
                    next_state <= SEND_ACK6;
                else
                    next_state <= SEND_ACK5;
                end if;

            when SEND_ACK6 =>
                DP_SEL <= DP_SEL_ACK;
                
                if (FT_wrdy = '0') then
                    next_state <= IDLE;
                else
                    next_state <= SEND_ACK6;
                end if;

            when others =>
                null;
        end case;
    end process;
end BHV;