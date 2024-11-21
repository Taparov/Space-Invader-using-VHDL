----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:59:49 11/04/2024 
-- Design Name: 
-- Module Name:    Alien_Display_Control - Behavioral 
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

entity Alien_Display_Control is
    Port ( --clk : in  STD_LOGIC;
           h_count : in  STD_LOGIC_VECTOR(8 downto 0);
           v_count : in  STD_LOGIC_VECTOR(8 downto 0);
           A1,A2,A3,A4,A5,A6 : in  STD_LOGIC_VECTOR (18 downto 0);
			  active : out STD_LOGIC;
           Sprite_x : out  STD_LOGIC_VECTOR(4 downto 0);
           Sprite_y : out  STD_LOGIC_VECTOR(4 downto 0));
           --Sprite_type : out  STD_LOGIC_VECTOR (1 downto 0));
end Alien_Display_Control;

architecture Behavioral of Alien_Display_Control is
	--constant sprite_t : std_logic_vector(1 downto 0) := "01";
	type pos_arr is array (0 to 5) of std_logic_vector(18 downto 0);
	type sp_pos_arr is array (0 to 5) of std_logic_vector(4 downto 0);

	component In_box is
		Port ( H_count : in  STD_LOGIC_VECTOR(8 downto 0);
           V_count : in  STD_LOGIC_VECTOR(8 downto 0);
			  Sprite_size_x : in natural range 1 to 32;
			  Sprite_size_y : in natural range 1 to 32;
           A : in  STD_LOGIC_VECTOR (17 downto 0);
           Q : out  STD_LOGIC;
			  Sprite_posx : out STD_LOGIC_VECTOR(4 downto 0);
			  Sprite_posy : out STD_LOGIC_VECTOR(4 downto 0));
	end component;
	
	signal a_pos : pos_arr;
	signal in_a : std_logic_vector(5 downto 0);
	signal sp_x,sp_y : sp_pos_arr;
	signal tmp_active : std_logic_vector(5 downto 0);
	--signal sp_x1,sp_x2 : std_logic_vector(4 downto 0);
	--signal sp_y1,sp_y2 : std_logic_vector(4 downto 0);
begin
	a_pos(0) <= A1;
	a_pos(1) <= A2;
	a_pos(2) <= A3;
	a_pos(3) <= A4;
	a_pos(4) <= A5;
	a_pos(5) <= A6;
	
	--cmp_a1 : In_box
		--port map(H_count => h_count, V_count => v_count, Sprite_size_x => 32,
					--Sprite_size_y => 14, Sprite_posx => sp_x1, Sprite_posy => sp_y1,
					--A => A1(18 downto 1), Q => in_a(0));
					
	--cmp_a2 : In_box
		--port map(H_count => h_count, V_count => v_count, Sprite_size_x => 32,
					--Sprite_size_y => 14, Sprite_posx => sp_x2, Sprite_posy => sp_y2,
					--A => A2(18 downto 1), Q => in_a(1));
	in_box_gen : for i in 0 to 5 generate
		cmp : In_box
			port map(H_count => h_count, V_count => v_count, Sprite_size_x => 32,
					Sprite_size_y => 14, Sprite_posx => sp_x(i), Sprite_posy => sp_y(i),
					A => a_pos(i)(18 downto 1), Q => in_a(i));
		
		tmp_active(i) <= in_a(i) and a_pos(i)(0);
	end generate;
					
	--sprite_type <= sprite_t when in_a(0) = '1' or in_a(1) = '1' else "00";
	
	---will change to mux later
	Sprite_x <= sp_x(0) or sp_x(1) or sp_x(2) or sp_x(3) or sp_x(4) or sp_x(5);
	Sprite_y <= sp_y(0) or sp_y(1) or sp_y(2) or sp_y(3) or sp_y(4) or sp_y(5);
	
	active <= '1' when tmp_active /= "000000" else '0';
	
end Behavioral;

