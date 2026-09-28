library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.sobel_pkg.ALL; -- Imports linebuffer, window_extractor, gradients, etc.

entity sobel_system is
    Generic (
        DATA_WIDTH  : integer := 8;
        LINE_LENGTH : integer := 100  -- Configured for your 100x100 image
    );
    Port (
        clk             : in  STD_LOGIC;
        rst             : in  STD_LOGIC;
        
        -- Control Inputs
        start           : in  STD_LOGIC;
        pixel_valid_in  : in  STD_LOGIC;
        
        -- Data Input
        pixel_in        : in  STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
        
        -- System Outputs
        magnitude_out   : out STD_LOGIC_VECTOR(10 downto 0);
        pixel_valid_out : out STD_LOGIC;
        frame_done      : out STD_LOGIC
    );
end sobel_system;

architecture Structural of sobel_system is

       -- ==========================================
    -- INTERNAL SIGNALS
    -- ==========================================
    -- Control path signals from FSM
    signal sig_we_lb   : STD_LOGIC;
    signal sig_we_win  : STD_LOGIC;
    signal sig_we_math : STD_LOGIC;

    -- Data path signals for Line Buffers
    signal sig_lb0_out : STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
    signal sig_lb1_out : STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);

    -- Data path signals for 3x3 Window
    signal sig_p00, sig_p01, sig_p02 : STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
    signal sig_p10, sig_p11, sig_p12 : STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
    signal sig_p20, sig_p21, sig_p22 : STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);

    -- Data path signals for Gradients
    signal sig_gx : STD_LOGIC_VECTOR(10 downto 0);
    signal sig_gy : STD_LOGIC_VECTOR(10 downto 0);

begin
    -- to be completed by students
    
    
    -- ==========================================
    -- 1. CONTROL UNIT (FSM)
    -- ==========================================
    FSM_INST: sobel_fsm
        port map (
            clk             => clk,
            rst             => rst,
            start           => start,
            pixel_valid_in  => pixel_valid_in,
            we_lb           => sig_we_lb,
            we_win          => sig_we_win,
            we_math         => sig_we_math,
            pixel_valid_out => pixel_valid_out,
            frame_done      => frame_done
        );
        
    -- ==========================================
    -- 2. MEMORY PIPELINE (Line Buffers)
    -- ==========================================
    LB0_INST: linebuffer
        generic map (
            DATA_WIDTH  => DATA_WIDTH,
            LINE_LENGTH => LINE_LENGTH
        )
        port map (
            clk      => clk,
            rst      => rst,
            we       => sig_we_lb,
            data_in  => pixel_in,
            data_out => sig_lb0_out
        );

    LB1_INST: linebuffer
        generic map (
            DATA_WIDTH  => DATA_WIDTH,
            LINE_LENGTH => LINE_LENGTH
        )
        port map (
            clk      => clk,
            rst      => rst,
            we       => sig_we_lb,
            data_in  => sig_lb0_out,
            data_out => sig_lb1_out
        );
    -- ==========================================
    -- 3. SLIDING WINDOW EXTRACTOR
    -- ==========================================
    WIN_EXTRACTOR_INST: window_extractor_3x3
        generic map (
            DATA_WIDTH => DATA_WIDTH
        )
        port map (
            clk      => clk,
            rst      => rst,
            we       => sig_we_win,
            row0_in  => pixel_in,     -- Incoming raw pixel stream
            row1_in  => sig_lb0_out,  -- Delayed by 1 line
            row2_in  => sig_lb1_out,  -- Delayed by 2 lines
            p00 => sig_p00, p01 => sig_p01, p02 => sig_p02,
            p10 => sig_p10, p11 => sig_p11, p12 => sig_p12,
            p20 => sig_p20, p21 => sig_p21, p22 => sig_p22
        );

    -- ==========================================
    -- 4. MATH PIPELINE (Gradients & Magnitude)
    -- ==========================================
    GRADIENTS_INST: sobel_gradients
        port map (
            clk   => clk,
            rst   => rst,
            we    => sig_we_math,
            p00   => sig_p00, p01 => sig_p01, p02 => sig_p02,
            p10   => sig_p10, p11 => sig_p11, p12 => sig_p12,
            p20   => sig_p20, p21 => sig_p21, p22 => sig_p22,
            gx_out => sig_gx,
            gy_out => sig_gy
        );

    MAG_CALC_INST: magnitude_calc
        port map (
            clk     => clk,
            rst     => rst,
            we      => sig_we_math,
            gx_in   => sig_gx,
            gy_in   => sig_gy,
            mag_out => magnitude_out
        );
end Structural;