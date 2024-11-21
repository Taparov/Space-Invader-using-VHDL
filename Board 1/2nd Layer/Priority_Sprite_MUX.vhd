----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:05:44 11/05/2024 
-- Design Name: 
-- Module Name:    Priority_Sprite_MUX - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Priority_Sprite_MUX is
    Port ( Player_active : in  STD_LOGIC;
           Alien_active : in  STD_LOGIC;
			  Bullet_active : in STD_LOGIC;
			  Alien_bullet_active : in STD_LOGIC;
			  --Txt_active : in STD_LOGIC;
			  Num_active : in STD_LOGIC;
           Player_Sprite_pos : in  STD_LOGIC_VECTOR (9 downto 0);
           Alien_Sprite_pos : in  STD_LOGIC_VECTOR (9 downto 0);
			  Bullet_Sprite_pos : in  STD_LOGIC_VECTOR (9 downto 0);
			  AB_Sprite_pos : in  STD_LOGIC_VECTOR (9 downto 0);
			  --Txt_Sprite_pos : in  STD_LOGIC_VECTOR (9 downto 0);
			  Num_Sprite_pos : in  STD_LOGIC_VECTOR (9 downto 0);
			  Num_Sprite_type : in std_logic_vector(4 downto 0);
			  Sprite_type : out std_logic_vector(4 downto 0);
			  Sprite_x : out STD_LOGIC_VECTOR(4 downto 0);
			  Sprite_y : out STD_LOGIC_VECTOR(4 downto 0));
end Priority_Sprite_MUX;

architecture Behavioral of Priority_Sprite_MUX is

	constant sprite_player : std_logic_vector(4 downto 0) := "01010";
	constant sprite_alien : std_logic_vector(4 downto 0) := "01011";
	constant sprite_bullet : std_logic_vector(4 downto 0) := "01100";

begin
	
	Sprite_x <= Num_Sprite_pos(9 downto 5) when Num_active = '1' else
					Player_Sprite_pos(9 downto 5) when Player_active = '1' else
					Alien_Sprite_pos(9 downto 5) when Alien_active = '1' else
					Bullet_Sprite_pos(9 downto 5) when Bullet_active = '1' else
					AB_Sprite_pos(9 downto 5) when Alien_bullet_active = '1' else
					(others => '0');
					
	Sprite_y <= Num_Sprite_pos(4 downto 0) when Num_active = '1' else
					Player_Sprite_pos(4 downto 0) when Player_active = '1' else
					Alien_Sprite_pos(4 downto 0) when Alien_active = '1' else
					Bullet_Sprite_pos(4 downto 0) when Bullet_active = '1' else
					AB_Sprite_pos(4 downto 0) when Alien_bullet_active = '1' else
					(others => '0');
					
	Sprite_type <= Num_Sprite_type when Num_active = '1' else
						sprite_player when player_active = '1' else
						sprite_alien when alien_active = '1' else
						sprite_bullet when Bullet_active = '1' or Alien_bullet_active = '1' else
						(others => '1');

end Behavioral;

