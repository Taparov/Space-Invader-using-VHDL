----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:12:15 11/05/2024 
-- Design Name: 
-- Module Name:    Bullet_Control - Behavioral 
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

entity Bullet_Control is
    Port ( clk : in STD_LOGIC;
			  clk_enable : in STD_LOGIC;
			  Player_pos : in  STD_LOGIC_VECTOR (8 downto 0);
           Player_shoot : in  STD_LOGIC;
			  --game_over : in STD_LOGIC;
			  A_deac : in STD_LOGIC;
			  Pb_deac : in STD_LOGIC;
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
end Bullet_Control;

architecture Behavioral of Bullet_Control is

	component Bullet is
		--Port ( clk : in STD_LOGIC;
			  --clk_mv : in  STD_LOGIC;
			  --p_shoot : in STD_LOGIC;
			  --deactivate : in STD_LOGIC;
           --player_bullet_start_pos : in  STD_LOGIC_VECTOR (8 downto 0);
           --bullet_pos : out  STD_LOGIC_VECTOR (18 downto 0));
			  
		Port ( clk : in STD_LOGIC;
			  clk_mv : in  STD_LOGIC;
			  p_shoot,A_shoot : in STD_LOGIC;
			  A_sel : in STD_LOGIC_VECTOR(1 downto 0);
			  A_deac : in  STD_LOGIC;
			  deactivate : in  STD_LOGIC;
			  A1 : in STD_LOGIC_VECTOR (17 downto 0);
			  A2 : in STD_LOGIC_VECTOR (17 downto 0);
			  A3 : in STD_LOGIC_VECTOR (17 downto 0);
           player_bullet_start_pos : in  STD_LOGIC_VECTOR (8 downto 0);
           bullet_pos : out  STD_LOGIC_VECTOR (18 downto 0);
			  A_bullet_pos : out STD_LOGIC_VECTOR (18 downto 0));
	end component;
	
	component Enemy_Bullet_Control is
		Port ( clk : in  STD_LOGIC;
           A1_pos_stat : in  STD_LOGIC_VECTOR (9 downto 0);
			  A2_pos_stat : in  STD_LOGIC_VECTOR (9 downto 0);
			  A3_pos_stat : in  STD_LOGIC_VECTOR (9 downto 0);
			  A_b_active : in STD_LOGIC;
           Player_pos_x : in  STD_LOGIC_VECTOR (8 downto 0);
           A_shoot : out  STD_LOGIC;
			  A_sel :  out STD_LOGIC_VECTOR (1 downto 0));
		end component;
	
	component Bullet_Display_Control is
		Port ( h_count : in  STD_LOGIC_VECTOR (8 downto 0);
           v_count : in  STD_LOGIC_VECTOR (8 downto 0);
           Player_Bullet_pos : in  STD_LOGIC_VECTOR (18 downto 0);
			  A_pos : in  STD_LOGIC_VECTOR (18 downto 0);
           Player_spt_pos : out STD_LOGIC_VECTOR(9 downto 0);
			  A_spt_pos : out STD_LOGIC_VECTOR(9 downto 0);
           p_active : out  STD_LOGIC;
			  a_active : out STD_LOGIC);
		--Port ( h_count : in  STD_LOGIC_VECTOR (8 downto 0);
           --v_count : in  STD_LOGIC_VECTOR (8 downto 0);
           --Player_Bullet_pos : in  STD_LOGIC_VECTOR (18 downto 0);
           --Sprite_x : out  STD_LOGIC_VECTOR (4 downto 0);
           --Sprite_y : out  STD_LOGIC_VECTOR (4 downto 0);
           --active : out  STD_LOGIC);
	end component;
	
	component Bullet_Deac_Con is
		 Port ( Plyr_blt_pos : in  STD_LOGIC_VECTOR (8 downto 0);
           A_blt_pos : in  STD_LOGIC_VECTOR (8 downto 0);
           Deac : out  STD_LOGIC_VECTOR (1 downto 0));
	end component;

	signal clk_mv : std_logic := '0';
	--signal p_deactivate : std_logic;
	signal deac_arr: std_logic_vector(1 downto 0);
	signal p_b_pos : std_logic_vector(18 downto 0);
	signal a_shoot : STD_LOGIC := '0';
	signal A_blt_pos :  STD_LOGIC_VECTOR (18 downto 0);
	signal a_sel : std_logic_vector(1 downto 0);
	signal plyr_blt_deac,a_blt_deac : STD_LOGIC;
	signal tmp_a1_pos,tmp_a2_pos,tmp_a3_pos : std_logic_vector(9 downto 0);
	--signal clk_e : std_logic;

begin
	--clk_e <= clk and clk_enable;
	
	clk_divider : process(clk)
	 variable p_ct : natural range 0 to 49999 := 0;
	begin
		if rising_edge(clk) then
			if p_ct = 49999 then
				clk_mv <= '1' and clk_enable;
				p_ct := 0;
			else
				clk_mv <= '0';
				p_ct := p_ct + 1;
			end if;
		end if;
	end process;

	bullets : Bullet
		port map (clk => clk,clk_mv => clk_mv,p_shoot => Player_shoot,deactivate => plyr_blt_deac,
		A_shoot => a_shoot,A_deac => a_blt_deac,A1 => A1(18 downto 1),A2 => A2(18 downto 1),
		A3 => A3(18 downto 1),Player_bullet_start_pos => player_pos,Bullet_pos => p_b_pos,
		A_bullet_pos => A_blt_pos,A_sel => a_sel);
		
	Pb_pos <= p_b_pos;
	Ab_pos <= A_blt_pos;
	
	plyr_blt_deac <= deac_arr(0) or Pb_deac or A_deac;
	a_blt_deac <= deac_arr(1) or A_deac;
		
	tmp_a1_pos <= A1(18 downto 10) & A1(0);
	tmp_a2_pos <= A2(18 downto 10) & A2(0);
	tmp_a3_pos <= A3(18 downto 10) & A3(0);
	
	alien_bullet_con : Enemy_Bullet_Control
		port map(clk => clk,A1_pos_stat => tmp_a1_pos,
		A2_pos_stat => tmp_a2_pos,A3_pos_stat => tmp_a3_pos,A_b_active => A_blt_pos(0),
		Player_pos_x => Player_pos,A_shoot => a_shoot,A_sel => a_sel);
		
		
	display : Bullet_Display_Control
		port map (h_count => h_count,v_count => v_count,Player_Bullet_pos => p_b_pos,A_pos => a_blt_pos,
		Player_spt_pos => p_sprite_pos,A_spt_pos => a_sprite_pos,
		p_active => Player_bullet_active,a_active => Alien_bullet_active);
		
	deac_con : Bullet_Deac_Con
		port map(Plyr_blt_pos => p_b_pos(9 downto 1),A_blt_pos => a_blt_pos(9 downto 1),
		Deac => deac_arr);
		
	--deac_gen : for i in 0 to 1 generate
		--deac_arr(i) <= deac_tmp(i) or game_over;
	--end generate;
		
	--p_sprite_pos <= spb_x & spb_y;
	--p_deactivate <= '1' when p_b_pos(9 downto 1) = "000000000" else '0';

end Behavioral;

