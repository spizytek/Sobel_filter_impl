library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity magnitude_calc is
    Port (
        clk     : in  STD_LOGIC;
        rst     : in  STD_LOGIC;
        we      : in  STD_LOGIC;
        gx_in   : in  STD_LOGIC_VECTOR(10 downto 0);
        gy_in   : in  STD_LOGIC_VECTOR(10 downto 0);
        
        mag_out : out STD_LOGIC_VECTOR(10 downto 0)
    );
end magnitude_calc;

architecture Structural of magnitude_calc is

    
    component add_sub_n is
        Generic ( N : integer := 11 );
        Port (
            A    : in  STD_LOGIC_VECTOR(N-1 downto 0);
            B    : in  STD_LOGIC_VECTOR(N-1 downto 0);
            sub  : in  STD_LOGIC;
            Sum  : out STD_LOGIC_VECTOR(N-1 downto 0);
            Cout : out STD_LOGIC
        );
    end component;

    -- A constant zero vector to use for our subtraction trick
    constant ZERO_11 : STD_LOGIC_VECTOR(10 downto 0) := (others => '0');

    -- Internal combinational signals
    signal abs_gx   : STD_LOGIC_VECTOR(10 downto 0);
    signal abs_gy   : STD_LOGIC_VECTOR(10 downto 0);
    signal mag_comb : STD_LOGIC_VECTOR(10 downto 0);

begin

-- to be completed by students

    -- ==========================================
    -- 1. ABSOLUTE VALUE OF Gx
    -- ==========================================


    -- ==========================================
    -- 2. ABSOLUTE VALUE OF Gy
    -- ==========================================


    -- ==========================================
    -- 3. MAGNITUDE SUM
    -- ==========================================


    -- ==========================================
    -- 4. SYNCHRONOUS OUTPUT PIPELINE REGISTER
    -- ==========================================


end Structural;