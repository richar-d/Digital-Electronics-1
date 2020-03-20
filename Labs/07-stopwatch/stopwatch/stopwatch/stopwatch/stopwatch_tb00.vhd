--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:15:31 03/19/2020
-- Design Name:   
-- Module Name:   C:/Users/Marek/Desktop/Labs07-stopwatch/stopwatch/stopwatch_tb00.vhd
-- Project Name:  stopwatch
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: stopwatch
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY stopwatch_tb00 IS
END stopwatch_tb00;
 
ARCHITECTURE behavior OF stopwatch_tb00 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT stopwatch
    PORT(
         hth_l_o : OUT  std_logic_vector(3 downto 0);
         hth_h_o : OUT  std_logic_vector(3 downto 0);
         sec_l_o : OUT  std_logic_vector(3 downto 0);
         sec_h_o : OUT  std_logic_vector(3 downto 0);
         clk_i : IN  std_logic;
         srst_n_i : IN  std_logic;
         cnt_en_i : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk_i : std_logic := '0';
   signal srst_n_i : std_logic := '0';
   signal cnt_en_i : std_logic := '0';

 	--Outputs
   signal hth_l_o : std_logic_vector(3 downto 0);
   signal hth_h_o : std_logic_vector(3 downto 0);
   signal sec_l_o : std_logic_vector(3 downto 0);
   signal sec_h_o : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant clk_i_period : time := 0.1 ms;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: stopwatch PORT MAP (
          hth_l_o => hth_l_o,
          hth_h_o => hth_h_o,
          sec_l_o => sec_l_o,
          sec_h_o => sec_h_o,
          clk_i => clk_i,
          srst_n_i => srst_n_i,
          cnt_en_i => cnt_en_i
        );

   -- Clock process definitions
   clk_i_process :process
   begin
		clk_i <= '0';
		wait for clk_i_period/2;
		clk_i <= '1';
		wait for clk_i_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 10 ms;	

		srst_n_i <= '1';
		cnt_en_i <= '1';  --normalni citani
      -- insert stimulus here 
		wait for 200ms;
		
		cnt_en_i <= '0'; --zastaveni citani
		
		wait for 100ms;
		
		cnt_en_i <= '1';
		
		wait for 800 ms;
		
		srst_n_i <= '0'; --vynulovani citace
		
		wait for 150 ms;
		
		srst_n_i <= '1'; --normalni citani
		cnt_en_i <= '1';

      wait;
   end process;

END;
