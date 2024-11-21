----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:24:28 11/05/2024 
-- Design Name: 
-- Module Name:    Bullet - Behavioral 
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

entity Bullet is
    Port ( clk : in STD_LOGIC;
			  clk_mv : in  STD_LOGIC;
			  p_shoot,A_shoot : in STD_LOGIC;
			  A_sel : in STD_LOGIC_VECTOR(1 downto 0);
			  
			  --A_deac : in STD_LOGIC_VECTOR (1 downto 0);
			  A_deac : in  STD_LOGIC;
			  deactivate : in  STD_LOGIC;
			  
			  A1 : in STD_LOGIC_VECTOR (17 downto 0);
			  A2 : in STD_LOGIC_VECTOR (17 downto 0);
			  A3 : in STD_LOGIC_VECTOR (17 downto 0);
           player_bullet_start_pos : in  STD_LOGIC_VECTOR (8 downto 0);
			  
           bullet_pos : out  STD_LOGIC_VECTOR (18 downto 0);
			  A_bullet_pos : out STD_LOGIC_VECTOR (18 downto 0));
			  --A2_bullet_pos : out STD_LOGIC_VECTOR (18 downto 0));
end Bullet;

architecture Behavioral of Bullet is
	--type alien_bullet_pos is array (0 to 1) of natural range 0 to 481;
	--type a_start_pos is array (0 to 1) of std_logic_vector(8 downto 0);
	

	constant palyer_bullet_start_y : natural := 450;
	
	--signal alien_bullet_y : alien_bullet_pos;
	--signal alien_bullet_x : alien_bullet_pos;
	signal a_bx : natural range 0 to 481;
	signal a_by : natural range 0 to 471;
	--signal a_start_x,a_start_y : a_start_pos;
	--signal alien_bullet_active : std_logic_vector(1 downto 0) := "00";
	--signal a_s_array : std_logic_vector(1 downto 0);
	--signal a_active_array : std_logic_vector(1 downto 0) := "00";
	--signal a_deac_array : std_logic_vector(1 downto 0);
	signal a_b_active : STD_LOGIC := '0';
	signal temp_a1_y,temp_a2_y,temp_a3_y : natural range 0 to 471;
	
	signal int_player_pos_x : natural range 0 to 466;
	signal p_bx : natural range 0 to 481;
	signal p_by : natural range 0 to 450;
	signal p_b_active : std_logic := '0';
begin
	int_player_pos_x <= to_integer(unsigned(player_bullet_start_pos));
	temp_a1_y <= to_integer(unsigned(A1(8 downto 0)));
	temp_a2_y <= to_integer(unsigned(A2(8 downto 0)));
	temp_a3_y <= to_integer(unsigned(A3(8 downto 0)));
	--a_start_x <= (A1(17 downto 9),A2(17 downto 9));
	--a_start_y <= (A1(8 downto 0),A2(8 downto 0));
	
	p_movement : process(clk,clk_mv)
	begin
		if rising_edge(clk) then
			if p_shoot = '1' and p_b_active = '0' then
				p_bx <= int_player_pos_x + 15;
				p_by <= palyer_bullet_start_y;
			elsif clk_mv = '1' and p_b_active = '1' then
				p_by <= p_by - 1;
			end if;
		end if;
	end process;

	a_movement : process(clk,clk_mv)
	begin
		if rising_edge(clk) then
			if a_shoot = '1' and a_b_active = '0' then
				if A_sel = "00" then
					a_bx <= to_integer(unsigned(A1(17 downto 9))) + 15;
					a_by <= temp_a1_y;
				elsif A_sel = "01" then
					a_bx <= to_integer(unsigned(A2(17 downto 9))) + 15;
					a_by <= temp_a2_y;
				else
					a_bx <= to_integer(unsigned(A3(17 downto 9))) + 15;
					a_by <= temp_a3_y;
				end if;
			elsif clk_mv = '1' and a_b_active = '1' then
				a_by <= a_by + 1;
			end if;
			--for i in 0 to 1 loop
				--if A_shoot(i) = '1' and a_active_array(i) = '0' then
					--alien_bullet_y(i) <= to_integer(unsigned(a_start_y(i)));
					--alien_bullet_x(i) <= to_integer(unsigned(a_start_x(i))) + 15;
				--elsif rising_edge(clk_mv) and a_active_array(i) = '1' then
					--alien_bullet_y(i) <= alien_bullet_y(i) + 1;
				--end if;
			--end loop;
		end if;
	end process;
	
	
	activate : process(clk)
	begin
		if rising_edge(clk) then
			if p_shoot = '1' and p_b_active = '0' then
				p_b_active <= '1';
			elsif deactivate = '1' then
				p_b_active <= '0';
			end if;
		end if;
	end process;
	
	a_activate : process(clk)
	begin
		if rising_edge(clk) then
			if a_shoot = '1' and a_b_active = '0' then
				a_b_active <= '1';
			elsif a_deac = '1' then
				a_b_active <= '0';
			end if;
		end if;
	end process;
	
			
	--A1_bullet_pos <= std_logic_vector(to_unsigned(alien_bullet_x(0),9)) & 
						  --std_logic_vector(to_unsigned(alien_bullet_y(0),9)) & a_active_array(0);
						  
	--A2_bullet_pos <= std_logic_vector(to_unsigned(alien_bullet_x(1),9)) & 
						  --std_logic_vector(to_unsigned(alien_bullet_y(1),9)) & a_active_array(1);
						  
	A_bullet_pos <= std_logic_vector(to_unsigned(a_bx,9)) & std_logic_vector(to_unsigned(a_by,9)) & a_b_active;
						  
	bullet_pos <= std_logic_vector(to_unsigned(p_bx,9)) & std_logic_vector(to_unsigned(p_by,9)) & p_b_active;
			

end Behavioral;

