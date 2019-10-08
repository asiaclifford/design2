library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-------------------------------------------------------------------------------------------
-- Top level interface for flash module. Interface functionality based on the AT8C256.
--  This interface is use primarily to bridge the gap between what stuends used to
--  interface with (the AT8C256) and what the OOTB MAX-V board uses (the SST39SF).
-------------------------------------------------------------------------------------------
entity flash_module is
    PORT
    (
        -----------------------------------------------------------------------------------
        -- General inputs
        -----------------------------------------------------------------------------------
        clk, rst                        : in std_logic;

        -----------------------------------------------------------------------------------
        -- Interface signals
        -----------------------------------------------------------------------------------
        -- Programmer
        PROG_en                         : in std_logic;

        -- Control Signals
        CE_n, OE_n, WE_n                : in std_logic;

        -- Data Bus
        IO                              : inout std_logic_vector(7 downto 0);

        -- Address Bus
        A                               : in std_logic_vector(14 downto 0);

        -- Control Flags
        FL_writing, FL_polling,
            FL_reading                  : out std_logic;

        -----------------------------------------------------------------------------------
        -- Fabric outputs
        -----------------------------------------------------------------------------------
        FL_CE_n, FL_OE_n, FL_WE_n,
            FL_ALE                      : out std_logic;
        FL_IO                           : inout std_logic_vector(7 downto 0);
        FL_addr_out                     : out std_logic_vector(10 downto 0)
    );
end flash_module;

architecture BHV of flash_module is
    -- State Machine
    type state_type is (IDLE,
                        READ_FLASH, WRITE_FLASH, ERASE_FLASH,
                        POLLING
                        );
    signal state, next_state : state_type;

    -- Flash control
    signal FL_EN, FL_WE, FL_CHP_ER      : std_logic := '0';

    -- Flags
    signal writing_flag, polling_flag   : std_logic := '0';

    -- Data
    signal data_TX, data_RX             : std_logic_vector(7 downto 0) := (others => '0');
    signal IO_tristate                  : std_logic;

    -- Address
    signal addr                         : std_logic_vector(18 downto 0);
begin

    -- The goal was to make the EEPROM appear like the AT8C256. This means that the address
    --  bus would need to be 15-bits (32K). This resizes the incoming 15-bit address bus to
    --  the appropriate 19-bit address bus for the SST39SF.
    addr <= std_logic_vector(resize(unsigned(A), 19));

    ---------------------------------------------------------------------------------------
    -- This "FLASH" entity is used to bring in the physical interface for the SST39SF and
    --  connect it to this AT8C256 flash interface.
    ---------------------------------------------------------------------------------------
    FLASH   : entity work.SST39SF
            PORT MAP
            (
                -- General
                clk         => clk,
                rst         => rst,
                -- Inputs
                write_en    => FL_WE,
                flash_en    => FL_EN,
                chip_erase  => FL_CHP_ER,
                -- flags
                writing     => writing_flag,
                reading     => FL_reading,
                polling     => polling_flag,
                -- Outputs
                CE_n        => FL_CE_n,
                OE_n        => FL_OE_n,
                WE_n        => FL_WE_n,
                ALE         => FL_ALE,
                -- Data Buses
                data_flash  => FL_IO,
                data_in     => data_RX,
                data_out    => data_TX,
                -- Address Buses
                addr_in     => addr,
                addr_out    => FL_addr_out
          
            );

    ---------------------------------------------------------------------------------------
    -- This process handles the DFFs for the state machine.
    ---------------------------------------------------------------------------------------
    process(clk, rst)
    begin
        if(rst = '1') then
            state   <= IDLE;
        elsif(clk'event and clk = '1') then
            state   <= next_state;
        end if;
    end process;

    ---------------------------------------------------------------------------------------
    -- Finite State Machine (FSM) to handle signal interactions between the two interfaces.
    --  Take note that the state machine outputs two flags; FL_writing and FL_polling.
    --  These flags are used to let who-/whatever is using this interface when an operation
    --  is complete. This is because some operations may take extra clock cycles.
    ---------------------------------------------------------------------------------------
    process(state, PROG_en, CE_n, WE_n, OE_n, writing_flag, polling_flag)
    begin
        FL_EN       <= '0';
        FL_WE       <= '0';
        FL_CHP_ER   <= '0';
        IO_tristate <= '1';

        case state is
            -- We will wait in the IDLE state until the control lines are set in a valid
            --  configuration.
            when IDLE =>
                if (CE_n = '0' and OE_n = '0' and WE_n = '1') then
                    next_state <= READ_FLASH;
                elsif (CE_n = '0' and WE_n = '0' and OE_n = '1' and PROG_en = '0') then
                    next_state <= WRITE_FLASH;
                elsif (CE_n = '0' and OE_n = '0' and WE_n = '0' and PROG_en = '0') then
                    next_state <= ERASE_FLASH;
                else
                    next_state <= IDLE;
                end if;

            -- If the control lines are configured to read, then the READ_FLASH state will
            --  hold the SST39SF in the read state until the control lines change.
            when READ_FLASH =>
                FL_EN <= '1';
                IO_tristate <= '0';

                if (CE_n = '0' and OE_n = '0' and WE_n = '1') then
                    next_state  <= READ_FLASH;
                else
                    next_state <= IDLE;
                end if;

            -- If the control lines are configured to write, the WRITE_FLASH state will
            --  start the write process. Note that the data lines already pass through this
            --  interface and into the SST39SF interface. That means here we just need to
            --  interpret the flags for polling purposes.
            when WRITE_FLASH =>
                FL_EN       <= '1';
                FL_WE       <= '1';

                if (writing_flag = '1') then
                    next_state <= WRITE_FLASH;
                else
                    next_state <= POLLING;
                end if;

            -- If the control lines are configured to erase, the ERASE_FLASH state will
            --  start the very long process of erasing the entire EEPROM. This state tells
            --  the SSF39SF interface that it wants to erase the EEPROM, then interprets
            --  the signals to determine when the process has started.
            when ERASE_FLASH =>
                FL_EN       <= '1';
                FL_CHP_ER   <= '1';

                if (writing_flag = '1') then
                    next_state <= ERASE_FLASH;
                else
                    next_state <= POLLING;
                end if;

            -- Once either the wirting or erasing process has started, the POLLING state is
            --  used to determine when the process has ended. This allows any- one/thing
            --  using the interface to wait for the process to finish without using delays.
            when POLLING =>
                if (polling_flag = '1') then
                    next_state <= POLLING;
                else
                    next_state <= IDLE;
                end if;

            -- This is a catch-all state. If for whatever reason the state machine were to
            --  go to an undefined state, this state would define the actions. In this case
            --  we don't do anything. The code should never reach this state.
            when OTHERS =>
                null;
        end case;
    end process;

    -- This block of code (lines 208 to 211) is used to handle the bidirectional data bus
    --  coming out of the SST39SF interface.
    --
    --  IMPORTANT NOTE: You should never, ever, ever use a bidirectional bus internally.
    --      The only reason we do so here is to closer simulate the AT28C256. This is a bad
    --      design practice and we should feel bad for doing it.
    IO <= data_RX when IO_tristate = '0'
        else (others => 'Z');
        
    data_TX <= IO;

    -- Finally, we connect our interface "flag" signals to the outgoing "FL" signals. We
    --  used internal signals to be able to both read and write to the FL signals. An
    --  alternative would be to make the FL_writing/polling 'out' signals into 'buffer's.
    --  This would allow the signals to be read and updata within this entity.
    FL_writing <= writing_flag;
    FL_polling <= polling_flag;
    
end BHV;