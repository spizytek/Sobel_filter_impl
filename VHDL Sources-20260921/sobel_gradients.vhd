library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sobel_gradients is
    Port (
        clk : in  STD_LOGIC;
        rst : in  STD_LOGIC;
        we  : in  STD_LOGIC;
        
        -- 3x3 Window Inputs (8-bit)
        p00, p01, p02 : in STD_LOGIC_VECTOR(7 downto 0);
        p10, p11, p12 : in STD_LOGIC_VECTOR(7 downto 0);
        p20, p21, p22 : in STD_LOGIC_VECTOR(7 downto 0);
        
        -- Gradients Output (11-bit signed Two's Complement)
        gx_out : out STD_LOGIC_VECTOR(10 downto 0);
        gy_out : out STD_LOGIC_VECTOR(10 downto 0)
    );
end sobel_gradients;

architecture Structural of sobel_gradients is

    component add_sub_n is
        Generic ( N : integer := 11 );
        Port (
            A, B : in  STD_LOGIC_VECTOR(N-1 downto 0);
            sub  : in  STD_LOGIC;
            Sum  : out STD_LOGIC_VECTOR(N-1 downto 0);
            Cout : out STD_LOGIC
        );
    end component;

    -- Padded signals to 11 bits. 
    signal pad_p00, pad_p02 : STD_LOGIC_VECTOR(10 downto 0);
    signal pad_p20, pad_p22 : STD_LOGIC_VECTOR(10 downto 0);
    signal pad_p10_x2, pad_p12_x2 : STD_LOGIC_VECTOR(10 downto 0);
    signal pad_p01_x2, pad_p21_x2 : STD_LOGIC_VECTOR(10 downto 0);
    
    -- Intermediate Sums
    signal sum_gx_L1, sum_gx_L_total : STD_LOGIC_VECTOR(10 downto 0);
    signal sum_gx_R1, sum_gx_R_total : STD_LOGIC_VECTOR(10 downto 0);
    signal sum_gy_T1, sum_gy_T_total : STD_LOGIC_VECTOR(10 downto 0);
    signal sum_gy_B1, sum_gy_B_total : STD_LOGIC_VECTOR(10 downto 0);
    
    -- Final Combinational Gradients
    signal gx_comb, gy_comb : STD_LOGIC_VECTOR(10 downto 0);

begin

-- to be completed by students

end Structural;