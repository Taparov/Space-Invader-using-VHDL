----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:55:13 11/01/2024 
-- Design Name: 
-- Module Name:    VGA_Display - Behavioral 
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
use work.Num_Txt_Sprite.All;
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity VGA_Display is
    Port ( clk : in  STD_LOGIC;
			  --p_l,p_r : in STD_LOGIC;
			  game_over  :  in STD_LOGIC;
			  sprite_posx : in STD_LOGIC_VECTOR(4 downto 0);
			  sprite_posy : in STD_LOGIC_VECTOR(4 downto 0);
			  sprite_type : in std_logic_vector(4 downto 0);
			  d_x : out STD_LOGIC_VECTOR(8 downto 0);
			  d_y : out STD_LOGIC_VECTOR(8 downto 0);
			  R : out STD_LOGIC;
			  G : out std_logic;
			  B : out std_logic;
			  HSYNC : out std_logic;
			  VSYNC : out std_logic);
end VGA_Display;

architecture Behavioral of VGA_Display is
	constant X_VISIBLE_AREA : natural := 508;
	constant X_FRONT_PORCH : natural := 13;
	constant X_SYNC_PULSE : natural := 76;
	constant X_BACK_PORCH : natural := 38;
	constant X_WHOLE_LINE : natural := 635;

	constant Y_VISIBLE_AREA : natural := 480;
	constant Y_FRONT_PORCH : natural := 10;
	constant Y_SYNC_PULSE : natural := 2;
	constant Y_BACK_PORCH : natural := 33;
	constant Y_WHOLE_FRAME : natural := 525;
	
	type player_sprite_array is array (0 to 21) of std_logic_vector(31 downto 0);
	type alien_sprite_array is array (0 to 13) of std_logic_vector(31 downto 0);
    constant player : player_sprite_array := (
        "00000000011000000000011000000000",
        "00000000011000000000011000000000",
        "00000000111100000000111100000000",
        "00000000111100000000111100000000",
        "00000000111100000000111100000000",
        "00000001111100000000111110000000",
        "00000001111100000000111110000000",
        "00000001111111111111111110000000",
        "00000011111111111111111111000000",
        "00000011111111000011111111000000",
		  "00000011111110000001111111000000",
        "00000111111100000000111111100000",
        "00000111111111111111111111100000",
        "00000110111011100001100001100000",
        "00000110111011111101111101100000",
        "00000110111011111101111101100000",
        "00000110000011100001100001100000",
		  "00000110111111101111111101100000",
        "00000110111111101111111101100000",
        "00000110111111100001100001100000",
        "00000111111111111111111111100000",
        "00000001111000000000011110000000"
    );
	 
	  constant alien : alien_sprite_array := (
        "00000000001000000000010000000000",
        "00000000000000000000000000000000",
        "00000000000010000001000000000000",
        "00000000000110000001000000000000",
        "00000000001111111111110000000000",
        "00000000111000110100011100000000",
        "00000000111000111100011100000000",
		  "00000011111111111111111111000000",
        "00000010011111111111110001000000",
        "00000010001111111111110001000000",
        "00000010001000000000010001000000",
        "00000010001000000000010001000000",
        "00000000000000000000000000000000",
        "00000000000011100111000000000000"
	 );

	signal x : natural range 0 to 635 := 0;
	signal y : natural range 0 to 525:= 0;
	signal pos : natural range 0 to 476 := 0;
	signal sprite_type_int : natural range 0 to 31;
	signal int_sprite_posx,int_sprite_posy : natural;
	signal tmp,clk_p : std_logic := '0';
begin

	int_sprite_posx <= CONV_INTEGER(unsigned(Sprite_posx));
	int_sprite_posy <= CONV_INTEGER(unsigned(Sprite_posy));
	sprite_type_int <= CONV_INTEGER(unsigned(Sprite_type));
	
	vga_counter : process(clk)
	begin
		if rising_edge(clk) then
			if x = X_WHOLE_LINE then
				x <= 0;
				if y = Y_WHOLE_FRAME then
					y <= 0;
				else
					y <= y+1;
				end if;
			else
				x <= x + 1;
			end if;
		end if;
	end process;
	
	display : process(clk,x,sprite_type,sprite_posx,sprite_posy)
	begin
		if rising_edge(clk) then
			if x > X_VISIBLE_AREA + X_FRONT_PORCH and x <= X_VISIBLE_AREA + X_FRONT_PORCH + X_SYNC_PULSE then
				HSYNC <= '0';
			else
				HSYNC <= '1';
			end if;

			if y > Y_VISIBLE_AREA + Y_FRONT_PORCH and y <= Y_VISIBLE_AREA + Y_FRONT_PORCH + Y_SYNC_PULSE then
				VSYNC <= '0';
			else
				VSYNC <= '1';
			end if;
			
			if game_over = '1' then
				if x >= 201 and x < 297 and y >= 228 and y < 243 then
					if x >= 201 and x < 225 then
						R <= game_over_spt(0)(y-228)(31 - (X - 201));
						G <= game_over_spt(0)(y-228)(31 - (X - 201));
					elsif x >= 225 and x < 249 then
						R <= game_over_spt(1)(y-228)(31 - (X - 225));
						G <= game_over_spt(1)(y-228)(31 - (X - 225));
					elsif x >= 249 and x < 273 then
						R <= game_over_spt(2)(y-228)(31 - (X - 249));
						G <= game_over_spt(2)(y-228)(31 - (X - 249));
					else
						R <= game_over_spt(3)(y-228)(31 - (X - 273));
						G <= game_over_spt(3)(y-228)(31 - (X - 273));
					end if;
					B <= '0';
				else
					R <= '0';
					G <= '0';
				end if;
			elsif sprite_type = "01011" then
				if alien(int_sprite_posy)(31 - int_sprite_posx) = '1' then
					R <= '1';
					G <= '0';
					B <= '0';
				else
					R <= '0';
					G <= '0';
					B <= '0';
				end if;
			elsif sprite_type = "01010" then
				if player(int_sprite_posy)(31 - int_sprite_posx) = '1' then
					R <= '1';
					G <= '1';
					B <= '1';
				else
					R <= '0';
					G <= '0';
					B <= '0';
				end if;
			elsif sprite_type = "01100" then
				R <= '0';
				G <= '1';
				B <= '1';
			elsif sprite_type = "11111" then
				R <= '0';
				G <= '0';
				B <= '0';
			else
				R <= num_sprites(sprite_type_int)(int_sprite_posy)(15 - int_sprite_posx);
				G <= num_sprites(sprite_type_int)(int_sprite_posy)(15 - int_sprite_posx);
				B <= num_sprites(sprite_type_int)(int_sprite_posy)(15 - int_sprite_posx);
			end if;
		end if;
	end process;
	
	--clk_p_divider : process(clk)
	 --variable p_ct : natural range 0 to 49999 := 0;
	--begin
		--if rising_edge(clk)then
			--if p_ct = 49999 then
				--clk_p <= not clk_p;
				--p_ct := 0;
			--else
				--p_ct := p_ct + 1;
			--end if;
		--end if;
	--end process;
	
	--movement : process(clk_p,p_l,p_r)
	--begin
		--if rising_edge(clk_p) then
			--if p_l = '1' then
				--if pos /= 0 then
				--pos <= pos - 1;
				--end if;
			--elsif p_r = '1' then
				--if pos /= 466 then
					--pos <= pos + 1;
				--end if;
			--end if;
		--end if;
	--end process;
	
	d_x <= std_logic_vector(conv_unsigned(x, 9)) when x < 509 else std_logic_vector(conv_unsigned(509, 9));
	d_y <= std_logic_vector(conv_unsigned(y, 9)) when y < 481 else std_logic_vector(conv_unsigned(481, 9));

end Behavioral;

