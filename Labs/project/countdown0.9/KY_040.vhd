library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity KY_040 is
port(
	clk_i:in std_logic;
	CLK:in std_logic;				 -- pin A
	DT :in std_logic; 			 -- pin B
	SW :in std_logic; 			 -- switch, pressing it starts the countdown
--data sent to TM1637:
	thous_n : out integer range 0 to 9 := 0; -- first digit
	hund_n : out integer range 0 to 9 := 0;  -- second digit
	tens_n : out integer range 0 to 9 := 0;  -- third digit
	uni_n : out integer range 0 to 9 := 0;   -- fourth digit

	start_countdown : out std_logic
);
end KY_040;

architecture Behavioral of KY_040 is
	signal slow_clock:std_logic:='0';
	signal slow_clock_counter:integer:=0;
	constant LIMIT:integer:=10; -- needs tuning while using a real circuit, LIMIT=1 would use every rising edge of clk_i	
	signal prev_A:std_logic;

   signal s_cnt0 : integer range 0 to 9; -- internal signal for the 4th digit
   signal s_cnt1 : integer range 0 to 9; -- internal signal for the 3rd digit
   signal s_cnt2 : integer range 0 to 9; -- internal signal for the 2nd digit
   signal s_cnt3 : integer range 0 to 9; -- internal signal for the 1st digit	
begin

--since our clk_i is fast, it's possible we run into switch bounce issues, so we use a slower clock instead
	process(clk_i)begin
		if rising_edge(clk_i)then  
			if slow_clock_counter=LIMIT then			--  when we reach the LIMIT,
				slow_clock_counter <= 0;				--  logic value of slow_clock changes 
				slow_clock		<= not slow_clock; 	--  and the slow_clock process is executed
			else
				slow_clock_counter <= slow_clock_counter + 1;
			end if;
		end if;
	end process;
	
-- using a lower frequency clock, so that any change on the encoder has the time to get stable
	process(slow_clock)begin 
	
		if rising_edge(slow_clock) then
			prev_A <= CLK;							 -- save CLK (pin A) value to prev_A		
			if prev_A/= CLK then 				 -- knob is rotating when CLK and prev_A are not equal
		-- code for adding and subtracting depending on the encoder rotation:
				if DT /= prev_A then			    -- CLK changed before DT, clockwise rotation
					s_cnt0 <= s_cnt0 + 1;              
						if s_cnt0 = 9 then
							s_cnt0 <= 0;
							s_cnt1 <= s_cnt1 + 1;                  
							if s_cnt1 = 9 then
									s_cnt1 <= 0;
									s_cnt2 <= s_cnt2 + 1;                     
                        if s_cnt2 = 9 then
                            s_cnt2 <= 0;
                            s_cnt3 <= s_cnt3 + 1;                           
                            if s_cnt3 = 9 then
                                s_cnt3 <= 0;
                            end if;
                        end if;
                    end if;
                end if;
				else					 -- DT changed before CLK, counterclockwise rotation
						s_cnt0 <= s_cnt0 - 1;              
						if s_cnt0 = 0 then
							s_cnt0 <= 9;
							s_cnt1 <= s_cnt1 - 1;
                   
							if s_cnt1 = 0 then
									s_cnt1 <= 9;
									s_cnt2 <= s_cnt2 - 1;
                       
                        if s_cnt2 = 0 then
                            s_cnt2 <= 9;
                            s_cnt3 <= s_cnt3 - 1;
                           
                            if s_cnt3 = 0 then
                                s_cnt3 <= 9;
                            end if;
                        end if;
                    end if;
                end if; 
				end if;
			end if;
			
			if SW = '1' then						 -- if button is pressed, start the countdown
				start_countdown <= '1';	
			else
				start_countdown <= '0';
			end if;		
		end if;
		
	-- save internal signals to coresponding ports
		thous_n <= s_cnt3;
		hund_n <= s_cnt2;
		tens_n <= s_cnt1;
		uni_n <= s_cnt0;
		
	end process;

end Behavioral;