----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:29:32 11/04/2024 
-- Design Name: 
-- Module Name:    Player_Control - Behavioral 
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

entity Player_Control is
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
end Player_Control;

architecture Behavioral of Player_Control is
	--constant sprite_t : std_logic_vector := "10";

	component Player is
		Port ( clk : in  STD_LOGIC;
           clk_mv : in  STD_LOGIC;
           btn_left : in  STD_LOGIC;
           btn_right : in  STD_LOGIC;
			  --reset : in STD_LOGIC;
           player_pos : out  STD_LOGIC_VECTOR(17 downto 0));
		end component;
		
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
		
		signal player_pos : std_logic_vector(17 downto 0);
		signal clk_mv : std_logic := '0';
		signal Sprite_x,Sprite_y : std_logic_vector(4 downto 0);
begin
	clk_divider : process(clk)
	 variable p_ct : natural range 0 to 99999 := 0;
	begin
		if rising_edge(clk)then
			if p_ct = 99999 then
				clk_mv <= '1' and clk_enable;
				p_ct := 0;
			else
				clk_mv <= '0';
				p_ct := p_ct + 1;
			end if;
		end if;
	end process;
	
	Plyr : Player
		port map (clk => clk,clk_mv => clk_mv,btn_left => btn_left,btn_right => btn_right,
		player_pos => player_pos);
		
	Player_cmp : In_box
		port map (H_count => h_count,V_count => v_count,Sprite_size_x => 32,
		Sprite_size_y => 22,A => player_pos,Q => player_display_active,Sprite_posx => Sprite_x,Sprite_posy => Sprite_y);
		
	--Sprite_type <= Sprite_t;
	Player_pos_x <= player_pos(17 downto 9);
	Sprite_pos <= Sprite_x & Sprite_y;

end Behavioral;

