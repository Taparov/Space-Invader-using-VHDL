----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    07:22:33 11/04/2024 
-- Design Name: 
-- Module Name:    Game - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Game is
    Port ( clk : in  STD_LOGIC;
           br_j,br_d : in  STD_LOGIC;
           bl_j,bl_d : in  STD_LOGIC;
			  bs_j,bs_d : in  STD_LOGIC;
			  h,v : in std_logic_vector(8 downto 0);
			  s_x,s_y : out std_logic_vector(4 downto 0);
			  s_type : out std_logic_vector(4 downto 0);
			  g_over : out std_logic);
			  --R : out STD_LOGIC;
			  --G : out std_logic;
			  --B : out std_logic;
			  --HSYNC : out std_logic;
			  --VSYNC,led_o : out std_logic);
end Game;

architecture Behavioral of Game is
	type pos_arr is array (natural range <>) of std_logic_vector(18 downto 0);

	--component VGA_Display is
		--Port ( clk : in  STD_LOGIC;
			  --p_l,p_r : in STD_LOGIC;
			  --game_over  :  in STD_LOGIC;
			  --sprite_posx : in STD_LOGIC_VECTOR(4 downto 0);
			  --sprite_posy : in STD_LOGIC_VECTOR(4 downto 0);
			  --sprite_type : in std_logic_vector(4 downto 0);
			  --d_x : out STD_LOGIC_VECTOR(8 downto 0);
			  --d_y : out STD_LOGIC_VECTOR(8 downto 0);
			  --R : out STD_LOGIC;
			  --G : out std_logic;
			  --B : out std_logic;
			  --HSYNC : out std_logic;
			  --VSYNC : out std_logic);
	--end component;
	
	component Alien_control is
		Port ( clk : in  STD_LOGIC;
			  clk_enable : in STD_LOGIC;
			  h_count : in std_logic_vector(8 downto 0);
			  v_count : in std_logic_vector(8 downto 0);
			  alien_display_active : out std_logic;
			  hit : in  STD_LOGIC_VECTOR(5 downto 0);
			  --Sprite_x : out  STD_LOGIC_VECTOR(4 downto 0);
           --Sprite_y : out  STD_LOGIC_VECTOR(4 downto 0);
			  --Sprite_type : out STD_LOGIC_VECTOR(1 downto 0));
			  a1_pos_out : out std_logic_vector(18 downto 0);
			  a2_pos_out : out std_logic_vector(18 downto 0);
			  a3_pos_out : out std_logic_vector(18 downto 0);
			  y_a_pos_2 : out std_logic_vector(8 downto 0);
			  a456_stat : out std_logic_vector(2 downto 0);
			  Sprite_pos : out STD_LOGIC_VECTOR(9 downto 0));
	end component;
	
	component Player_Control is
		Port ( clk : in  STD_LOGIC;
			  clk_enable : in STD_LOGIC;
           btn_left : in  STD_LOGIC;
           btn_right : in  STD_LOGIC;
			  --reset : in STD_LOGIC;
           h_count : in  STD_LOGIC_VECTOR (8 downto 0);
           v_count : in  STD_LOGIC_VECTOR (8 downto 0);
			  Sprite_pos : out STD_LOGIC_VECTOR(9 downto 0);
			  player_pos_x : out STD_LOGIC_VECTOR(8 downto 0);
           --Sprite_x : out  STD_LOGIC_VECTOR (4 downto 0);
           --Sprite_y : out  STD_LOGIC_VECTOR (4 downto 0);
           --Sprite_type : out  STD_LOGIC_VECTOR (1 downto 0);
           player_display_active : out  STD_LOGIC);
	end component;
	
	component Bullet_Control is
		--Port ( clk : in STD_LOGIC;
			  --Player_pos : in  STD_LOGIC_VECTOR (8 downto 0);
           --Player_shoot : in  STD_LOGIC;
           --h_count : in  STD_LOGIC_VECTOR (8 downto 0);
           --v_count : in  STD_LOGIC_VECTOR (8 downto 0);
           --Sprite_pos : out  STD_LOGIC_VECTOR (9 downto 0);
           --Player_bullet_active : out  STD_LOGIC);
			  
		Port ( clk : in STD_LOGIC;
		     clk_enable : in STD_LOGIC;
			  Player_pos : in  STD_LOGIC_VECTOR (8 downto 0);
           Player_shoot : in  STD_LOGIC;
			  A_deac : in STD_LOGIC;
			  Pb_deac : in STD_LOGIC;
			 -- game_over : in STD_LOGIC;
           h_count : in  STD_LOGIC_VECTOR (8 downto 0);
			  v_count : in  STD_LOGIC_VECTOR (8 downto 0);
			  A1 : in STD_LOGIC_VECTOR (18 downto 0);
			  A2 : in std_LOGIC_VECTOR (18 downto 0);
			  A3 : in STD_LOGIC_VECTOR (18 downto 0);
			  Pb_pos : out std_LOGIC_VECTOR (18 downto 0);
			  Ab_pos : out std_LOGIC_VECTOR (18 downto 0);
           p_sprite_pos : out  STD_LOGIC_VECTOR (9 downto 0);
			  a_sprite_pos : out  STD_LOGIC_VECTOR (9 downto 0);
           Player_bullet_active : out  STD_LOGIC;
			  Alien_bullet_active : out  STD_LOGIC);
			  
	end component;
	
	component Priority_Sprite_MUX is
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
	end component;
	
	component Alien_hit_check is
		Port ( Player_Bullet_pos : in  STD_LOGIC_VECTOR (18 downto 0);
           A1_x_stat : in  STD_LOGIC_VECTOR (9 downto 0);
           A2_x_stat : in  STD_LOGIC_VECTOR (9 downto 0);
			  A3_x_stat : in  STD_LOGIC_VECTOR (9 downto 0);
			  A456_stat : in  STD_LOGIC_VECTOR (2 downto 0);
           A_y1 : in  STD_LOGIC_VECTOR (8 downto 0);
			  A_y2 : in  STD_LOGIC_VECTOR (8 downto 0);
           hit : out  STD_LOGIC_VECTOR (5 downto 0);
			  bullet_deac : out STD_LOGIC);
	end component;
	
	component Score_control is
		Port ( clk : in  STD_LOGIC;
           h_count : in  STD_LOGIC_VECTOR(8 downto 0);
           v_count : in  STD_LOGIC_VECTOR(8 downto 0);
			  reset : in  STD_LOGIC;
           increase : in  STD_LOGIC;
           --txt_Sprite_pos : out  STD_LOGIC_VECTOR (9 downto 0);
           num_Sprite_pos : out  STD_LOGIC_VECTOR (9 downto 0);
           --Txt_Display_active : out  STD_LOGIC;
           Num_Display_active : out  STD_LOGIC;
			  Num_Sprite_type : out  STD_LOGIC_VECTOR(4 downto 0));
	end component;
	
	component Game_state_Control is
		Port ( clk : in  STD_LOGIC;
           btn_1 : in  STD_LOGIC;
           btn_2 : in  STD_LOGIC;
			  btn_3 : in STD_LOGIC;
			  game_end_signal : in STD_LOGIC;
           game_over,quit : out  STD_LOGIC;
           pause : out  STD_LOGIC);
           --led_o : out  STD_LOGIC);
	end component;
	
	component Player_hit_check is
		Port ( Alien_bullet_pos : in  STD_LOGIC_VECTOR(18 downto 0);
           Player_posx : in  STD_LOGIC_VECTOR(8 downto 0);
			  game_over : in  STD_LOGIC;
           hit : out  STD_LOGIC);
	end component;
	
	
	signal player_pos_x : std_logic_vector(8 downto 0);
	--signal s_x,s_y : std_logic_vector(4 downto 0);
	signal a_active,p_active,pb_active,ab_active,num_active : std_logic;
	--signal tmp_type,s_type : std_logic_vector(1 downto 0);
	signal alien_sprite_pos,player_sprite_pos,pb_sprite_pos,ab_sprite_pos,num_sprite_pos : std_logic_vector(9 downto 0);
	--signal s_type : std_logic_vector(4 downto 0);
	signal alien_pos : pos_arr(0 to 5);
	signal bullet_pos : pos_arr(0 to 1);
	
	signal a1_xstat,a2_xstat,a3_xstat : std_logic_vector(9 downto 0);
	signal hit,hit_tmp : std_logic_vector(5 downto 0);
	signal pb_deac,inc,game_end_signal,p_hit,row_hit : std_logic;
	signal a456_stat : std_logic_vector(2 downto 0);
	signal y_a_pos2 : std_logic_vector(8 downto 0);
	signal num_sprite_type : std_logic_vector(4 downto 0);
	
	signal row1_ac,row2_ac : std_logic;
	signal row_boundary : std_logic_vector(8 downto 0);
	
	--signal clk_e : std_logic;
	signal not_p : std_logic;
	signal game_over : std_logic; --:= '0';
	signal pause,quit : std_logic;
	signal btn_right,btn_left,btn_shoot : std_logic;
begin
	btn_right <= br_j or br_d;
	btn_left <= bl_j or bl_d;
	btn_shoot <= bs_j or bs_d;

	game_con : Game_State_Control
		port map(clk => clk,
		game_over => game_over,game_end_signal => game_end_signal,btn_1 => btn_left,btn_2 => btn_right,
		btn_3 => btn_shoot,pause => pause,quit => quit);
	
	--clk_e <= clk and not game_over;
	not_p <= not (game_over or pause);
	game_end_signal <= row_hit or p_hit or quit;
		
	alien_con : Alien_Control
		port map (clk => clk,clk_enable => not_p,h_count=>h, v_count=>v, alien_display_active => a_active,
		Sprite_pos => alien_sprite_pos,a1_pos_out => alien_pos(0),a2_pos_out => alien_pos(1),
		a3_pos_out => alien_pos(2),y_a_pos_2 => y_a_pos2,A456_stat => a456_stat,hit => hit);
		--Sprite_x=>s_x, Sprite_y => s_y);
		
	row1_ac <= alien_pos(0)(0) or alien_pos(1)(0) or alien_pos(2)(0);
	row2_ac <= a456_stat(0) or a456_stat(1) or a456_stat(2);
	
	row_boundary <=  y_a_pos2 when row2_ac = '1' else 
						  alien_pos(0)(9 downto 1) when row1_ac = '1' else (others => '0');
	row_hit <= '1' when row_boundary = "111000010" else '0';
		
	player_con : Player_Control
		port map (clk => clk,clk_enable => not_p,btn_left => btn_left,btn_right => btn_right,h_count=>h, v_count=>v,
		Sprite_pos => player_sprite_pos,Player_pos_x => player_pos_x,
		player_display_active => p_active);
		
	bullet_con : Bullet_Control
		port map(clk => clk,clk_enable => not_p,Player_pos => player_pos_x,Player_shoot => btn_shoot,h_count => h,
		v_count => v,p_sprite_pos => pb_sprite_pos,a_sprite_pos => Ab_Sprite_pos,A1 => alien_pos(0),
		A2 => alien_pos(1),A3 => alien_pos(2),Player_bullet_active => pb_active,
		Alien_bullet_active => ab_active,Pb_pos => bullet_pos(0),Ab_pos => bullet_pos(1),
		Pb_deac => pb_deac,A_deac => game_end_signal);
	
	inc <= hit(0) or hit(1) or hit(2) or hit(3) or hit(4) or hit(5);
	--inc <= game_end_signal;
	
	--hit_gen : for i in 0 to 5 generate
		--hit(i) <= hit_tmp(i) or game_over;
	--end generate;
	
	Score_con : Score_control
		port map(clk => clk,h_count => h,v_count => v,increase => inc,num_Sprite_pos => num_sprite_pos,
		Num_Display_active => num_active,Num_Sprite_type => num_sprite_type,reset => game_end_signal);
		
	--s_type <= tmp_type when a_active = '1' else
		--		 "00";
		
	a1_xstat <= alien_pos(0)(18 downto 10) & alien_pos(0)(0);
	a2_xstat <= alien_pos(1)(18 downto 10) & alien_pos(1)(0);
	a3_xstat <= alien_pos(2)(18 downto 10) & alien_pos(2)(0);
	
	A_hit_check : Alien_hit_check 
		port map(Player_bullet_pos => bullet_pos(0),A1_x_stat => a1_xstat,A2_x_stat => a2_xstat,
		A3_x_stat => a3_xstat,A_y1 => alien_pos(0)(9 downto 1),A_y2 => y_a_pos2,A456_stat => a456_stat,
		hit => hit_tmp,bullet_deac => pb_deac);
		
	hit <= hit_tmp when game_end_signal = '0' else
			 (others => '1');
		
	P_hit_check : Player_hit_check
		port map(Alien_bullet_pos => bullet_pos(1),Player_posx => player_pos_x,game_over => game_over,
		hit => p_hit);
	--process(clk)
	--begin
		--if rising_edge(clk) then
			--if game_end_signal = '1' then
				--game_over <= '1';
			--end if;
		--end if;
	--end process;
		
	MUX : Priority_Sprite_MUX
		port map (Player_active => p_active,Alien_active => a_active,Bullet_active => pb_active,
		Alien_bullet_active => ab_active,Num_active => num_active,AB_Sprite_pos => Ab_Sprite_pos,
		Player_Sprite_pos => player_sprite_pos,Alien_Sprite_pos => alien_sprite_pos,
		Bullet_Sprite_pos => pb_sprite_pos,Sprite_type => s_type,Sprite_x => s_x,
		Sprite_y => s_y,Num_Sprite_pos => num_sprite_pos,Num_Sprite_type => num_sprite_type);
		
	--vga : VGA_Display
		--port map(clk=>clk, Sprite_posx => s_x,
		--Sprite_posy => s_y, Sprite_type => s_type,d_x => h,d_y => v,
		--R=>R,G=>G,B=>B,HSYNC=>HSYNC,VSYNC=>VSYNC,game_over => game_over);
	g_over <= game_over;

end Behavioral;

