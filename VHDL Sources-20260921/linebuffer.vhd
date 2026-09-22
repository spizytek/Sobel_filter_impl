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

end Behavioral;