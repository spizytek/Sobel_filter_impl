library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sobel_fsm is
    generic (
        IMAGE_WIDTH  : integer := 100;
        IMAGE_HEIGHT : integer := 100
    );
    Port (
        clk             : in  STD_LOGIC;
        rst             : in  STD_LOGIC;
        start           : in  STD_LOGIC;
        pixel_valid_in  : in  STD_LOGIC;  
        
        -- Control Signals to the Pipeline
        we_lb           : out STD_LOGIC;  
        we_win          : out STD_LOGIC;  
        we_math         : out STD_LOGIC;  
        
        -- Status Signals
        pixel_valid_out : out STD_LOGIC;  
        frame_done      : out STD_LOGIC
    );
end sobel_fsm;

architecture rtl of sobel_fsm is
    type state_type is (IDLE, FILL_LB0, FILL_LB1, PROCESS_ROW, FINISHED);
    signal current_state : state_type;
    
    signal col_count : integer range 0 to IMAGE_WIDTH - 1  := 0;
    signal row_count : integer range 0 to IMAGE_HEIGHT - 1 := 0;

    type control_bus_t is record
        valid : std_logic;
        eof   : std_logic; 
    end record;

    constant PIPELINE_STAGES : integer := 3;
    type control_pipe_t is array (0 to PIPELINE_STAGES-1) of control_bus_t;
    
    signal ctrl_pipe : control_pipe_t := (others => ('0', '0'));

begin
     -- To be completed by students

end architecture rtl;