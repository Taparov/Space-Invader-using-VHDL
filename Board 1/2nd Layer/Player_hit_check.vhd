----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    03:08:19 11/09/2024 
-- Design Name: 
-- Module Name:    Player_hit_check - Behavioral 
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

entity Player_hit_check is
    Port ( Alien_bullet_pos : in  STD_LOGIC_VECTOR(18 downto 0);
           Player_posx : in  STD_LOGIC_VECTOR(8 downto 0);
			  game_over : in  STD_LOGIC;
           hit : out  STD_LOGIC);
end Player_hit_check;

architecture Behavioral of Player_hit_check is
	type pos_arr is array (0 to 5) of std_logic_vector(17 downto 0);

	component Area_Overlap is
			Port ( Bullet_pos : in  STD_LOGIC_VECTOR (17 downto 0);
				  Bullet_size_x : in  NATURAL;
				  Bullet_size_y : in  NATURAL;
				  Target_pos : in  STD_LOGIC_VECTOR (17 downto 0);
				  Target_size_x : in  NATURAL;
				  Target_size_y : in  NATURAL;
				  Q : out  STD_LOGIC);
	end component;
	
	signal alien_pos : pos_arr;
	signal alien_active : std_logic;
	signal ovlp,hit_tmp : std_logic;
	signal player_pos : std_logic_vector(17 downto 0);
	
begin
	
	player_pos <= Player_posx & std_logic_vector(to_unsigned(450,9));
	overlap : Area_Overlap
		port map(Bullet_pos => Alien_bullet_pos(18 downto 1),Bullet_size_x => 2,
			Bullet_size_y => 5,Target_pos => player_pos,Target_size_x => 32,
			Target_size_y => 22,Q => ovlp);
			
		hit <= ovlp and not(game_over) and Alien_bullet_pos(0);

end Behavioral;

