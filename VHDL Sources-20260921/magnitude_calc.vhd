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

    signal opA_gx, opB_gx : STD_LOGIC_VECTOR(10 downto 0);
    signal opA_gy, opB_gy : STD_LOGIC_VECTOR(10 downto 0);

begin

-- to be completed by students

    -- ==========================================
    -- 1. ABSOLUTE VALUE OF Gx
    -- ==========================================
    -- If MSB of gx_in is 1 (negative), then = 0 - gx_in, else
    -- gx_in + 0

    opA_gx <= ZERO_11 when gx_in(10) = '1' else gx_in;
    opB_gx <= gx_in when gx_in(10) = '1' else ZERO_11;

    ABS_X_CALC: add_sub_n
    generic map (N => 11)
    port map(
        A   => opA_gx,
        B   => opB_gx,
        sub  => gx_in(10), -- '1' for negative, '0' for positive
        Sum  => abs_gx,
        Cout => open
    );

    -- ==========================================
    -- 2. ABSOLUTE VALUE OF Gy
    -- ==========================================
    opA_gy <= ZERO_11 when gy_in(10) = '1' else gy_in;
    opB_gy <= gy_in when gy_in(10) = '1' else ZERO_11;

    ABS_Y_CALC: add_sub_n
    generic map (N => 11)
    port map(
        A   => opA_gy,
        B   => opB_gy,
        sub  => gy_in(10), -- '1' for negative, '0' for positive
        Sum  => abs_gy,
        Cout => open
    );

    -- ==========================================
    -- 3. MAGNITUDE SUM
    -- ==========================================
    MAG_ADDER: add_sub_n
    generic map (N => 11)
    port map (
        A   => abs_gx,
        B   => abs_gy,
        sub  => '0', 
        Sum  => mag_comb,
        Cout => open
    );
    -- ==========================================
    -- 4. SYNCHRONOUS OUTPUT PIPELINE REGISTER
    -- ==========================================
    process(clk)
    begin
    if rising_edge(clk) then
        if rst = '1' then
            mag_out <= (others => '0') ;
        else --  if we = '1' then
            mag_out <= mag_comb;
        end if;
    end if;
    end process;

end Structural;