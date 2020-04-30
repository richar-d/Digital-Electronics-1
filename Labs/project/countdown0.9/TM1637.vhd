----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:33:23 04/04/2020 
-- Design Name: 
-- Module Name:    TM1637 - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity TM1637 is
port (
   clk_i : in  std_logic; 
	thous : in integer range 0 to 9;
	hund : in integer range 0 to 9;
	tens : in integer range 0 to 9;
	uni : in integer range 0 to 9;
	
	
	sclk : out std_logic := '0';
	dio : out std_logic := '0'
);
end TM1637;

architecture Behavioral of TM1637 is
	
	signal help_cnt : integer := 0000;
	signal digit0 : std_logic_vector(7 downto 0) := "00000000";
	signal digit1 : std_logic_vector(7 downto 0) := "00000000";
	signal digit2 : std_logic_vector(7 downto 0) := "00000000";
	signal digit3 : std_logic_vector(7 downto 0) := "00000000";
	
	constant data_command : std_logic_vector(7 downto 0) := "01000000"; -- write data to register
	
			--  B7    B6    B5    B4    B3    B2    B1    B0
			--   0     1     0     0                 0     0   >> write data to register
			--   0     1     0     0                 1     0   >> read key-scan data
			--   0     1     0     0           0               >> auto adress increment
			--   0     1     0     0           1               >> fixed adress
			--   0     1     0     0     0                     >> normal mode
			--   0     1     0     0     1                     >> test mode
			
	constant address_command : std_logic_vector(7 downto 0) := "11000000";  -- setting address of first digit to write
	
			--  B7    B6    B5    B4    B3    B2    B1    B0
			--   1     1     0     0     0     0     0     0   >> 0xC0  -- 1. digit od leva
			--   1     1     0     0     0     0     0     1   >> 0xC1  -- 2. digit od leva
			--   1     1     0     0     0     0     1     0   >> 0xC2  -- 3. digit od leva
			--   1     1     0     0     0     0     1     1   >> 0xC3  -- 4. digit od leva
			--   1     1     0     0     0     1     0     0   >> 0xC4  -- 5. digit od leva
			--   1     1     0     0     0     1     0     1   >> 0xC5  -- 6. digit od leva
			
			-- We have only three digits display so address 0xC3 to 0xC5 can`t be used.
	
	constant display_control : std_logic_vector(7 downto 0) := -- "10000000";  -- display OFF
																				-- "10001000";  -- pulse width 1/16
																				-- "10001001";  -- pulse width 2/16
																				-- "10001010";  -- pulse width 4/16 
																				-- "10001011";  -- pulse width 10/16
																				-- "10001100";  -- pulse width 11/16
																				-- "10001101";  -- pulse width 12/16
																				-- "10001110";  -- pulse width 13/16
																				 "10001111";  -- pulse width 14/16

	function digTo7seg(digit : integer) return std_logic_vector is -- function for coding value of digit to 7-segment code
		variable seg7 : std_logic_vector(8-1 downto 0);
	begin
		case digit is 
 
			when 0 => seg7 :=  "00111111";    -- 0
			when 1 => seg7 :=  "00000110";    -- 1
			when 2 => seg7 :=  "01011011";    -- 2
			when 3 => seg7 :=  "01001111";    -- 3
			when 4 => seg7 :=  "01100110";    -- 4
			when 5 => seg7 :=  "01101101";    -- 5
			when 6 => seg7 :=  "01111101";    -- 6
			when 7 => seg7 :=  "00000111";    -- 7
			when 8 => seg7 :=  "01111111";    -- 8
			when 9 => seg7 :=  "01101111";    -- 9
			--when "1010"=> seg7 :=  "01110111";    -- A
			--when "1011"=> seg7 :=  "01111100";    -- b
			--when "1100"=> seg7 :=  "00111001";    -- C
			--when "1101"=> seg7 :=  "01011110";    -- d
			--when "1110"=> seg7 :=  "01111001";    -- E
			--when "1111"=> seg7 :=  "01110001";    -- F
			when others=> seg7 :=  "00111111";    -- 0:
		end case;						          
		return seg7;
		
	end function;

begin

	transform : process (clk_i, thous, hund, tens, uni) -- proces transformation digit value to 7-segment code
	begin 
	
		if help_cnt = 0 then  -- the conversion will only be performed at the beginning of the write cycle
									 -- prevent the display from showing incorrect numbers when changing the value of the n-encoder
									 -- writing cycle delay is about 15ms; for fast, raise clock frequenci
		
			digit0 <= digTo7seg(uni);  
			digit1 <= digTo7seg(tens);  
			digit2 <= digTo7seg(hund);  
			digit3 <= digTo7seg(thous);  
			
		end if;
		
	end process transform;
	
	data_sending : process (clk_i, digit0, digit1, digit2, digit3, help_cnt)
	begin
		if rising_edge(clk_i) then 
			help_cnt <= help_cnt + 1;
				case help_cnt is
					when 0 => sclk <= '1'; dio <= '1';  -- preparing START condition, both to H
					when 1 => sclk <= '1'; dio <= '0';  -- START condition, clock HIGH, data fallingEdge
					when 2 => sclk <= '0'; dio <= data_command(0);  -- device command nuber one: set proces Writing to device; sending LSB to device
					when 3 => sclk <= '1'; 
					when 4 => sclk <= '0'; dio <= data_command(1);
					when 5 => sclk <= '1'; 
					when 6 => sclk <= '0'; dio <= data_command(2);
					when 7 => sclk <= '1'; 
					when 8 => sclk <= '0'; dio <= data_command(3);
					when 9 => sclk <= '1'; 
					when 10 => sclk <= '0'; dio <= data_command(4);
					when 11 => sclk <= '1'; 
					when 12 => sclk <= '0'; dio <= data_command(5);
					when 13 => sclk <= '1'; 
					when 14 => sclk <= '0'; dio <= data_command(6);
					when 15 => sclk <= '1'; 
					when 16 => sclk <= '0'; dio <= data_command(7);  -- sending MSB to device >> end of first command
					when 17 => sclk <= '1'; 
					when 18 => sclk <= '0'; dio <= 'Z';  -- set output to high impedance; device sending ACK bit (we are don't read it)
					when 19 => sclk <= '1'; 
					when 20 => sclk <= '0'; dio <= '0';
					when 21 => sclk <= '1';  
					when 22 => sclk <= '1'; dio <= '1'; -- STOP bit, clock HIGH, data ridingEdge
					when 23 => sclk <= '1'; dio <= '0'; -- next START bit for second condition
 					when 24 => sclk <= '0'; dio <= address_command(0);  -- LSB of second command which is beginig digit position on display, we are starting from firs from left
					when 25 => sclk <= '1'; 
					when 26 => sclk <= '0'; dio <= address_command(1);
					when 27 => sclk <= '1'; 
					when 28 => sclk <= '0'; dio <= address_command(2);
					when 29 => sclk <= '1'; 
					when 30 => sclk <= '0'; dio <= address_command(3);
					when 31 => sclk <= '1'; 
					when 32 => sclk <= '0'; dio <= address_command(4);
					when 33 => sclk <= '1'; 
					when 34 => sclk <= '0'; dio <= address_command(5);
					when 35 => sclk <= '1'; 
					when 36 => sclk <= '0'; dio <= address_command(6);
					when 37 => sclk <= '1'; 
					when 38 => sclk <= '0'; dio <= address_command(7);  -- sending MSB to device >> end of second command
					when 39 => sclk <= '1'; 
					when 40 => sclk <= '0'; dio <= 'Z';  -- set output to high impedance; device sending ACK bit (we are don't read it)
					when 41 => sclk <= '1'; 
					when 42 => sclk <= '0'; dio <= digit3(0);  -- sending LSB from 7-segment code of first digit
					when 43 => sclk <= '1';
					when 44 => sclk <= '0'; dio <= digit3(1);
					when 45 => sclk <= '1';
					when 46 => sclk <= '0'; dio <= digit3(2);
					when 47 => sclk <= '1';
					when 48 => sclk <= '0'; dio <= digit3(3);
					when 49 => sclk <= '1';
					when 50 => sclk <= '0'; dio <= digit3(4);
					when 51 => sclk <= '1';
					when 52 => sclk <= '0'; dio <= digit3(5);
					when 53 => sclk <= '1';
					when 54 => sclk <= '0'; dio <= digit3(6);
					when 55 => sclk <= '1';
					when 56 => sclk <= '0'; dio <= digit3(7);  -- sending MSB from 7-segment code of first digit
					when 57 => sclk <= '1';
					when 58 => sclk <= '0'; dio <= 'Z';  -- set output to high impedance; device sending ACK bit (we are don't read it)
					when 59 => sclk <= '1'; 
					when 60 => sclk <= '0'; dio <= digit2(0);  -- sending LSB from 7-segment code of second digit
					when 61 => sclk <= '1'; 
					when 62 => sclk <= '0'; dio <= digit2(1);
					when 63 => sclk <= '1'; 
					when 64 => sclk <= '0'; dio <= digit2(2);
					when 65 => sclk <= '1';
					when 66 => sclk <= '0'; dio <= digit2(3);
					when 67 => sclk <= '1'; 
					when 68 => sclk <= '0'; dio <= digit2(4);
					when 69 => sclk <= '1'; 
					when 70 => sclk <= '0'; dio <= digit2(5);
					when 71 => sclk <= '1'; 
					when 72 => sclk <= '0'; dio <= digit2(6);
					when 73 => sclk <= '1'; 
					when 74 => sclk <= '0'; dio <= digit2(7);  -- sending MSB from 7-segment code of second digit
					when 75 => sclk <= '1';
					when 76 => sclk <= '0'; dio <= 'Z';  -- set output to high impedance; device sending ACK bit (we are don't read it)
					when 77 => sclk <= '1'; 
					when 78 => sclk <= '0'; dio <= digit1(0);  -- sending MSB from 7-segment code of third digit
					when 79 => sclk <= '1'; 
					when 80 => sclk <= '0'; dio <= digit1(1);
					when 81 => sclk <= '1';
					when 82 => sclk <= '0'; dio <= digit1(2);
					when 83 => sclk <= '1'; 
					when 84 => sclk <= '0'; dio <= digit1(3);
					when 85 => sclk <= '1'; 
					when 86 => sclk <= '0'; dio <= digit1(4);
					when 87 => sclk <= '1'; 
					when 88 => sclk <= '0'; dio <= digit1(5);
					when 89 => sclk <= '1';
					when 90 => sclk <= '0'; dio <= digit1(6);
					when 91 => sclk <= '1'; 
					when 92 => sclk <= '0'; dio <= digit1(7);  -- sending MSB from 7-segment code of third digit
					when 93 => sclk <= '1'; 
					when 94 => sclk <= '0'; dio <= 'Z';  -- set output to high impedance; device sending ACK bit (we are don't read it)
					when 95 => sclk <= '1';
					when 96 => sclk <= '0'; dio <= digit0(0);  -- sending MSB from 7-segment code of fourth digit
					when 97 => sclk <= '1'; 
					when 98 => sclk <= '0'; dio <= digit0(1);
					when 99 => sclk <= '1'; 
					when 100 => sclk <= '0'; dio <= digit0(2);
					when 101 => sclk <= '1'; 
					when 102 => sclk <= '0'; dio <= digit0(3);
					when 103 => sclk <= '1';
					when 104 => sclk <= '0'; dio <= digit0(4);
					when 105 => sclk <= '1'; 
					when 106 => sclk <= '0'; dio <= digit0(5);
					when 107 => sclk <= '1'; 
					when 108 => sclk <= '0'; dio <= digit0(6);
					when 109 => sclk <= '1'; 
					when 110 => sclk <= '0'; dio <= digit0(7);  -- sending MSB from 7-segment code of fourth digit
					when 111 => sclk <= '1'; 
					when 112 => sclk <= '0'; dio <= 'Z';  -- set output to high impedance; device sending ACK bit (we are don't read it)
					when 113 => sclk <= '1';
					when 114 => sclk <= '0'; dio <= '0';
					when 115 => sclk <= '1';
					when 116 =>             dio <= '1';  -- STOP bit
					when 117 =>             dio <= '0';  -- START bit for third command
					when 118 => sclk <= '0'; dio <= display_control(0);
					when 119 => sclk <= '1'; 
					when 120 => sclk <= '0'; dio <= display_control(1);
					when 121 => sclk <= '1'; 
					when 122 => sclk <= '0'; dio <= display_control(2);
					when 123 => sclk <= '1'; 
					when 124 => sclk <= '0'; dio <= display_control(3);
					when 125 => sclk <= '1'; 
					when 126 => sclk <= '0'; dio <= display_control(4);
					when 127 => sclk <= '1'; 
					when 128 => sclk <= '0';	dio <= display_control(5);
					when 129 => sclk <= '1'; 
					when 130 => sclk <= '0'; dio <= display_control(6);
					when 131 => sclk <= '1'; 
					when 132 => sclk <= '0'; dio <= display_control(7);  -- sending MSB to device >> end of third command
					when 133 => sclk <= '1'; 
					when 134 => sclk <= '0'; dio <= 'Z';  -- set output to high impedance; device sending ACK bit (we are don't read it)
					when 135 => sclk <= '1'; 
					when 136 => sclk <= '0'; dio <= '0';
					when 137 => sclk <= '1';
	            -- end of comunication		cca 14ms		
					when others => help_cnt <= 0;
				end case;
			end if;
	end process data_sending;
	
end Behavioral;

