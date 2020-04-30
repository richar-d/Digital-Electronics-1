--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:10:33 04/30/2020
-- Design Name:   
-- Module Name:   C:/Users/Marek/Desktop/DE Moje/Seb_Svob/countdwn1/countdwn/top_tb02.vhd
-- Project Name:  countdwn
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: top
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
 
ENTITY top_tb02 IS
END top_tb02;
 
ARCHITECTURE behavior OF top_tb02 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT top
    PORT(
         pinA_i : IN  std_logic;
         pinB_i : IN  std_logic;
         butt_i : IN  std_logic;
         clk_i : IN  std_logic;
         s_reset_i : IN  std_logic;
         sclk_o : OUT  std_logic;
         dio_o : OUT  std_logic;
         LED_o : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal pinA_i : std_logic := '0';
   signal pinB_i : std_logic := '0';
   signal butt_i : std_logic := '0';
   signal clk_i : std_logic := '0';
   signal s_reset_i : std_logic := '0';
	signal firstTime : boolean := true;

 	--Outputs
   signal sclk_o : std_logic;
   signal dio_o : std_logic;
   signal LED_o : std_logic;

   -- Clock period definitions
   constant clk_i_period : time := 0.1 ms;
	constant pinA_i_period : time := 1 ms;
	constant pinB_i_period : time := 1 ms;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: top PORT MAP (
          pinA_i => pinA_i,
          pinB_i => pinB_i,
          butt_i => butt_i,
          clk_i => clk_i,
          s_reset_i => s_reset_i,
          sclk_o => sclk_o,
          dio_o => dio_o,
          LED_o => LED_o
        );

   -- Clock process definitions
   clk_i_process :process
   begin
		clk_i <= '0';
		wait for clk_i_period/2;
		clk_i <= '1';
		wait for clk_i_period/2;
   end process;
	
		   pinA_process :process
   begin
	-- make signal 1/4 of period late
		if firstTime then  
			firstTime <= false;
			wait for pinA_i_period/4;
		end if;
		
		pinA_i <= '0';
		wait for pinA_i_period/2;
		pinA_i <= '1';
		wait for pinA_i_period/2;
   end process;
 
  pinB_process :process
   begin
	    
	  --make signal 1/4 of period late
		 --if firstTime then  
		 --	firstTime <= false;
		--	wait for pinB_i_period/4;			
	--	end if;
		
		pinB_i <= '0';
		wait for pinB_i_period/2;
		pinB_i <= '1';
		wait for pinB_i_period/2;
   end process;

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		s_reset_i <= '1';
		butt_i <= '0';

      -- insert stimulus here 

      wait;
   end process;

END;
