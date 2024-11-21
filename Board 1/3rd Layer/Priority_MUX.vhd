----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:27:31 11/07/2024 
-- Design Name: 
-- Module Name:    Priority_MUX - Behavioral 
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

entity Priority_MUX is
    Port ( N1 : in  STD_LOGIC_VECTOR (8 downto 0);
           N2 : in  STD_LOGIC_VECTOR (8 downto 0);
           N3 : in  STD_LOGIC_VECTOR (8 downto 0);
           N4 : in  STD_LOGIC_VECTOR (8 downto 0);
           s1 : in  STD_LOGIC;
           s2 : in  STD_LOGIC;
           s3 : in  STD_LOGIC;
           s4 : in  STD_LOGIC;
           Q : out  natural range 0 to 498);
end Priority_MUX;

architecture Behavioral of Priority_MUX is
	
	signal nat1,nat2,nat3,nat4 : natural range 0 to 498;
begin
	nat1 <= to_integer(unsigned(N1));
	nat2 <= to_integer(unsigned(N2));
	nat3 <= to_integer(unsigned(N3));
	nat4 <= to_integer(unsigned(N4));
	
	Q <= nat1 when s1 = '1' else
		  nat2 when s2 = '1' else
		  nat3 when s3 = '1' else
		  nat4 when s4 = '1' else
		  0;

end Behavioral;

