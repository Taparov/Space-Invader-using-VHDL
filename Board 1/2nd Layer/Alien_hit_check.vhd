----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    07:56:11 11/08/2024 
-- Design Name: 
-- Module Name:    Alien_hit_check - Behavioral 
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

entity Alien_hit_check is
    Port ( Player_Bullet_pos : in  STD_LOGIC_VECTOR (18 downto 0);
           A1_x_stat : in  STD_LOGIC_VECTOR (9 downto 0);
           A2_x_stat : in  STD_LOGIC_VECTOR (9 downto 0);
			  A3_x_stat : in  STD_LOGIC_VECTOR (9 downto 0);
			  A456_stat : in  STD_LOGIC_VECTOR (2 downto 0);
           A_y1 : in  STD_LOGIC_VECTOR (8 downto 0);
			  A_y2 : in  STD_LOGIC_VECTOR (8 downto 0);
           hit : out  STD_LOGIC_VECTOR (5 downto 0);
			  bullet_deac : out STD_LOGIC);
end Alien_hit_check;

architecture Behavioral of Alien_hit_check is
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
	signal alien_active : std_logic_vector(5 downto 0);
	signal ovlp,hit_tmp : std_logic_vector(5 downto 0);
begin
	alien_pos(0) <= A1_x_stat(9 downto 1) & A_y1;
	alien_pos(1) <= A2_x_stat(9 downto 1) & A_y1;
	alien_pos(2) <= A3_x_stat(9 downto 1) & A_y1;
	alien_pos(3) <= A1_x_stat(9 downto 1) & A_y2;
	alien_pos(4) <= A2_x_stat(9 downto 1) & A_y2;
	alien_pos(5) <= A3_x_stat(9 downto 1) & A_y2;
	
	alien_active(0) <= A1_x_stat(0);
	alien_active(1) <= A2_x_stat(0);
	alien_active(2) <= A3_x_stat(0);
	alien_active(3) <= A456_stat(0);
	alien_active(4) <= A456_stat(1);
	alien_active(5) <= A456_stat(2);
	
	ovarlap_gen : for i in 0 to 5 generate
		ovarlap : Area_Overlap
			port map(Bullet_pos => Player_Bullet_pos(18 downto 1),Bullet_size_x => 2,
			Bullet_size_y => 5,Target_pos => alien_pos(i),Target_size_x => 32,
			Target_size_y => 14,Q => ovlp(i));
			
		hit_tmp(i) <= ovlp(i) and alien_active(i) and Player_Bullet_pos(0);
	end generate;
	
	hit <= hit_tmp;
	bullet_deac <= hit_tmp(0) or hit_tmp(1) or hit_tmp(2) or hit_tmp(3) or hit_tmp(4) or hit_tmp(5);
	
end Behavioral;

