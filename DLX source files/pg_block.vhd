library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity pg_block is
    Port ( cin : in STD_LOGIC;
			  a : in  STD_LOGIC;
           b : in  STD_LOGIC;
           g : out  STD_LOGIC;
           p : out  STD_LOGIC);
end pg_block;

architecture Behavioral of pg_block is

begin

p <= a xor b xor cin;
g <= (a and b) or ((a xor b) and cin);


end Behavioral;

