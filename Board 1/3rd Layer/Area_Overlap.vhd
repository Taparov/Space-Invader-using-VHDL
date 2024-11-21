----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:40:45 11/07/2024 
-- Design Name: 
-- Module Name:    Area_Overlap - Behavioral 
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

entity Area_Overlap is
    Port ( Bullet_pos : in  STD_LOGIC_VECTOR (17 downto 0);
           Bullet_size_x : in  NATURAL;
           Bullet_size_y : in  NATURAL;
           Target_pos : in  STD_LOGIC_VECTOR (17 downto 0);
           Target_size_x : in  NATURAL;
           Target_size_y : in  NATURAL;
           Q : out  STD_LOGIC);
end Area_Overlap;

architecture Behavioral of Area_Overlap is

	signal blt_posx,blt_posy,tgt_posx,tgt_posy : natural range 0 to 466;
	signal ovl_x,ovl_y : std_logic;
	
begin
	blt_posx <= to_integer(unsigned(Bullet_pos(17 downto 9)));
	blt_posy <= to_integer(unsigned(Bullet_pos(8 downto 0)));
	tgt_posx <= to_integer(unsigned(Target_pos(17 downto 9)));
	tgt_posy <= to_integer(unsigned(Target_pos(8 downto 0)));
	
	ovl_x <= '1' when (blt_posx >= tgt_posx and blt_posx < tgt_posx + Target_size_x) or
				(blt_posx + Bullet_size_x >= tgt_posx and blt_posx + Bullet_size_x < tgt_posx + Target_size_x) else '0';
	ovl_y <= '1' when (blt_posy >= tgt_posy and blt_posy < tgt_posy + Target_size_y) or
				(blt_posy + Bullet_size_y >= tgt_posy and blt_posy + Bullet_size_y < tgt_posy + Target_size_y) else '0';
				
	Q <= ovl_x and ovl_y;

end Behavioral;

