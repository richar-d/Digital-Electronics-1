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
	
	signal cnt_en0 : std_logic := '1'; --signály pro povolení inkrementace na další dekádu
	signal cnt_en1 : std_logic;
	signal cnt_en2 : std_logic;
	signal cnt_en3 : std_logic;
	
	signal erase_en0 : std_logic := '1'; --signály pro povolení nulování èítaèe
	signal erase_en1 : std_logic;
	signal erase_en2 : std_logic;
	signal erase_en3 : std_logic;
	
begin

-----------------------pomocne promene pro citani dekad----------------------------

	process (s_cnt0, s_cnt1, cnt_en1, cnt_en2, cnt_en3)
	begin
	
	if (s_cnt0 = "1001") then
		cnt_en1 <= '1';
		erase_en1 <= '1';
	else
		cnt_en1 <= '0';
		erase_en1 <= '0';
	end if;
	
	if s_cnt0 = "1001" and s_cnt1 = "1001"  then
		cnt_en2 <= '1';
		erase_en2 <= '1';
	else
		cnt_en2 <= '0';
		erase_en2 <= '0';
	end if;
	
	if s_cnt0 = "1001" and s_cnt1 = "1001" and s_cnt2 = "1001"  then
		cnt_en3 <= '1';
		erase_en3 <= '1';
	else
		cnt_en3 <= '0';
		erase_en3 <= '0';
	end if;
	
	end process;

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

	BCD_0 : entity work.BCD
	port map(
		cnt_o => s_cnt0,
		clk_i => clk_i,
		srst_n_i => srst_n_i,
		cnt_en_i => cnt_en_i,
		s_en => s_en,
		cnt_en => cnt_en0,
		erase_en => erase_en0
	);
	
	hth_l_o <= std_logic_vector(s_cnt0);

	
-----------------------------BCD counter pro desetiny sekundy-----------------------------------	
	
	BCD_1 : entity work.BCD
	port map(
		cnt_o => s_cnt1,
		clk_i => clk_i,
		srst_n_i => srst_n_i,
		cnt_en_i => cnt_en_i,
		s_en => s_en,
		cnt_en => cnt_en1,
		erase_en => erase_en1
	);
	
	hth_h_o <= std_logic_vector(s_cnt1);


-----------------------------BCD counter pro jednotky sekundy-----------------------------------	

	BCD_2 : entity work.BCD
	port map(
		cnt_o => s_cnt2,
		clk_i => clk_i,
		srst_n_i => srst_n_i,
		cnt_en_i => cnt_en_i,
		s_en => s_en,
		cnt_en => cnt_en2,
		erase_en => erase_en2
	);
	
	sec_l_o <= std_logic_vector(s_cnt2);
	
---------------------------BCD counter pro desitky sekundy----------------------------------------

	BCD_3 : entity work.BCD
	port map(
		cnt_o => s_cnt3,
		clk_i => clk_i,
		srst_n_i => srst_n_i,
		cnt_en_i => cnt_en_i,
		s_en => s_en,
		cnt_en => cnt_en3,
		erase_en => erase_en3
	);
	
	sec_h_o <= std_logic_vector(s_cnt3);	
	
end Behavioral;







