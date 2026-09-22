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
 
    -- ==========================================
    -- 2. MEMORY PIPELINE (Line Buffers)
    -- ==========================================
 
    -- ==========================================
    -- 3. SLIDING WINDOW EXTRACTOR
    -- ==========================================
    -- ==========================================
    -- 4. MATH PIPELINE (Gradients & Magnitude)
    -- ==========================================
 
end Structural;