----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:30:20 11/05/2024 
-- Design Name: 
-- Module Name:    Enemy_Bullet_Control - Behavioral 
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

entity Enemy_Bullet_Control is
    Port ( clk : in  STD_LOGIC;
           A1_pos_stat : in  STD_LOGIC_VECTOR (9 downto 0);
			  A2_pos_stat : in  STD_LOGIC_VECTOR (9 downto 0);
			  A3_pos_stat : in  STD_LOGIC_VECTOR (9 downto 0);
			  A_b_active : in STD_LOGIC;
           Player_pos_x : in  STD_LOGIC_VECTOR (8 downto 0);
           A_shoot : out  STD_LOGIC;
			  A_sel :  out STD_LOGIC_VECTOR (1 downto 0));
end Enemy_Bullet_Control;

architecture Behavioral of Enemy_Bullet_Control is
	type pos_stat is array (0 to 2) of std_logic_vector(9 downto 0);

	component in_range is
		Port ( player_pos : in  STD_LOGIC_VECTOR (8 downto 0);
           alien_pos : in  STD_LOGIC_VECTOR (8 downto 0);
           Q : out  STD_LOGIC);
	end component;

	signal rand_num : natural range 0 to 4 := 0;
	signal inrange : std_logic_vector(2 downto 0);
	signal a_pos_stat : pos_stat;
	signal delay : std_logic := '0';
begin
	a_pos_stat(0) <= A1_pos_stat;
	a_pos_stat(1) <= A2_pos_stat;
	a_pos_stat(2) <= A3_pos_stat;

	--a1 : in_range
		--port map(player_pos => Player_pos_x,alien_pos => A1_pos_x_stat(10 downto 2),Q => inrange(0));
	inrange_gen : for i in 0 to 2 generate
		a : in_range
			port map(player_pos => Player_pos_x,alien_pos => a_pos_stat(i)(9 downto 1),Q => inrange(i));
	end generate;

	rand_clk : process(clk)
	begin
		if rising_edge(clk) then
			if rand_num = 4 then
				rand_num <= 0;
			else
				rand_num <= rand_num + 1;
			end if;
		end if;
	end process;
	
	main : process(clk)
		variable ct_a : natural range 0 to 39999999 := 0;
	begin
		if rising_edge(clk) then
			if delay = '1' then
				if ct_a = 39999999 then
					delay <= '0';
					ct_a := 0;
				else
					ct_a := ct_a + 1;
				end if;
			end if;
			
			
			if inrange(0) = '1' and A1_pos_stat(0) = '1' and a_b_active = '0' and delay = '0' then
				if rand_num < 2 then
					A_shoot <= '1';
					A_sel <= "00";
				else
					delay <= '1';
					A_shoot <= '0';
				end if;
			elsif inrange(1) = '1' and A2_pos_stat(0) = '1' and a_b_active = '0' and delay = '0' then
				if rand_num < 2 then
					A_shoot <= '1';
					a_sel <= "01";
				else
					delay <= '1';
					A_shoot <= '0';
				end if;
			elsif inrange(2) = '1' and A3_pos_stat(0) = '1' and a_b_active = '0' and delay = '0' then
				if rand_num < 2 then
					A_shoot <= '1';
					a_sel <= "10";
				else
					delay <= '1';
					A_shoot <= '0';
				end if;
			else
				A_shoot <= '0';
			end if;
		end if;
	end process;

end Behavioral;

