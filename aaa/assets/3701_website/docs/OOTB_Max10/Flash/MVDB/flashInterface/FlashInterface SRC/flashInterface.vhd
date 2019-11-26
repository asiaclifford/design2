library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-------------------------------------------------------------------------------------------
-- This entity is the full version of the Flash Interface. It is designed to be both a
--  flash programmer and a read-only interface. The PROG_en signal is responsible for
--  switching modes. There is a weak pull-up resistor on the associated pin to default the
--  signal to high, which is read only. A switch/jumper may be used to pull the pin low,
--  putting this entity into programming mode.
-------------------------------------------------------------------------------------------
entity flashInterface is
    PORT
    (
        -----------------------------------------------------------------------------------
        -- General inputs
        -----------------------------------------------------------------------------------
        FI_CLK, FI_RST              : in std_logic;

        -----------------------------------------------------------------------------------
        -- Fabric inputs/outputs
        -----------------------------------------------------------------------------------
        -- FTDI
        FT_RXF_n, FT_TXE_n          : in std_logic;
        FT_RD_n, FT_WR_n,
        FT_SIWU                     : out std_logic;
        FT_data                     : inout std_logic_vector(7 downto 0);

        -- FLASH
        FL_CE_n, FL_OE_n, FL_WE_n,
        FL_ALE                      : out std_logic;
        FL_addr_out                 : out std_logic_vector(10 downto 0);
        FL_IO                       : inout std_logic_vector(7 downto 0);

        -- RX/TX LEDs
        FT_RX_LED                   : out std_logic;
        FT_TX_LED                   : out std_logic;

        -----------------------------------------------------------------------------------
        -- User Interface
        -----------------------------------------------------------------------------------
        -- Control Signals
        -- Programmer
        PROG_en                     : in std_logic;

        -- FLASH
        CEn, OEn, WEn               : in std_logic;

        -- Data Bus
        IO                          : out std_logic_vector(7 downto 0);

        -- Address Bus
        A                           : in std_logic_vector(14 downto 0)
    );
end flashInterface;

architecture TOP of flashInterface is
    ---------------------------------------------------------------------------------------
    -- Clock Divider
    ---------------------------------------------------------------------------------------
    signal div_clk                  : std_logic;
    signal counter                  : integer range 0 to 2 := 0;

    ---------------------------------------------------------------------------------------
    -- FTDI signals
    ---------------------------------------------------------------------------------------
    signal FT_rx                    : std_logic_vector(7 downto 0);
    signal FT_wrdy, FT_rrdy         : std_logic;
    signal FT_wen, FT_pop, FT_flush : std_logic;

    ---------------------------------------------------------------------------------------
    -- FLASH signals
    ---------------------------------------------------------------------------------------
    signal CE_n, WE_n, OE_n         : std_logic;
    signal DP_FL_IO                 : std_logic_vector(7 downto 0);
    signal FL_addr                  : std_logic_vector(14 downto 0);
    signal FL_writing, FL_polling,
            FL_reading              : std_logic;

    ---------------------------------------------------------------------------------------
    -- Programmer signals
    ---------------------------------------------------------------------------------------
    -- Select Lines
    signal DP_SEL                   : std_logic_vector(2 downto 0);
    signal DP_ADDR_SEL              : std_logic;
    -- Register Control
    signal pckt_id_ld, FL_rd_ld,
        dp_addr_ld_l, dp_addr_ld_h  : std_logic;
    -- Bus Control
    signal FL_IO_OUT_EN             : std_logic;
    -- Data Path
    signal DP_out                   : std_logic_vector(7 downto 0);

    ---------------------------------------------------------------------------------------
    -- Internal signals
    ---------------------------------------------------------------------------------------
    -- Enable MUX
    signal CE, WE, OE               : std_logic;

begin
    ---------------------------------------------------------------------------------------
    -- The "DP" entity is responsible for connecting all the sub-entities together to form
    --  the flash interface.
    ---------------------------------------------------------------------------------------
    DP : entity work.data_path
        PORT MAP
        (
            -------------------------------------------------------------------------------
            -- General inputs
            -------------------------------------------------------------------------------
            clk             => div_clk,
            rst             => FI_RST,

            -------------------------------------------------------------------------------
            -- Inputs
            -------------------------------------------------------------------------------
            -- Data
            FT_rx           => FT_rx,
            USER_in         => (others => '0'), -- NOTE: Disabled user input
            USER_A          => A,
            FL_IO           => DP_FL_IO,

            -- Select Lines
            DP_SEL          => DP_SEL,
            DP_ADDR_SEL     => DP_ADDR_SEL,

            -- Register Control
            pckt_id_ld      => pckt_id_ld,
            FL_rd_ld        => FL_rd_ld,
            dp_addr_ld_l    => dp_addr_ld_l,
            dp_addr_ld_h    => dp_addr_ld_h,

            -- Bus Control
            FL_IO_OUT_EN    => FL_IO_OUT_EN,

            -------------------------------------------------------------------------------
            -- Outputs
            -------------------------------------------------------------------------------
            DP_out          => DP_out,
            FL_addr         => FL_addr
        );

    ---------------------------------------------------------------------------------------
    -- This "FTDI" entity is designed to handle communications between the PC and the OOTB
    --  MAX-V board. It interprets packets, handles transmissions, and contols the FT240x.
    ---------------------------------------------------------------------------------------
    FTDI : entity work.FTDI_coms
        PORT MAP
        (
            -------------------------------------------------------------------------------
            -- General inputs
            -------------------------------------------------------------------------------
            clk         => div_clk,
            rst         => FI_RST,
            -------------------------------------------------------------------------------
            -- Interface signals
            -------------------------------------------------------------------------------
            -- I/O Buses
            FT_tx       => DP_out,
            FT_rx       => FT_rx,
            -- Flags
            FT_wrdy     => FT_wrdy,
            FT_rrdy     => FT_rrdy,
            -- FIFO Control
            FT_wen      => FT_wen,
            FT_pop      => FT_pop,
            FT_flush    => FT_flush,
            -------------------------------------------------------------------------------
            -- Fabric outputs
            -------------------------------------------------------------------------------
            RXF_n       => FT_RXF_n,
            TXE_n       => FT_TXE_n,
            RD_n        => FT_RD_n,
            WR_n        => FT_WR_n,
            SIWU        => FT_SIWU,
            -- Data Buses
            data_ftdi   => FT_data,
            -- RX/TX LEDs
            FT_RX_LED   => FT_RX_LED,
            FT_TX_LED   => FT_TX_LED
        );

    ---------------------------------------------------------------------------------------
    -- The "FLASH_MOD" handles communication with the on-board flash device. It is currently
    --  designed to resemble the AT8C256 EEPROM.
    ---------------------------------------------------------------------------------------
    FLASH_MOD : entity work.flash_module
        PORT MAP
        (
            ---------------------------------------------------------------------------------------
            -- General inputs
            ---------------------------------------------------------------------------------------
            clk         => div_clk,
            rst         => FI_RST,
            ---------------------------------------------------------------------------------------
            -- Interface signals
            ---------------------------------------------------------------------------------------
            -- Programmer
            PROG_en     => PROG_en,
            -- Control Signals
            CE_n        => CE,
            OE_n        => OE,
            WE_n        => WE,
            -- Data Bus
            IO          => DP_FL_IO,
            -- Address Bus
            A           => FL_addr,
            FL_writing  => FL_writing,
            FL_polling  => FL_polling,
            FL_reading  => FL_reading,
            ---------------------------------------------------------------------------------------
            -- Fabric outputs
            ---------------------------------------------------------------------------------------
            FL_CE_n     => FL_CE_n,
            FL_OE_n     => FL_OE_n,
            FL_WE_n     => FL_WE_n,
            FL_ALE      => FL_ALE,
            FL_IO       => FL_IO,
            FL_addr_out => FL_addr_out
        );

    ---------------------------------------------------------------------------------------
    -- The "FP_CONTROLLER" handles the signals for passing data back and forth between
    --  the flash and the FTDI communication protocol for the flash programmer.
    ---------------------------------------------------------------------------------------
    FP_CONTROLLER : entity work.flashProgrammer_controller
    PORT MAP
    (
        ---------------------------------------------------------------------------------------
        -- General inputs
        ---------------------------------------------------------------------------------------
        clk             => div_clk,
        rst             => FI_RST,
        ---------------------------------------------------------------------------------------
        -- Fabric inputs
        ---------------------------------------------------------------------------------------
        ---- FTDI
        -- Flags
        FT_rrdy         => FT_rrdy,
        FT_wrdy         => FT_wrdy,
        ---- FLASH
        FL_writing      => FL_writing,
        FL_polling      => FL_polling,
        FL_reading      => FL_reading,
        ---- DATA PATH
        DP_in           => DP_out,
        ---- PROGRAMMER
        PROG_en         => PROG_en,
        ---------------------------------------------------------------------------------------
        -- Fabric outputs
        ---------------------------------------------------------------------------------------
        ---- DATA PATH
        -- Select Lines
        DP_SEL          => DP_SEL,
        DP_ADDR_SEL     => DP_ADDR_SEL,
        -- Register Control
        pckt_id_ld      => pckt_id_ld,
        FL_rd_ld        => FL_rd_ld,
        dp_addr_ld_l    => dp_addr_ld_l,
        dp_addr_ld_h    => dp_addr_ld_h,
        -- Bus Control
        FL_IO_OUT_EN    => FL_IO_OUT_EN,
        ---- FTDI
        FT_wen          => FT_wen,
        FT_pop          => FT_pop,
        FT_flush        => FT_flush,
        ---- FLASH
        CE_n            => CE_n,
        OE_n            => OE_n,
        WE_n            => WE_n
    );

    -- This process will synthesize into 3 2-to-1 multiplexers. They are
    --  responsible for switching between programmer control and user
    --  control.
    process(PROG_en, CE_n, OE_n, WE_n, CEn, OEn, WEn)
    begin
        case PROG_en is
            WHEN '0' =>     -- Select programmer imputs
                CE <= CE_n; -- Programmer input
                OE <= OE_n; -- Programmer input
                WE <= WE_n; -- Programmer input
            WHEN '1' =>     -- Select user inputs
                CE <= CEn;  -- User input
                OE <= OEn;  -- User input
                WE <= WEn;  -- User input
            WHEN OTHERS =>
                null;
        end case;
    end process;

    -- This is an alternative way to synthesize a MUX. Not sure why the process
    --  statement version was locking up the code, but this version seems to be
    --  working just fine. If the programmer locks up, you can remove the mux
    -- by replacing lines 291 and 292 with the following line of code (289):
    --IO <= DP_out;

    IO <= DP_out when Prog_en = '1'
        else (others => '0');

    -- One trade off of making this code easy to read and understand is that
    --  there are several parts that are not entirely stable at higher speeds.
    --  There, this frequency divider is used to tone it down a bit. Future
    --  implementations may fix this.
    frequency_divider: process (FI_RST, FI_CLK) begin
        if (FI_RST = '1') then
            div_clk <= '0';
            counter <= 0;
        elsif rising_edge(FI_CLK) then
            if (counter = 2) then
                div_clk <= NOT(div_clk);
                counter <= 0;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;
--    div_clk <= FI_CLK;
end TOP;