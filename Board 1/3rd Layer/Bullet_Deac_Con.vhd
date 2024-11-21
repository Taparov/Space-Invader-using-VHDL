----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    04:49:50 11/07/2024 
-- Design Name: 
-- Module Name:    Bullet_Deac_Con - Behavioral 
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

entity Bullet_Deac_Con is
    Port ( Plyr_blt_pos : in  STD_LOGIC_VECTOR (8 downto 0);
           A_blt_pos : in  STD_LOGIC_VECTOR (8 downto 0);
           Deac : out  STD_LOGIC_VECTOR (1 downto 0));
end Bullet_Deac_Con;

architecture Behavioral of Bullet_Deac_Con is

begin
	Deac(0) <= '1' when Plyr_blt_pos(8 downto 0) = "000000000" else '0';
	
	Deac(1) <= '1' when A_blt_pos(8 downto 0) = "111010110" else '0';

end Behavioral;

