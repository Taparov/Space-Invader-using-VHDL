----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:32:08 11/05/2024 
-- Design Name: 
-- Module Name:    Bullet_Display_Control - Behavioral 
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

entity Bullet_Display_Control is
    Port ( h_count : in  STD_LOGIC_VECTOR (8 downto 0);
           v_count : in  STD_LOGIC_VECTOR (8 downto 0);
           Player_Bullet_pos : in  STD_LOGIC_VECTOR (18 downto 0);
			  A_pos : in  STD_LOGIC_VECTOR (18 downto 0);
           Player_spt_pos : out STD_LOGIC_VECTOR(9 downto 0);
			  A_spt_pos : out STD_LOGIC_VECTOR(9 downto 0);
           p_active : out  STD_LOGIC;
			  a_active : out STD_LOGIC);
end Bullet_Display_Control;

architecture Behavioral of Bullet_Display_Control is
	type spt_pos is array (0 to 2) of std_logic_vector(4 downto 0);
	type strt_pos is array (0 to 2) of std_logic_vector(18 downto 0);

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

	signal inbox,active : std_logic_vector(1 downto 0);
	signal spt_x,spt_y : spt_pos;
	signal Pos_arr : strt_pos;
begin
	Pos_arr(0) <= Player_Bullet_pos;
	Pos_arr(1) <= A_pos;
	
	In_box_gen : for i in 0 to 1 generate
		cmp : In_box
			port map(H_count => h_count,V_count => v_count,Sprite_size_x => 2,
			Sprite_size_y => 5,A => Pos_arr(i)(18 downto 1),Q => inbox(i),
			Sprite_posx => spt_x(i),Sprite_posy => spt_y(i));
			
		active(i) <= inbox(i) and Pos_arr(i)(0);
	end generate;

	--plyr_blt_cmp : In_box
		--port map(H_count => h_count,V_count => v_count,Sprite_size_x => 2,
		--Sprite_size_y => 5,A => Player_Bullet_pos(18 downto 1),Q => inbox(0),
		--Sprite_posx => spt_x(0),Sprite_posy => spt_y(0));
		
	--a1_blt_cmp : In_box
		--port map(H_count => h_count,V_count => v_count,Sprite_size_x => 4,
		--Sprite_size_y => 5,A => A1_pos(18 downto 1),Q => inbox(1),
		--Sprite_posx => spt_x(1),Sprite_posy => spt_y(1));
		
	--a2_blt_cmp : In_box
		--port map(H_count => h_count,V_count => v_count,Sprite_size_x => 47,
		--Sprite_size_y => 5,A => A2_pos(18 downto 1),Q => inbox(2),
		--Sprite_posx => spt_x(2),Sprite_posy => spt_y(2));
	 Player_spt_pos <= spt_x(0) & spt_y(0);
	 p_active <= active(0);
	 A_spt_pos <= spt_x(1) & spt_y(1);
	 a_active <= active(1);
	
end Behavioral;

