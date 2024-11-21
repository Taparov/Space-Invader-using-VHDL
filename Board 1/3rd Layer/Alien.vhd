----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    07:29:28 11/04/2024 
-- Design Name: 
-- Module Name:    Alien - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Alien is
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
end Alien;

architecture Behavioral of Alien is
	type pos_array is array (natural range <>) of natural range 0 to 466;
	--type pos_logic_array is array (0 to 1) of std_logic_vector(18 downto 0)
	
	constant start_x : pos_array(0 to 2) := (0,64,128);
	constant start_y : pos_array(0 to 1) := (50,100);
	
	signal x : pos_array(0 to 5);
	signal y : pos_array(0 to 5);
	--signal a_pos : pos_logic_array;
	
	signal is_alive : std_logic_vector(5 downto 0) := "000000";
	--signal x : natural range 0 to 466 := 0;
	--signal y : natural range 0 to 436 := 50;
begin
	movement : process(clk)
		variable last_state_dir : std_logic;
	begin
		if rising_edge(clk) then
			if spawn = '1' then
				--x <= start_pos_x;
				--y <= start_pos_y;
				
				for i in 0 to 1 loop
					for j in 0 to 2 loop
						x(i*3 + j) <= start_x(j);
						y(i*3 + j) <= start_y(i);
					end loop;
				end loop;
				
			elsif mv_clk = '1' then
				if dir = '0' then
					for i in 0 to x'length - 1 loop
						x(i) <= x(i) + 2;
					end loop;
				else
					for i in 0 to x'length - 1 loop
						x(i) <= x(i) - 2;
					end loop;
				end if;
			end if;
			if dir /= last_state_dir then
				for i in 0 to 5 loop
					y(i) <= y(i) + 25;
				end loop;
			end if;
			last_state_dir := dir;
		end if;
	end process;

	spwn_dspawn : process(clk)
	begin
		if rising_edge(clk) then
			if spawn = '1' then
				is_alive <= "111111";
			else
				for i in 0 to 5 loop
					if hit(i) = '1' then
						is_alive(i) <= '0';
					end if;
				end loop;
			end if;
		end if;
	end process;
				
	a1_pos <= std_logic_vector(to_unsigned(x(0),9)) & std_logic_vector(to_unsigned(y(0),9)) & is_alive(0);
	a2_pos <= std_logic_vector(to_unsigned(x(1),9)) & std_logic_vector(to_unsigned(y(1),9)) & is_alive(1);
	a3_pos <= std_logic_vector(to_unsigned(x(2),9)) & std_logic_vector(to_unsigned(y(2),9)) & is_alive(2);
	a4_pos <= std_logic_vector(to_unsigned(x(3),9)) & std_logic_vector(to_unsigned(y(3),9)) & is_alive(3);
	a5_pos <= std_logic_vector(to_unsigned(x(4),9)) & std_logic_vector(to_unsigned(y(4),9)) & is_alive(4);
	a6_pos <= std_logic_vector(to_unsigned(x(5),9)) & std_logic_vector(to_unsigned(y(5),9)) & is_alive(5);
	
	--pos_y <= 50;
	--alive <= is_alive;
end Behavioral;

