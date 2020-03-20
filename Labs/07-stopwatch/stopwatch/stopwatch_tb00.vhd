--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:01:07 03/20/2020
-- Design Name:   
-- Module Name:   C:/Users/Marek/Desktop/DE Moje/Digital-electronics-1-master/Labs/07-stopwatch/07-stopwatch/stopwatch/stopwatch_tb00.vhd
-- Project Name:  stopwatch
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: stopwatch_driver
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
 
    COMPONENT stopwatch_driver
    PORT(
         clk_i : IN  std_logic;
         srst_n_i : IN  std_logic;
         cnt_en_i : IN  std_logic;
         dp_i : IN  std_logic_vector(3 downto 0);
         dp_o : OUT  std_logic;
         seg_o : OUT  std_logic_vector(6 downto 0);
         dig_o : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk_i : std_logic := '0';
   signal srst_n_i : std_logic := '0';
   signal cnt_en_i : std_logic := '0';
   signal dp_i : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal dp_o : std_logic;
   signal seg_o : std_logic_vector(6 downto 0);
   signal dig_o : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant clk_i_period : time := 0.1 ms;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: stopwatch_driver PORT MAP (
          clk_i => clk_i,
          srst_n_i => srst_n_i,
          cnt_en_i => cnt_en_i,
          dp_i => dp_i,
          dp_o => dp_o,
          seg_o => seg_o,
          dig_o => dig_o
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
      wait for 100 ns;	

      wait for clk_i_period*10;

      srst_n_i <= '1';
		cnt_en_i <= '1';
		dp_i <= "1011";

      wait;
   end process;

END;
