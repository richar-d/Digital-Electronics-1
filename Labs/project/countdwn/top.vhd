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
--use IEEE.STD_LOGIC_UNSIGNED.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

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
	
	signal thous_c : std_logic_vector(3 downto 0); -- from control logic
   signal hund_c : std_logic_vector(3 downto 0); 
   signal tens_c : std_logic_vector(3 downto 0);
   signal uni_c : std_logic_vector(3 downto 0); 

begin

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
		s_reset => s_reset_i,
		clk_i => clk_i,
		CLK => pinA_i,
		DT => pinB_i,
		SW => butt_i,
		thous => thous_c,
		hund => hund_c,
		tens => tens_c,
		uni => uni_c,
		signal_led => LED_o
	);
	

end Behavioral;

