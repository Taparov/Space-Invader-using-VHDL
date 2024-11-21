----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:16:00 11/04/2024 
-- Design Name: 
-- Module Name:    Player - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Player is
    Port ( clk : in  STD_LOGIC;
           clk_mv : in  STD_LOGIC;
           btn_left : in  STD_LOGIC;
           btn_right : in  STD_LOGIC;
			  --reset : in STD_LOGIC;
           player_pos : out  STD_LOGIC_VECTOR(17 downto 0));
end Player;

architecture Behavioral of Player is
	constant start_x : natural := 0;
	
	
	signal pos : natural range 0 to 466 := 0 ;
begin
	movement : process(clk,clk_mv,btn_left,btn_right)
	begin
		if rising_edge(clk) then
			--if reset = '1' then
				--pos <= start_x;
			if rising_edge(clk_mv) then
				if btn_left = '1' then
					if pos /= 0 then
					pos <= pos - 1;
					end if;
				elsif btn_right = '1' then
					if pos /= 466 then
						pos <= pos + 1;
					end if;
				end if;
			end if;
		end if;
	end process;
	
	player_pos <= std_logic_vector(to_unsigned(pos,9)) & std_logic_vector(to_unsigned(450,9));

end Behavioral;

