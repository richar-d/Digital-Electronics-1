----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:15:42 03/19/2020 
-- Design Name: 
-- Module Name:    stopwatch - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity stopwatch is
port(
	hth_l_o : out std_logic_vector(4-1 downto 0);
	hth_h_o : out std_logic_vector(4-1 downto 0);
	sec_l_o : out std_logic_vector(4-1 downto 0);
	sec_h_o : out std_logic_vector(4-1 downto 0);
	
	clk_i : in std_logic;
	srst_n_i : in std_logic;
	cnt_en_i : in std_logic
);
end stopwatch;

architecture Behavioral of stopwatch is
	signal s_cnt0 : unsigned(4-1 downto 0) := (others => '0');
	signal s_cnt1 : unsigned(4-1 downto 0) := (others => '0');
	signal s_cnt2 : unsigned(4-1 downto 0) := (others => '0');
	signal s_cnt3 : unsigned(4-1 downto 0) := (others => '0');
	signal s_en : std_logic;
begin


---------------------clock enable entity-------------------------------------------
	clock_enable : entity work.clock_enable
	generic map(
		g_NPERIOD => x"0064"
	)
	port map(
		srst_n_i => srst_n_i,
		clk_i => clk_i,
		clock_enable_o => s_en
	);
	
-----------------------------BCD counter pro setiny sekundy-----------------------------------
    p_select_cnt0 : process (clk_i)
    begin
			if rising_edge(clk_i) then  -- Rising clock edge
            if ((srst_n_i = '0') or (s_cnt0 = x"0009" and s_en = '1')) then  -- Synchronous reset (active low)
                s_cnt0 <= (others => '0');   -- Clear all bits
            elsif (s_en = '1' and cnt_en_i = '1') then
                s_cnt0 <= s_cnt0 + 1; -- Normal operation
            end if;
         end if;
			hth_l_o <= std_logic_vector(s_cnt0); --zapis hodnoty citace do promene setiny sekundy
    end process p_select_cnt0;

------------------------------BCD counter pro desetiny sekundy-------------------------------------	 
	 p_select_cnt1 : process (clk_i)
    begin
			if rising_edge(clk_i) then  -- Rising clock edge
            if ((srst_n_i = '0') or (s_cnt1 = x"0009" and s_en = '1' and s_cnt0 = x"0009")) then  -- Synchronous reset (active low)
                s_cnt1 <= (others => '0');   -- Clear all bits
            elsif (s_en = '1' and s_cnt0 = x"0009" and cnt_en_i = '1') then
                s_cnt1 <= s_cnt1 + 1; -- Normal operation
            end if;
         end if;
			hth_h_o <= std_logic_vector(s_cnt1); --zapis hodnoty citace do promene desetiny sekundy
    end process p_select_cnt1; 

------------------------------BCD counter pro jednotky sekundy-------------------------------------
	 p_select_cnt2 : process (clk_i)
    begin
			if rising_edge(clk_i) then  -- Rising clock edge
            if ((srst_n_i = '0') or (s_cnt2 = x"0009" and s_en = '1' and s_cnt1 = x"0009" and s_cnt0 = x"0009" )) then  -- Synchronous reset (active low)
                s_cnt2 <= (others => '0');   -- Clear all bits
            elsif (s_en = '1' and s_cnt1 = x"0009" and s_cnt0 = x"0009" and cnt_en_i = '1') then
                s_cnt2 <= s_cnt2 + 1; -- Normal operation
            end if;
         end if;
			sec_l_o <= std_logic_vector(s_cnt2); --zapis hodnoty citace do promene jednotky sekundy
    end process p_select_cnt2;

------------------------------BCD counter pro desitky sekundy-------------------------------------
	 p_select_cnt3 : process (clk_i)
    begin
			if rising_edge(clk_i) then  -- Rising clock edge
            if ((srst_n_i = '0') or (s_cnt3 = x"0005" and s_cnt2 = x"0009" and s_en = '1' and s_cnt1 = x"0009" and s_cnt0 = x"0009")) then  -- Synchronous reset (active low)
                s_cnt3 <= (others => '0');   -- Clear all bits
            elsif (s_en = '1' and s_cnt1 = x"0009" and s_cnt0 = x"0009" and s_cnt2 = x"0009" and cnt_en_i = '1') then
                s_cnt3 <= s_cnt3 + 1; -- Normal operation
            end if;
         end if;
			sec_h_o <= std_logic_vector(s_cnt3); --zapis hodnoty citace do promene desitky sekundy
    end process p_select_cnt3;

end Behavioral;

