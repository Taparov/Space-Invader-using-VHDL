----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:25:08 11/04/2024 
-- Design Name: 
-- Module Name:    Alien_control - Behavioral 
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

entity Alien_control is
      Port ( clk : in  STD_LOGIC;
			  clk_enable : in STD_LOGIC;
			  h_count : in std_logic_vector(8 downto 0);
			  v_count : in std_logic_vector(8 downto 0);
			  alien_display_active : out std_logic;
			  --Sprite_x : out  STD_LOGIC_VECTOR(4 downto 0);
           --Sprite_y : out  STD_LOGIC_VECTOR(4 downto 0);
			  --Sprite_type : out STD_LOGIC_VECTOR(1 downto 0));
			  
			  hit : in  STD_LOGIC_VECTOR(5 downto 0);
			  
			  a1_pos_out : out std_logic_vector(18 downto 0);
			  a2_pos_out : out std_logic_vector(18 downto 0);
			  a3_pos_out : out std_logic_vector(18 downto 0);
			  y_a_pos_2 : out std_logic_vector(8 downto 0);
			  a456_stat : out std_logic_vector(2 downto 0);
			  Sprite_pos : out STD_LOGIC_VECTOR(9 downto 0));
			  
		--Port ( clk : in  STD_LOGIC;
           --btn_right : in  STD_LOGIC;
           --btn_left : in  STD_LOGIC;
			  --R : out STD_LOGIC;
			  --G : out std_logic;
			  --B : out std_logic;
			  --HSYNC : out std_logic;
			  --VSYNC : out std_logic);
			  
			  
end Alien_control;

architecture Behavioral of Alien_control is
	component Alien is
		Port ( clk : in  STD_LOGIC;
           mv_clk : in  STD_LOGIC;
			  spawn : in STD_LOGIC;
           dir : in  STD_LOGIC;
           hit : in  STD_LOGIC_VECTOR(5 downto 0);
           --start_pos_x : in  natural range 0 to 466;
           --start_pos_y : in  natural range 0 to 436;
           --pos_x : out  natural range 0 to 466;
           --pos_y : out  natural range 0 to 436;		  
           --alive : out  STD_LOGIC;
			  a1_pos : out STD_LOGIC_VECTOR(18 downto 0);
			  a2_pos : out STD_LOGIC_VECTOR(18 downto 0);
			  
			  a3_pos : out STD_LOGIC_VECTOR(18 downto 0);
			  a4_pos : out STD_LOGIC_VECTOR(18 downto 0);
			  a5_pos : out STD_LOGIC_VECTOR(18 downto 0);
			  a6_pos : out STD_LOGIC_VECTOR(18 downto 0));
	end component;
	
	component Alien_Display_Control is
		Port ( --clk : in  STD_LOGIC;
           h_count : in  STD_LOGIC_VECTOR(8 downto 0);
           v_count : in  STD_LOGIC_VECTOR(8 downto 0);
           A1,A2 : in  STD_LOGIC_VECTOR (18 downto 0);
			  
			  A3,A4,A5,A6 : in  STD_LOGIC_VECTOR (18 downto 0);
			  
			  active : out STD_LOGIC;
           Sprite_x : out  STD_LOGIC_VECTOR(4 downto 0);
           Sprite_y : out  STD_LOGIC_VECTOR(4 downto 0));
           --Sprite_type : out  STD_LOGIC_VECTOR (1 downto 0));
      end component;
		
	component VGA_Display is
		Port ( clk,p_l,p_r : in  STD_LOGIC;
			  sprite_posx : in STD_LOGIC_VECTOR(4 downto 0);
			  sprite_posy : in STD_LOGIC_VECTOR(4 downto 0);
			  sprite_type : in std_logic_vector(1 downto 0);
			  d_x : out STD_LOGIC_VECTOR(8 downto 0);
			  d_y : out STD_LOGIC_VECTOR(8 downto 0);
			  R : out STD_LOGIC;
			  G : out std_logic;
			  B : out std_logic;
			  HSYNC : out std_logic;
			  VSYNC : out std_logic);
	end component;
	
	component Priority_MUX is
		Port ( N1 : in  STD_LOGIC_VECTOR (8 downto 0);
           N2 : in  STD_LOGIC_VECTOR (8 downto 0);
           N3 : in  STD_LOGIC_VECTOR (8 downto 0);
           N4 : in  STD_LOGIC_VECTOR (8 downto 0);
           s1 : in  STD_LOGIC;
           s2 : in  STD_LOGIC;
           s3 : in  STD_LOGIC;
           s4 : in  STD_LOGIC;
           Q : out  natural range 0 to 498);
	end component;
	
	type pos_arr is array (natural range <>) of std_logic_vector(18 downto 0);
	
	constant clk_lv1 : natural := 999999;
	constant clk_lv2 : natural := 799999;
	constant clk_lv3 : natural := 499999;
	
	signal left_boundary,right_boundary : natural range 0 to 498;
	--constant start_x : natural := 0;
	--constant start_y : natural := 0;
	signal a_posx,a_posy : natural;
	signal a_alv : std_logic;
	signal dir,reset : std_logic := '0';
	signal mv_clk : std_logic;
	signal wave_run,clear : std_logic;
	signal sprite : std_logic_vector(1 downto 0);
	--signal a1_pos,a2_pos : std_logic_vector(18 downto 0);
	signal a_pos : pos_arr(0 to 5);
	signal col_active : std_logic_vector(2 downto 0);
	
	--signal h_count,v_count : std_logic_vector(8 downto 0);
	signal Sprite_x,Sprite_y : std_logic_vector(4 downto 0);
	signal level : natural range 0 to 3 := 0;
	signal counter_max : natural range 0 to 999999;
	--signal Sprite_type,s_type : std_logic_vector(1 downto 0);
	--signal alien_display_active : std_logic;
	--signal clk_e : std_logic;
begin
	--clk_e <= clk_enable and clk;
	
	clk_divide : process(clk)
		variable counter : natural range 0 to 999999 := 0;
	begin
		if rising_edge(clk) then
			if counter = counter_max then
				mv_clk <= '1' and clk_enable;
				counter := 0;
			else
			   mv_clk <= '0';
				counter := counter + 1;
			end if;
		end if;
	end process;
	
	counter_max <= clk_lv1 when level = 1 else
	              clk_lv2 when level = 2 else
					  clk_lv3 when level = 3 else
					  499999;
	
	clear <= hit(0) and hit(1) and hit(2) and hit(3) and hit(4) and hit(5);
	lvl_con : process(clk)
		variable changed : std_logic;
	begin
		if rising_edge(clk) then
			if clear = '1' then
				level <= 0;
			end if;
			if wave_run = '1' and changed = '0' then
				if level /= 3 then
					level <= level + 1;
				end if;
			end if;
			changed := wave_run;
		end if;
	end process;
	
	wave_delay : process(clk,wave_run)
		variable delay_ct : natural range 0 to 99999999 := 0;
	begin
		if rising_edge(clk) and wave_run = '0'then
			if clk_enable = '1' then
				if delay_ct = 99999999 then
					reset <= '1';
					delay_ct := 0;
					--if level /= 3 then
						--level <= level + 1;
					--end if;
				else
					delay_ct := delay_ct + 1;
					reset <= '0';
				end if;
			end if;
		end if;
	end process;
	
	chng_dir : process(clk)
	begin
		if rising_edge(clk) then
			if left_boundary = 0 then
				if dir = '1' then
					dir <= '0';
				end if;
			elsif right_boundary = 466 then
				if dir = '0' then
					dir <= '1';
				end if;
			end if;
		end if;
	end process;
	
	
	aliens : Alien
		port map( clk => clk,mv_clk => mv_clk, dir => dir, hit => hit, spawn => reset,
		a1_pos => a_pos(0), a2_pos => a_pos(1),a3_pos => a_pos(2),a4_pos => a_pos(3),
		a5_pos => a_pos(4),a6_pos => a_pos(5));
					--start_pos_x => start_x, start_pos_y => start_y, pos_x =>a_posx, pos_y => a_posy,
					--alive => a_alv);
	
   wave_run <= a_pos(0)(0) or a_pos(1)(0) or a_pos(2)(0) or a_pos(3)(0) or a_pos(4)(0) or a_pos(5)(0);	
	--left_boundary <= to_integer(unsigned(a1_pos(18 downto 10)));
	--right_boundary <= to_integer(unsigned(a2_pos(18 downto 10))) + 32;
	
	col_active_gen : for i in 0 to 2 generate
		col_active(i) <= a_pos(i)(0) or a_pos(3+i)(0);
	end generate;
	
	l_bound : Priority_MUX 
		port map(N1 => a_pos(0)(18 downto 10),N2 => a_pos(1)(18 downto 10),N3 => a_pos(2)(18 downto 10),N4 => (others => '0'),
		s1 => col_active(0),s2 => col_active(1),s3 => col_active(2),s4 => '0',Q => left_boundary);
		
	r_bound : Priority_MUX 
		port map(N1 => (others => '0'),N2 => a_pos(2)(18 downto 10),N3 => a_pos(1)(18 downto 10),N4 => a_pos(0)(18 downto 10),
		s1 => '0',s2 => col_active(2),s3 => col_active(1),s4 => col_active(0),Q => right_boundary);
	
	--a_pos <= std_logic_vector(to_unsigned(a_posx,9)) & std_logic_vector(to_unsigned(a_posy,9)) & a_alv;
	
	Display : Alien_Display_Control
		port map(h_count => h_count,v_count => v_count,A1 => a_pos(0), A2 => a_pos(1),
		active => alien_display_active,Sprite_x =>Sprite_x,Sprite_y=> Sprite_y,
		A3 => a_pos(2),A4 => a_pos(3),A5 => a_pos(4),A6 => a_pos(5));
		
	Sprite_pos <= Sprite_x & Sprite_y;
	--vga : VGA_Display
		--port map(clk => clk,p_l => btn_left, p_r => btn_right, Sprite_posx => Sprite_x,
		--Sprite_posy => Sprite_y, Sprite_type => s_type,d_x => h_count,d_y => v_count,
		--R=>R,G=>G,B=>B,HSYNC=>HSYNC,VSYNC=>VSYNC);
		
	--s_type <= Sprite_type when alien_display_active = '1' else "00";
	
	a1_pos_out <= a_pos(0);
	a2_pos_out <= a_pos(1);
	a3_pos_out <= a_pos(2);
	y_a_pos_2 <= a_pos(3)(9 downto 1);
	a456_stat <= a_pos(5)(0) & a_pos(4)(0) & a_pos(3)(0);

end Behavioral;

