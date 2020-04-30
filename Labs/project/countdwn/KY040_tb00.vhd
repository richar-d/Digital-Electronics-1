--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:53:58 04/29/2020
-- Design Name:   
-- Module Name:   D:/SKOLA/letny/DE1/projekt/final/countdwn/KY040_tb00.vhd
-- Project Name:  countdwn
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: KY_040
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
 
ENTITY KY040_tb00 IS
END KY040_tb00;
 
ARCHITECTURE behavior OF KY040_tb00 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT KY_040
    PORT(
         clk_i : IN  std_logic;
         CLK : IN  std_logic;
         DT : IN  std_logic;
         SW : IN  std_logic;
         thous_n : OUT integer range 0 to 9; 
         hund_n : OUT  integer range 0 to 9;
         tens_n : OUT  integer range 0 to 9;
         uni_n : OUT  integer range 0 to 9;
         start_countdown : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk_i : std_logic := '0';
   signal CLK : std_logic := '0';
   signal DT : std_logic := '0';
   signal SW : std_logic := '0';
	signal firstTime : boolean := true;

 	--Outputs
   signal thous_n : integer range 0 to 9;
   signal hund_n : integer range 0 to 9;
   signal tens_n : integer range 0 to 9;
   signal uni_n : integer range 0 to 9;
   signal start_countdown : std_logic;

   -- Clock period definitions
   constant clk_i_period : time := 0.1 ms;
   constant CLK_period : time := 100 ms;
	constant DT_period : time := 100 ms;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: KY_040 PORT MAP (
          clk_i => clk_i,
          CLK => CLK,
          DT => DT,
          SW => SW,
          thous_n => thous_n,
          hund_n => hund_n,
          tens_n => tens_n,
          uni_n => uni_n,
          start_countdown => start_countdown
        );

   -- Clock process definitions
   clk_i_process :process
   begin
		clk_i <= '0';
		wait for clk_i_period/2;
		clk_i <= '1';
		wait for clk_i_period/2;
   end process;
 
   CLK_process :process
   begin
	-- make signal 1/4 of period late
		if firstTime then  
			firstTime <= false;
			wait for CLK_period/4;
		end if;
		
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 
  DT_process :process
   begin
	    
	 -- make signal 1/4 of period late
		-- if firstTime then  
		-- 	firstTime <= false;
		--	wait for DT_period/4;			
		--end if;
		
		DT <= '0';
		wait for DT_period/2;
		DT <= '1';
		wait for DT_period/2;
   end process;

   -- Stimulus process  
   stim_proc: process
		begin		
      wait for 200 ms; 	
		SW <= '1';      --check  if the switch sends out a signal
		wait for  200 ms;
		SW <= '0';

      wait for clk_i_period*10;


      wait;
   end process;

END;
