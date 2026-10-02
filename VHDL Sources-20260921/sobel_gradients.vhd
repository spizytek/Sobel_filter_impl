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
    -- Converting 8bits input to 11bits unsigned
    pad_p00 <= "000" & p00;
    pad_p02 <= "000" & p02;
    pad_p20 <= "000" & p20;
    pad_p22 <= "000" & p22;

    -- Converting 8bits input to 11bits signed
    pad_p10_x2 <= "00" & p10 & '0';
    pad_p12_x2 <= "00" & p12 & '0';
    pad_p01_x2 <= "00" & p01 & '0';
    pad_p21_x2 <= "00" & p21 & '0';

    -- Note: p11 is ignored because in both Gx and Gy, p11 remains 0.
    -- To compute these in hardware, you need to solve two problems:
    -- 1. Multiply by 2 for the middle terms (p_{10}, p_{12}, p_{01}, p_{21}).
    -- 1. Prevent bit overflow during additions and handle signed negative numbers during the final subtraction.
    
    -- Calculating for Gx using the formular.
    -- (p02 + 2*p12 + p22) - (p00 + 2*p10 + p20). 
    -- Gx = Right column - Left column

    -- Calculating the (p02 + 2*p12 + p22) part of the equation.
    ADD_GX_L1: add_sub_n
    generic map ( N => 11 )
    port map (
        A =>pad_p02,
        B =>pad_p12_x2,
        sub =>'0',
        Sum => sum_gx_L1,
        Cout => open
    );

    ADD_GX_L2: add_sub_n
    generic map ( N => 11 )
    port map (
        A => pad_p22,
        B => sum_gx_L1,
        sub => '0',
        Sum => sum_gx_L_total,
        Cout => open
    );

    -- Calculating the (p00 + 2*p10 + p20) part of the equation.
    ADD_GX_R1: add_sub_n
    generic map ( N => 11 )
    port map (
        A => pad_p00,
        B => pad_p10_x2,
        sub => '0',
        Sum => sum_gx_R1,
        Cout => open
    );

    ADD_GX_R2: add_sub_n
    generic map ( N => 11 )
    port map (
        A => pad_p20,
        B => sum_gx_R1,
        sub => '0',
        Sum => sum_gx_R_total,
        Cout => open
    );

    -- Calculating the final Gx value
    SUB_GX_FINAL: add_sub_n
    generic map ( N => 11 )
    port map (
        A => sum_gx_L_total,
        B => sum_gx_R_total,
        sub => '1', -- operation is subtraction
        Sum => gx_comb,
        Cout => open
    );
    ----------for Gy-----------------------
    -- Gy = (p00 + 2*p01 + p02) - (p20 + 2*p21 + p22)
     
    -- Calculating the (p00 + 2*p01 + p02) part of the equation.
    ADD_GY_T1: add_sub_n
    generic map ( N => 11 )
    port map (
        A =>pad_p00,
        B =>pad_p01_x2,
        sub =>'0',
        Sum => sum_gy_T1,
        Cout => open
    );

    ADD_GY_T2: add_sub_n
    generic map ( N => 11 )
    port map (
        A =>pad_p02,
        B =>sum_gy_T1,
        sub =>'0',
        Sum => sum_gy_T_total,
        Cout => open
    );

    
    -- Calculating the (p20 + 2*p21 + p22) part of the equation.
    ADD_GY_B1: add_sub_n
    generic map ( N => 11 )
    port map (
        A =>pad_p20,
        B =>pad_p21_x2,
        sub =>'0',
        Sum => sum_gy_B1,
        Cout => open
    );

    ADD_GY_B2: add_sub_n
    generic map ( N => 11 )
    port map (
        A =>pad_p22,
        B =>sum_gy_B1,
        sub =>'0',
        Sum => sum_gy_B_total,
        Cout => open
    );

    -- Calculating the final Gy value
    SUB_GY_FINAL: add_sub_n
    generic map ( N => 11 )
    port map (
        A => sum_gy_T_total,
        B => sum_gy_B_total,
        sub => '1', -- operation is subtraction
        Sum => gy_comb,
        Cout => open
    );

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                gx_out <= (others => '0');
                gy_out <= (others => '0');
            else --if we = '1' then
                gx_out <= gx_comb;
                gy_out <= gy_comb;
            end if;
        end if;
    end process;

end Structural;