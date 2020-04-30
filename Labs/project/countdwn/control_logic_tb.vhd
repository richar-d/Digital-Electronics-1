--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:03:28 04/29/2020
-- Design Name:   
-- Module Name:   C:/Users/Marek/Desktop/Seb_Svob/countdwn/control_logic_tb.vhd
-- Project Name:  countdwn
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: control_logic
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
 
ENTITY control_logic_tb IS
END control_logic_tb;
 
ARCHITECTURE behavior OF control_logic_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT control_logic
    PORT(
         n_code_butt : IN  std_logic;
         clk_i : IN  std_logic;
         s_reset : IN  std_logic;
         thous_in : IN  integer range 0 to 9;
         hund_in : IN  integer range 0 to 9;
         tens_in : IN  integer range 0 to 9;
         uni_in : IN  integer range 0 to 9;
         signal_LED : OUT  std_logic;
         thous : OUT  integer range 0 to 9;
         hund : OUT  integer range 0 to 9;
         tens : OUT  integer range 0 to 9;
         uni : OUT  integer range 0 to 9
        );
    END COMPONENT;
    

   --Inputs
   signal n_code_butt : std_logic := '0';
   signal clk_i : std_logic := '0';
   signal s_reset : std_logic := '1';
   signal thous_in : integer range 0 to 9 := 0;
   signal hund_in : integer range 0 to 9 := 0;
   signal tens_in : integer range 0 to 9 := 0;
   signal uni_in : integer range 0 to 9 := 0;

 	--Outputs
   signal signal_LED : std_logic;
   signal thous : integer range 0 to 9;
   signal hund : integer range 0 to 9;
   signal tens : integer range 0 to 9;
   signal uni : integer range 0 to 9;

   -- Clock period definitions
   constant clk_i_period : time := 0.1 ms;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: control_logic PORT MAP (
          n_code_butt => n_code_butt,
          clk_i => clk_i,
          s_reset => s_reset,
          thous_in => thous_in,
          hund_in => hund_in,
          tens_in => tens_in,
          uni_in => uni_in,
          signal_LED => signal_LED,
          thous => thous,
          hund => hund,
          tens => tens,
          uni => uni
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
		thous_in <= 0;
		hund_in <= 0;
		tens_in <= 1;
		uni_in <= 6;
		n_code_butt <= '1';
		wait for 1 ms;
		n_code_butt <= '0';
		
		wait for 1000 ms;
		
		thous_in <= 1;
		hund_in <= 8;
		tens_in <= 3;
		uni_in <= 7;
		
		wait for 500 ms;
		n_code_butt <= '1';
		wait for 2000 ms;
		n_code_butt <= '0';
		
		wait for 5000 ms;
		s_reset <= '0';
		wait for 1 ms;
		s_reset <= '1';
		wait for 500 ms;
		thous_in <= 0;
		hund_in <= 0;
		tens_in <= 5;
		uni_in <= 2;
		n_code_butt <= '1';
		wait for 1 ms;
		n_code_butt <= '0';
      wait;
		
   end process;

END;
