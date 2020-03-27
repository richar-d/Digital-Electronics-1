----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:33:30 03/26/2020 
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
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
	port (
	clk_i : in std_logic; -- clock 10kHz
	s_rst_i : in std_logic; --  reset
	
	lights_o : out std_logic_vector (6-1 downto 0) -- LED output
	);
	
end entity top;

architecture Behavioral of top is
	signal s_en : std_logic;
begin
	clock_en0 : entity work.clock_enable
		generic map (
			g_NPERIOD => x"2710" -- pro èasování 1 vteøina
		)
		port map(
		srst_n_i => s_rst_i,
		clk_i => clk_i,
		clock_enable_o => s_en
		);
		
	light_contr : entity work.light_controller
		port map (
		clk_i => clk_i,
		s_rst_i => s_rst_i,
		lights_o => lights_o,
		clock_enable => s_en
		);
		

end architecture Behavioral;
