----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:02:35 11/04/2024 
-- Design Name: 
-- Module Name:    In_box - Behavioral 
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

entity In_box is
    Port ( H_count : in  STD_LOGIC_VECTOR(8 downto 0);
           V_count : in  STD_LOGIC_VECTOR(8 downto 0);
			  Sprite_size_x : in natural range 1 to 32;
			  Sprite_size_y : in natural range 1 to 32;
           A : in  STD_LOGIC_VECTOR (17 downto 0);
           Q : out  STD_LOGIC;
			  Sprite_posx : out STD_LOGIC_VECTOR(4 downto 0);
			  Sprite_posy : out STD_LOGIC_VECTOR(4 downto 0));
end In_box;

architecture Behavioral of In_box is
	signal Box_start_x,Box_end_x,tmp_result_x : unsigned(8 downto 0);
	signal Box_start_y,Box_end_y,tmp_result_y : unsigned(8 downto 0);
	signal in_h : std_logic;
	signal in_v : std_logic;
	signal Q_tmp : std_logic;
begin
	Box_start_x <= unsigned(A(17 downto 9));
	Box_start_y <= unsigned(A(8 downto 0));
	Box_end_x <= unsigned(Box_start_x) + to_unsigned(Sprite_size_x,9);
	Box_end_y <= unsigned(Box_start_y) + to_unsigned(Sprite_size_y,9);
	
	in_h <= '1' when unsigned(H_count) >= Box_start_x and unsigned(H_count) < Box_end_x else '0';
	in_v <= '1' when unsigned(V_count) >= Box_start_y and unsigned(V_count) < Box_end_y else '0';
	
	tmp_result_x <= unsigned(H_count)-Box_start_x;
	tmp_result_y <= unsigned(V_count)-Box_start_y;
	
	Sprite_posx <= std_logic_vector(tmp_result_x(4 downto 0)) when Q_tmp = '1' else (others => '0');
	Sprite_posy <= std_logic_vector(tmp_result_y(4 downto 0)) when Q_tmp = '1' else (others => '0');
	Q_tmp <= in_h and in_v;
	Q <= Q_tmp;

end Behavioral;

