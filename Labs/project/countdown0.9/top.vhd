----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:07:26 04/28/2020 
-- Design Name: 
-- Module Name:    top - Behavioral 
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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity top is

	port(
		pinA_i : in std_logic;
		pinB_i : in std_logic;
		butt_i : in std_logic;
		clk_i : in std_logic;
		s_reset_i : in std_logic;
		
		sclk_o : out std_logic;
		dio_o : out std_logic;
		LED_o : out std_logic
	);


end top;

architecture Behavioral of top is

	signal n_code_butt : std_logic;
	
	signal thous_c : integer range 0 to 9; -- from control logic
   signal hund_c : integer range 0 to 9; 
   signal tens_c : integer range 0 to 9;
   signal uni_c : integer range 0 to 9; 
	
	signal thous_n : integer range 0 to 9; -- from ncoder
   signal hund_n : integer range 0 to 9; 
   signal tens_n : integer range 0 to 9;
   signal uni_n : integer range 0 to 9;

begin

	control_logic : entity work.control_logic
	port map(
		n_code_butt => n_code_butt,
		clk_i => clk_i,
		signal_LED => LED_o,
		s_reset => s_reset_i,
		thous_in => thous_n,
		hund_in => hund_n,
		tens_in => tens_n,
		uni_in => uni_n,
		
		thous => thous_c,
		hund => hund_c,
		tens => tens_c,
		uni => uni_c
	);

	TM1637 : entity work.TM1637
	port map(
		clk_i => clk_i,
		sclk => sclk_o,
		dio => dio_o,
		thous => thous_c,
		hund => hund_c,
		tens => tens_c,
		uni => uni_c
	);
	
	KY_040 : entity work.KY_040
	port map(
		clk_i => clk_i,
		CLK => pinA_i,
		DT => pinB_i,
		SW => butt_i,
		start_countdown => n_code_butt,
		thous_n => thous_n,
		hund_n => hund_n,
		tens_n => tens_n,
		uni_n => uni_n
	);

end Behavioral;

