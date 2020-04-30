----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:50:08 04/22/2020 
-- Design Name: 
-- Module Name:    control_logic - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity control_logic is
port(
	n_code_butt : in std_logic;
	clk_i : in  std_logic;
	s_reset : in std_logic;
	
	thous_in : in std_logic_vector (3 downto 0);
	hund_in : in std_logic_vector (3 downto 0);
	tens_in : in std_logic_vector (3 downto 0);
	uni_in : in std_logic_vector (3 downto 0);
	
--	thous_in : in integer range 0 to 9 := 0;
--	hund_in : in integer range 0 to 9 := 0;
--	tens_in : in integer range 0 to 9 := 0;
--	uni_in : in integer range 0 to 9 := 0;
	
	signal_LED : out std_logic := '1';
--	thous : out integer range 0 to 9 := 0;
--	hund : out integer range 0 to 9 := 0;
--	tens : out integer range 0 to 9 := 0;
--	uni : out integer range 0 to 9 := 0

	thous : out std_logic_vector (3 downto 0);
	hund : out std_logic_vector (3 downto 0);
	tens : out std_logic_vector (3 downto 0);
	uni : out std_logic_vector (3 downto 0)
	
);
end control_logic;

architecture Behavioral of control_logic is

	signal clock_en : std_logic;
	signal enable_set_val : std_logic := '1';
	
	signal s_cnt0 : unsigned (3 downto 0);
   signal s_cnt1 : unsigned (3 downto 0); 
   signal s_cnt2 : unsigned (3 downto 0);
   signal s_cnt3 : unsigned (3 downto 0);
	
--	signal s_cnt0 : integer range 0 to 9;
--   signal s_cnt1 : integer range 0 to 9; 
--   signal s_cnt2 : integer range 0 to 9;
--   signal s_cnt3 : integer range 0 to 9;
	
begin

	clock_enable : entity work.clock_enable
	port map(
		clk_i => clk_i,
		srst_n_i => s_reset,
		clock_enable_o => clock_en
	);

	control : process (clk_i, n_code_butt, s_cnt0, s_cnt1, s_cnt2, s_cnt3)
		
	begin

	if rising_edge(clk_i) then
	
		if s_reset = '0' then
			signal_LED <= '1';

			thous <= "0000";
			hund <= "0000";
			tens <= "0000";
			uni <= "0000";
			enable_set_val <= '1';
		else
	
			if n_code_butt = '1' then -- and enable_set_val = '1' then
		
				enable_set_val <= '0';
				s_cnt3 <= unsigned(thous_in);
				s_cnt2 <= unsigned(hund_in);
				s_cnt1 <= unsigned(tens_in);
				s_cnt0 <= unsigned(uni_in);
				signal_LED <= '1';
		
			elsif n_code_butt = '0' then
		
				if enable_set_val = '0' and clock_en = '1' then

						s_cnt0 <= s_cnt0 - 1;
               
						if s_cnt0 = 0 then
							s_cnt0 <= "1001";
							s_cnt1 <= s_cnt1 - 1;
                   
							if s_cnt1 = 0 then
									s_cnt1 <= "1001";
									s_cnt2 <= s_cnt2 - 1;
                       
                        if s_cnt2 = 0 then
                            s_cnt2 <= "1001";
                            s_cnt3 <= s_cnt3 - 1;
                           
                            if s_cnt3 = 0 then
                                s_cnt3 <= "1001";
                            end if;
                        end if;
                    end if;
                end if; 
					 
					 			
				if s_cnt0 = 0 and s_cnt1 = 0 and s_cnt2 = 0 and s_cnt3 = 0 and clock_en = '1' then
				
					signal_LED <= '0';
					enable_set_val <= '1';
					
					thous <= std_logic_vector(thous_in);
					hund <= std_logic_vector(hund_in);
					tens <= std_logic_vector(tens_in);
					uni <= std_logic_vector(uni_in);
				
				end if;
					 
		
					thous <= std_logic_vector(s_cnt3);
					hund <= std_logic_vector(s_cnt2);
					tens <= std_logic_vector(s_cnt1);
					uni <= std_logic_vector(s_cnt0);
				
				elsif enable_set_val = '1' then
					
					s_cnt0 <= unsigned(uni_in);
					s_cnt1 <= unsigned(tens_in);
					s_cnt2 <= unsigned(hund_in);
					s_cnt3 <= unsigned(thous_in);
					
					thous <= thous_in;
					hund <= hund_in;
					tens <= tens_in;
					uni <= uni_in;
			
				end if;
		
			end if;
		end if;
	end if;
	
	
	end process control;

end Behavioral;