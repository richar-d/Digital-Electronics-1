library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity light_controller is 
	port (
	clk_i : in std_logic; -- clock 10kHz
	s_rst_i : in std_logic; --  reset
	clock_enable : in std_logic;
	lights_o : out std_logic_vector (6-1 downto 0) -- LED output
	);
end entity light_controller;

architecture traffic of light_controller is
	type state_type is (green_red, yellow_red, red_red0, red_green, red_yellow, red_red1); -- NorthSouth_EastWest
	signal state: state_type;
   signal count : unsigned(4-1 downto 0) := "0000";
   constant sec5: unsigned(3 downto 0) := "0100";
   constant sec1: unsigned(3 downto 0) := "0000";
	 
begin
p_state_change : process(clk_i, s_rst_i)
begin
	if rising_edge(clk_i) then
		
		if s_rst_i = '0' then --clock reset
			state <= green_red; --state 0
			count <= x"0";
			
      elsif clock_enable = '1' then
		
			case state is
			
				when green_red =>
					if count < sec5 then
						state <= green_red;
						count <= count + 1;
					else
						state <= yellow_red;
						count <= x"0";
					end if;
					
				when yellow_red =>
					if count < sec1 then
						state <= yellow_red;
						count <= count + 1;
					else
						state <= red_red0;
						count <= x"0";
					end if;
					
				when red_red0 =>
					if count < sec1 then
						state <= red_red0;
						count <= count + 1;
					else
						state <= red_green;
						count <= x"0";
					end if;
					
				when red_green =>
					if count < sec5 then
						state <= red_green;
						count <= count + 1;
					else
						state <= red_yellow;
						count <= x"0";
					end if;
					
				when red_yellow =>
					if count < sec1 then
						state <= red_yellow;
						count <= count + 1;
					else
						state <= red_red1;
						count <= x"0";
					end if;
						
				when red_red1 =>
					if count < sec1 then
						state <= red_red1;
						count <= count + 1;
					else
						state <= green_red;
						count <= x"0";
					end if;
					
				when others =>
					state <= green_red;

					
			end case;
		end if;
	end if;
end process;

p_light_out : process(state)
begin
	
	case state is --green_red, yellow_red, red_red0, red_green, red_yellow, red_red1
	
		when green_red =>
		lights_o <= "100001";		

		when yellow_red =>
		lights_o <= "010001";
		
		when red_red0 =>
		lights_o <= "001001";
		
		when red_green =>
		lights_o <= "001100";

		when red_yellow =>
		lights_o <= "001010";
		
		when red_red1 =>
		lights_o <= "001001";
		
	end case;
end process;
																							
end architecture traffic;


--              NorthSouth                 /                   EastWest
-------------------------------------------/---------------------------------------------
--                green                    /                     red 
--                yellow                   /                     red 
--                 red                     /                     red0
--                 red                     /                    green
--                 red                     /                    yellow 
--                 red                     /                     red1
-----------------------------------------------------------------------------------------
--   green        yellow         red       /       green        yellow         red

-- lights_o(5)  lights_o(4)   lights_o(3)  /    lights_o(2)   lights_o(1)  lights_o(0)

-- Normální sekvence >> 100001
--                      010001
--                      001001
--                      001100
--                      001010
--                      001001


