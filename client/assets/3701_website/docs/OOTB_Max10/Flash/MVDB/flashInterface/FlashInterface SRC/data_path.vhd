library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-------------------------------------------------------------------------------------------
-- Data path to be used in the top level of the flash programmer.
-------------------------------------------------------------------------------------------
entity data_path is
    PORT
    (
        -----------------------------------------------------------------------------------
        -- General inputs
        -----------------------------------------------------------------------------------
        clk, rst                    : in    std_logic;

        -----------------------------------------------------------------------------------
        -- Inputs
        -----------------------------------------------------------------------------------
        -- Data
        FT_rx, USER_in              : in    std_logic_vector(7  downto 0);
        USER_A                      : in    std_logic_vector(14 downto 0);
        FL_IO                       : inout std_logic_vector(7  downto 0);

        -- Select Lines
        DP_SEL                      : in    std_logic_vector(2  downto 0);
        DP_ADDR_SEL                 : in    std_logic;

        -- Register Control
        pckt_id_ld, FL_rd_ld        : in    std_logic;
        dp_addr_ld_l, dp_addr_ld_h  : in    std_logic;

        -- Bus Control
        FL_IO_OUT_EN                : in    std_logic;

        -----------------------------------------------------------------------------------
        -- Outputs
        -----------------------------------------------------------------------------------
        DP_out                      : out   std_logic_vector(7  downto 0);
        FL_addr                     : out   std_logic_vector(14 downto 0)
    );
end data_path;

architecture BHV of data_path is
    ---------------------------------------------------------------------------------------
    -- Constants
    ---------------------------------------------------------------------------------------
    -- Packet Data
    constant HEADER             : std_logic_vector(7 downto 0) := x"55";
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

    -- Bus
    signal DP                   : std_logic_vector(7  downto 0);
    signal DP_ADDR              : std_logic_vector(14 downto 0);
    signal FL_rx                : std_logic_vector(7  downto 0);

    -- Registers
    signal pckt_id, FL_rd       : std_logic_vector(7  downto 0);

begin

    ---------------------------------------------------------------------------------------
    -- "DP_MUX" handles switching between potential data to occupy the data path.
    ---------------------------------------------------------------------------------------
    DP_MUX : entity work.mux8to1
        GENERIC MAP
        (
            width => 8
        )
        PORT MAP
        (
            sel     => DP_SEL,
            A       => (others => '0'), -- Original input was creating combinational logic loops
            B       => FT_rx,
            C       => USER_in,
            D       => pckt_id,
            E       => HEADER,
            F       => NACK,
            G       => ACK,
            H       => FL_rd,
            output  => DP
        );

    ---------------------------------------------------------------------------------------
    -- The "ADDR_MUX" choses which address will be used to interface with the flash.
    ---------------------------------------------------------------------------------------
    ADDR_MUX : entity work.mux2to1
        GENERIC MAP
        (
            width => 15
        )
        PORT MAP
        (
            sel     => DP_ADDR_SEL,
            A       => USER_A,
            B       => DP_ADDR,
            output  => FL_addr
        );

    ---------------------------------------------------------------------------------------
    -- The "PCKT_ID_REG" is used to hold the value of the incoming packet ID so that the
    --  controllers may act accordingly.
    ---------------------------------------------------------------------------------------
    PCKT_ID_REG : entity work.generic_register
        GENERIC MAP 
        (
            width => 8
        )
        PORT MAP
        (
            clk     => clk,
            rst     => rst,
            ld      => pckt_id_ld,
            input   => DP,
            output  => pckt_id
        );

    ---------------------------------------------------------------------------------------
    -- The "FL_READ_REG" acts as a buffer for the incoming 8-bit data from the flash.
    ---------------------------------------------------------------------------------------
    FL_READ_REG : entity work.generic_register
        GENERIC MAP 
        (
            width => 8
        )
        PORT MAP
        (
            clk     => clk,
            rst     => rst,
            ld      => FL_rd_ld,
            input   => FL_rx,
            output  => FL_rd
        );

    ---------------------------------------------------------------------------------------
    -- The "DP_ADDR_REG" is both the address buffer and a means to load the 15-bit address
    --  bus using the 8-bit data path.
    ---------------------------------------------------------------------------------------
    DP_ADDR_REG : entity work.memory_register
        PORT MAP
        (
            clk     => clk,
            rst     => rst,
            ld_l    => DP_ADDR_LD_L,
            ld_h    => DP_ADDR_LD_H,
            input   => DP,
            output  => DP_ADDR
        );

    -- Data path
    DP_OUT <= DP;

    -- FLASH IO handling
    FL_IO <= DP when FL_IO_OUT_EN = '1'
                else (others => 'Z');
    FL_rx <= FL_IO;

end BHV;