library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- datasheet for KY-040:
-- http://henrysbench.capnfatz.com/henrys-bench/arduino-sensors-and-input/keyes-ky-040-arduino-rotary-encoder-user-manual/
entity KY_040 is
port(
	clk_i:in std_logic;
	CLK:in std_logic;				 -- pin A
	DT :in std_logic; 			 -- pin B
	SW :in std_logic; 			 -- switch, pressing it starts the countdown
	s_reset : in std_logic;
-- data sent to TM1637:

	thous : out std_logic_vector (3 downto 0); -- first digit
	hund : out std_logic_vector (3 downto 0);  -- second digit
	tens : out std_logic_vector (3 downto 0);  -- third digit
	uni : out std_logic_vector (3 downto 0);   -- fourth digit
	signal_LED : out std_logic
);
end KY_040;

architecture Behavioral of KY_040 is
	signal slow_clock:std_logic:='0';
	signal slow_clock_counter:integer:=0;
	constant LIMIT:integer:=1; -- needs tuning while using a real circuit, LIMIT=1 would use every rising edge of clk_i	
	signal prev_A:std_logic;
	
   signal s_cnt0 : unsigned (3 downto 0) := (others => '0'); -- internal signal for the 4th digit
   signal s_cnt1 : unsigned (3 downto 0) := (others => '0'); -- internal signal for the 3rd digit
   signal s_cnt2 : unsigned (3 downto 0) := (others => '0'); -- internal signal for the 2nd digit
   signal s_cnt3 : unsigned (3 downto 0) := (others => '0'); -- internal signal for the 1st digit

   signal cnt0 : unsigned (3 downto 0) := (others => '0');
   signal cnt1 : unsigned (3 downto 0) := (others => '0');
   signal cnt2 : unsigned (3 downto 0) := (others => '0');
   signal cnt3 : unsigned (3 downto 0) := (others => '0');
	
	signal clock_en : std_logic;
	signal enable_set_val : std_logic;
begin

	clock_enable : entity work.clock_enable
	port map(
		clk_i => clk_i,
		srst_n_i => s_reset,
		clock_enable_o => clock_en
	);

--since our clk_i is fast, it's possible we run into switch bounce issues, so we use a slower clock instead
	process(clk_i, s_reset, SW, enable_set_val, s_cnt0, s_cnt1, s_cnt2, s_cnt3, clock_en, cnt0, cnt1, cnt2, cnt3)begin
		if rising_edge(clk_i)then  
			if slow_clock_counter=LIMIT then			--  when we reach the LIMIT,
				slow_clock_counter <= 0;				--  logic value of slow_clock changes 
				slow_clock		<= not slow_clock; 	--  and the slow_clock process is executed
			else
				slow_clock_counter <= slow_clock_counter + 1;
			end if;
		end if;
		
		if s_reset = '0' then
			signal_LED <= '1';
			cnt0 <= (others => '0');
			cnt1 <= (others => '0');
			cnt2 <= (others => '0');
			cnt3 <= (others => '0');
			enable_set_val <= '1';
		else	
			if SW = '1' and enable_set_val = '1' then
			
				cnt0 <= s_cnt0;
				cnt1 <= s_cnt1;
				cnt2 <= s_cnt2;
				cnt3 <= s_cnt3;
		
				enable_set_val <= '0';
				signal_LED <= '1';
		
			elsif SW = '0' then
		
				if enable_set_val = '0' and clock_en = '1' then

						cnt0 <= s_cnt0 - 1;
               
						if cnt0 = 0 then
							cnt0 <= "1001";
							cnt1 <= cnt1 - 1;
                   
							if cnt1 = 0 then
									cnt1 <= "1001";
									cnt2 <= cnt2 - 1;
                       
                        if cnt2 = 0 then
                            cnt2 <= "1001";
                            cnt3 <= cnt3 - 1;
                           
                            if cnt3 = 0 then
                                cnt3 <= "1001";
                            end if;
                        end if;
                    end if;
                end if;
					 			
					if cnt0 = 0 and cnt1 = 0 and cnt2 = 0 and cnt3 = 0 and clock_en = '1' then
				
						signal_LED <= '0';
						enable_set_val <= '1';
				
					end if;
					
				else
				
				cnt3 <= s_cnt3;
				cnt2 <= s_cnt2;
				cnt1 <= s_cnt1;
				cnt0 <= s_cnt0;
			
				end if;	
			end if;
		end if;
      			thous <= std_logic_vector(cnt3);
					hund <= std_logic_vector(cnt2);
					tens <= std_logic_vector(cnt1);
					uni <= std_logic_vector(cnt0);
		
	end process;
	
-- using a lower frequency clock, so that any change on the encoder has the time to get stable
	process(slow_clock, s_cnt0, s_cnt1, s_cnt2, s_cnt3, enable_set_val)begin 
		if falling_edge(slow_clock) and enable_set_val = '1' then
			prev_A <= CLK;							 -- save CLK (pin A) value to prev_A		
			if prev_A/= CLK then 				 -- knob is rotating when CLK and prev_A are not equal
-- code for adding and subtracting depending on the encoder rotation
				if DT /= prev_A then			    -- CLK changed before DT, clockwise rotation				
					s_cnt0 <= s_cnt0 + 1; --              
						if s_cnt0 >= 9 then
							s_cnt0 <= (others => '0');
							s_cnt1 <= s_cnt1 + 1;                  
							if s_cnt1 >= 9 then
									s_cnt1 <= (others => '0');
									s_cnt2 <= s_cnt2 + 1;                       
                        if s_cnt2 >= 9 then
                            s_cnt2 <= (others => '0');
                            s_cnt3 <= s_cnt3 + 1;                           
                            if s_cnt3 >= 9 then
                                s_cnt3 <= (others => '0');
                            end if;
                        end if;
                    end if;
                end if;			 
				else				-- DT changed before CLK, counterclockwise rotation					 		
						s_cnt0 <= s_cnt0 - 1;              
						if s_cnt0 <= 0 then
							s_cnt0 <= "1001";
							s_cnt1 <= s_cnt1 - 1;                   
							if s_cnt1 <= 0 then
									s_cnt1 <= "1001";
									s_cnt2 <= s_cnt2 - 1;                       
                        if s_cnt2 <= 0 then
                            s_cnt2 <= "1001";
                            s_cnt3 <= s_cnt3 - 1;                        
                            if s_cnt3 <= 0 then
                                s_cnt3 <= "1001";
                            end if;
                        end if;
                    end if;
                end if; 	
				end if;
			end if;				
		end if;
		
--		      	thous <= std_logic_vector(s_cnt3);
--					hund <= std_logic_vector(s_cnt2);
--					tens <= std_logic_vector(s_cnt1);
--					uni <= std_logic_vector(s_cnt0);
	
	end process;
	
end Behavioral;