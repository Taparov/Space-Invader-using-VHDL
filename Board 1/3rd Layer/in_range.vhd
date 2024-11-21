----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:50:27 11/05/2024 
-- Design Name: 
-- Module Name:    in_range - Behavioral 
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

entity in_range is
    Port ( player_pos : in  STD_LOGIC_VECTOR (8 downto 0);
           alien_pos : in  STD_LOGIC_VECTOR (8 downto 0);
           Q : out  STD_LOGIC);
end in_range;

architecture Behavioral of in_range is

	signal alien_sight : unsigned(8 downto 0);

begin
	
	alien_sight <= unsigned(alien_pos) + to_unsigned(15,9);
	
	Q <= '1' when alien_sight >= unsigned(player_pos) and 
					  alien_sight < (unsigned(player_pos) + to_unsigned(32,9)) else '0';

end Behavioral;

