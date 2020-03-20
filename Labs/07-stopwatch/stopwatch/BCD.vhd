----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:19:10 03/20/2020 
-- Design Name: 
-- Module Name:    BCD - Behavioral 
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
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity BCD is

	port(
	 clk_i          : in  std_logic;
    srst_n_i       : in  std_logic; -- Synchronous reset (active low)
	 s_en : in std_logic;
	 cnt_en_i : in std_logic;
	 cnt_en : in std_logic;
	 erase_en : in std_logic;
    cnt_o : out unsigned(4-1 downto 0) := (others => '0')
	);

end BCD;

architecture Behavioral of BCD is

	signal s_cntBCD : std_logic_vector(4-1 downto 0) := "0000";
		
begin

    p_select_cnt0 : process (clk_i, s_cntBCD)
    begin
			if rising_edge(clk_i) then  -- Rising clock edge
            if ((srst_n_i = '0') or (s_cntBCD = "1001" and s_en = '1' and erase_en = '1')) then  
                s_cntBCD <= (others => '0');   
            elsif (s_en = '1' and cnt_en_i = '1' and cnt_en = '1') then
                s_cntBCD <= s_cntBCD + 1; 
            end if;
         end if;
			cnt_o <= unsigned(s_cntBCD);
    end process p_select_cnt0;

end Behavioral;


-- èítaè má vstupy pro povolení èítání (pozastavovací tlaèítko), resetovací vstup, vstup hodin
-- pomocné vstupy jsou k povolení vynulování a k povolení inkrementace pøi použití ve více dekádách: cnt_en, erase_en
