--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:28:54 04/29/2020
-- Design Name:   
-- Module Name:   C:/Users/Marek/Desktop/Seb_Svob/countdwn/TM1637_tb.vhd
-- Project Name:  countdwn
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: TM1637
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

ENTITY TM1637_tb IS
END TM1637_tb;
 
ARCHITECTURE behavior OF TM1637_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT TM1637
    PORT(
         clk_i : IN  std_logic;
         thous : IN  integer range 0 to 9;
         hund : IN  integer range 0 to 9;
         tens : IN  integer range 0 to 9;
         uni : IN  integer range 0 to 9;
         sclk : OUT  std_logic;
         dio : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk_i : std_logic := '0';
   signal thous : integer range 0 to 9 := 0;
   signal hund : integer range 0 to 9 := 0;
   signal tens : integer range 0 to 9 := 0;
   signal uni : integer range 0 to 9 := 0;

 	--Outputs
   signal sclk : std_logic;
   signal dio : std_logic;

   -- Clock period definitions
   constant clk_i_period : time := 0.1 ms;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: TM1637 PORT MAP (
          clk_i => clk_i,
          thous => thous,
          hund => hund,
          tens => tens,
          uni => uni,
          sclk => sclk,
          dio => dio
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

		thous <= 5;
		hund <= 1;
		tens <= 9;
		uni <= 6;
		
		wait for 3 ms;
		thous <= 2;
		hund <= 8;
		tens <= 0;
		uni <= 3;

		-- in simulation is case of changing values: displey change value only on start new writing cycle (anti-wrong visualization of value)

      wait;
   end process;

END;
