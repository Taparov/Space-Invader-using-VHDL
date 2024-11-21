----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:14:03 11/08/2024 
-- Design Name: 
-- Module Name:    Score_control - Behavioral 
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

entity Score_control is
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
end Score_control;

architecture Behavioral of Score_control is
	type sp_pos_arr is array (0 to 3) of std_logic_vector(4 downto 0);
	type pos_arr is array (0 to 3) of std_logic_vector(17 downto 0);

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
	
	constant unit_pos : std_logic_vector(17 downto 0) := "001110000000010001";
	constant tens_pos : std_logic_vector(17 downto 0) := "001100000000010001";
	constant h_tens_pos : std_logic_vector(17 downto 0) := "101011001000010001";
	constant h_unit_pos : std_logic_vector(17 downto 0) := "101101001000010001";
	--constant txt3_pos : std_logic_vector(17 downto 0) := "001000000000010001";

	signal start_pos : pos_arr;
	signal unit,tens,h_unit,h_tens : natural range 0 to 9 := 0;
	signal uni_active,tens_active : STD_LOGIC;
	signal sp_x,sp_y : sp_pos_arr;
	signal active : std_logic_vector(3 downto 0);
begin
	--start_pos(0) <= txt1_pos;
	--start_pos(1) <= txt2_pos;
	--start_pos(2) <= txt3_pos;
	start_pos(0) <= tens_pos;
	start_pos(1) <= unit_pos;
	start_pos(2) <= h_tens_pos;
	start_pos(3) <= h_unit_pos;
	
	increase_score : process(clk)
	begin
		if rising_edge(clk) then
			if reset = '1' then
				if tens > h_tens or (tens = h_tens and unit > h_unit) then
					h_tens <= tens;
					h_unit <= unit;
				end if;
				unit <= 0;
				tens <= 0;
			elsif increase = '1' then
				if unit <= 9 and tens <= 9 then
					if unit = 9 then
						if tens = 9 then
							tens <= 0;
						else
							tens <= tens + 1;
						end if;
						unit <= 0;
					else
						unit <= unit + 1;
					end if;
				end if;
			end if;
		end if;
	end process;
	
	--txt_gen : for i in 0 to 2 generate
		--cmp : In_box
			--port map(H_count => h_count,V_count => v_count,Sprite_size_x => 32,Sprite_size_y => 16,
			--A => start_pos(i),Q => active(i),Sprite_posx => Sp_x(i),Sprite_posy => Sp_y(i));
	--end generate;
	
	num_gen : for i in 0 to 3 generate
		num_cmp : In_box
			port map(H_count => h_count,V_count => v_count,Sprite_size_x => 16,Sprite_size_y => 10,
			A => start_pos(i),Q => active(i),Sprite_posx => Sp_x(i),Sprite_posy => Sp_y(i));
	end generate;
	
	Num_Sprite_type <= std_logic_vector(to_unsigned(tens,5)) when active(0) = '1' else
							 std_logic_vector(to_unsigned(unit,5)) when active(1) = '1' else
							 std_logic_vector(to_unsigned(h_tens,5)) when active(2) = '1' else
							 std_logic_vector(to_unsigned(h_unit,5)) when active(3) = '1' else
							 (others => '0');
	num_Sprite_pos <= sp_x(0) & sp_y(0) when active(0) = '1' else
							sp_x(1) & sp_y(1) when active(1) = '1' else
							sp_x(2) & sp_y(2) when active(2) = '1' else
							sp_x(3) & sp_y(3) when active(3) = '1' else
							(others => '0');
							
	--txt_Sprite_pos	<= sp_x(0) & sp_y(0) when active(0) = '1' else
							--sp_x(1) & sp_y(1) when active(1) = '1' else
							--sp_x(2) & sp_y(2) when active(2) = '1' else
							--(others => '0');					
							 
	--Txt_Display_active <= active(0) or active(1) or active(2);
	Num_Display_active <= active(0) or active(1) or active(2) or active(3);
	
			
end Behavioral;

