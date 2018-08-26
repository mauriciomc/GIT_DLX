library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity sparse_tree_block is
	port ( p0   : in std_logic;
			 g0   : in std_logic;
			 p1   : in std_logic;
			 g1   : in std_logic;
			 p_out : out std_logic;
			 g_out : out std_logic);
end sparse_tree_block;

architecture Behavioral of sparse_tree_block is

begin

p_out <= p0 and p1;
g_out <= g1 or (p1 and g0);

end Behavioral;

