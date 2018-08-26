library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ADD_N is
	generic (N : integer);
	port(input : in std_logic_vector (N-1 downto 0);
	     output : out std_logic_vector (N-1 downto 0));
		
end ADD_N; 

architecture Structural of ADD_N is
begin
	output <= input + "100";
end Structural;

