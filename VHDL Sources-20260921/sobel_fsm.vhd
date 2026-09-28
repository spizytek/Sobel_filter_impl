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
     -- FSM implementation
     process(clk)
     begin

     if rising_edge(clk) then
     -- check for reset 
        if rst = '1' then
            current_state <= IDLE;
            col_count     <= 0;
            row_count     <= 0;
    else
        case current_state is
            
            when IDLE =>
                col_count <= 0;
                row_count <= 0;
                if start = '1' then
                    current_state <= FILL_LB0;
                end if;

            when FILL_LB0 =>
                if pixel_valid_in = '1' then
                    if col_count = IMAGE_WIDTH - 1 then
                        col_count     <= 0;
                        row_count     <= 1;
                        current_state <= FILL_LB1;
                    else
                        col_count <= col_count + 1;
                    end if;
                end if;

            when FILL_LB1 =>
                if pixel_valid_in = '1' then
                    if col_count = IMAGE_WIDTH - 1 then
                        col_count     <= 0;
                        row_count     <= 2;
                        current_state <= PROCESS_ROW;
                    else
                        col_count <= col_count + 1;
                    end if;
                end if;

            when PROCESS_ROW =>
                if pixel_valid_in = '1' then
                    if col_count = IMAGE_WIDTH - 1 then
                        col_count <= 0;
                        if row_count = IMAGE_HEIGHT - 1 then
                            current_state <= FINISHED;
                        else
                            row_count <= row_count + 1;
                        end if;
                    else
                        col_count <= col_count + 1;
                    end if;
                end if;

            when FINISHED =>
                if start = '0' then
                    current_state <= IDLE;
                end if;

            when others =>
                current_state <= IDLE;

        end case;
     end if; -- rising edge
     end process; -- process


-- Control and shift register
process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                ctrl_pipe <= (others => ('0', '0'));
            else
                -- Stage 0 Input Generation
                if current_state = PROCESS_ROW and pixel_valid_in = '1' then
                    -- Valid only when a 3x3 window is available (col_count >= 2)
                    if col_count >= 2 then
                        ctrl_pipe(0).valid <= '1';
                    else
                        ctrl_pipe(0).valid <= '0';
                    end if;

                    -- End of Frame pulse generated at final pixel
                    if col_count = IMAGE_WIDTH - 1 and row_count = IMAGE_HEIGHT - 1 then
                        ctrl_pipe(0).eof <= '1';
                    else
                        ctrl_pipe(0).eof <= '0';
                    end if;
                else
                    ctrl_pipe(0) <= ('0', '0');
                end if;

                -- Shift register: propagate valid/eof through 3 pipeline stages
                for i in 1 to PIPELINE_STAGES - 1 loop
                    ctrl_pipe(i) <= ctrl_pipe(i - 1);
                end loop;
            end if;
        end if;
    end process;

-- Output Logic
-- Assert write-enables synchronously with pixel_valid_in
    we_lb   <= pixel_valid_in when (current_state = FILL_LB0 or current_state = FILL_LB1 or current_state = PROCESS_ROW) else '0';
    we_win  <= pixel_valid_in when (current_state = FILL_LB0 or current_state = FILL_LB1 or current_state = PROCESS_ROW) else '0';
    we_math <= pixel_valid_in when (current_state = PROCESS_ROW) else '0';

    -- Output delayed valid and eof from final pipeline stage
    pixel_valid_out <= ctrl_pipe(PIPELINE_STAGES - 1).valid;
    frame_done      <= ctrl_pipe(PIPELINE_STAGES - 1).eof;
end architecture rtl;