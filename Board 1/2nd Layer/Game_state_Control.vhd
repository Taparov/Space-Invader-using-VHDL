----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:19:27 11/08/2024 
-- Design Name: 
-- Module Name:    Game_state_Control - Behavioral 
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

entity Game_state_Control is
    Port ( clk : in  STD_LOGIC;
           btn_1 : in  STD_LOGIC;
           btn_2 : in  STD_LOGIC;
			  btn_3 : in STD_LOGIC;
			  game_end_signal : in STD_LOGIC;
			  quit : out STD_LOGIC;
           game_over : out  STD_LOGIC;
           pause : out  STD_LOGIC);
           --led_o : out  STD_LOGIC);
end Game_state_Control;

architecture Behavioral of Game_state_Control is

	signal f50ms : std_logic := '0';
	--signal led_temp : std_logic := '0';
	signal pause_tmp : std_logic := '0';
	signal game_over_tmp : std_logic := '0';

begin

	process(clk)
		variable l_s : std_logic;
	begin
		if rising_edge(clk) then
			if game_end_signal = '1' then
				game_over_tmp <= '1';
			elsif btn_3 = '1' and btn_2 = '1' and btn_1 = '0' and l_s = '0' then
				if game_over_tmp = '1' then
					game_over_tmp <= '0';
				end if;
				--if btn_1 = '1' and btn_2 = '1' and btn_last_state = "00" then
					--if game_over_tmp = '1' then
						--game_over_tmp <= '0';
					--end if;
				--end if;
				 --btn_last_state := (btn_2,btn_1);
			end if;
			l_s := btn_2;
		end if;
	end process;
	game_over <= game_over_tmp;
	
	
	mod_clk : process(clk)
		variable ct : natural range 1 to 1500000 := 1;
	begin
		if rising_edge(clk) then
			if ct = 1500000 then
				ct := 1;
				f50ms <= '1';
			else
				f50ms <= '0';
				ct := ct +1;
			end if;
		end if;
	end process;
	
	btn_check : process(clk)
		variable btn_last_state : std_logic_vector(1 downto 0);
	begin
		if rising_edge(clk) then
			--if game_end_signal = '1' then
				--game_over_tmp <= '1';
				--pause_tmp <= '1';
			if f50ms = '1' then
				if btn_1 = '1' and btn_2 = '1' and btn_last_state = "00" then
					if game_over_tmp = '0' then
						pause_tmp <= not pause_tmp;
						--led_temp <= not led_temp;
					--else
						--game_over_tmp <= '0';
						--pause_tmp <= '0';
					end if;
				end if;
				btn_last_state := (btn_2,btn_1);
			elsif btn_1 = '1' and btn_2 = '1' and btn_3 = '1' then
				if pause_tmp = '1' then
					pause_tmp <= '0';
					quit <= '1';
				else
					quit <= '0';
				end if;
			else
				quit <= '0';
			end if;
		end if;
	end process;
	
	pause <= pause_tmp;
	--game_over <= game_over_tmp;
	--led_o <= led_temp;

end Behavioral;

