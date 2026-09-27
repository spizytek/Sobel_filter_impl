library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity linebuffer is
    Generic (
        DATA_WIDTH  : integer := 8;    
        LINE_LENGTH : integer := 100   
    );
    Port (
        clk      : in  STD_LOGIC;
        rst      : in  STD_LOGIC;
        we       : in  STD_LOGIC;
        data_in  : in  STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
        data_out : out STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0)
    );
end linebuffer;

architecture Behavioral of linebuffer is

    -- Define shift register as an array of pure STD_LOGIC_VECTORs.
    type shift_reg_type is array (0 to LINE_LENGTH - 1) of STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
    
    -- Initialize the shift register chain.
    signal shift_reg : shift_reg_type := (others => (others => '0'));

begin

-- to be completed by students
process (clk, rst)
begin
    -- Synchronous process with clk and rst.
    if rising_edge(clk) then
        if rst = '1' then
            shift_reg <= (others => (others => '0'));
        
        elsif we = '1' then
            -- we need to shift the register so that, the 
            -- oldest entered element in the registere leaves through (data_out)
            shift_reg(1 to LINE_LENGTH - 1) <= shift_reg(0 to LINE_LENGTH - 2); 
            shift_reg(0) <= data_in;
        end if;  -- end if-statement
    end if; -- rising edge if-statement

    -- the current last element in the buffer is sent to the output
    data_out <= shift_reg(LINE_LENGTH - 1);
end process;


end Behavioral;