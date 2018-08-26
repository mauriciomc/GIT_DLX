library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity VER_ZERO is
	 Generic (N:integer);
    Port ( input : in  STD_LOGIC_VECTOR (N-1 downto 0);
           output : out  STD_LOGIC);
end VER_ZERO;

architecture Behavioral of VER_ZERO is
begin
	p1:process(input)
	begin
		if (input = (N-1 downto 0=>'0')) then
			output <= '1';
		else
			output <= '0';
		end if;
	end process;
end Behavioral;

