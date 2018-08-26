library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MUX is
    Generic (N:integer);
	 Port ( input1 : in  STD_LOGIC_VECTOR (N-1 downto 0);
           input2 : in  STD_LOGIC_VECTOR (N-1 downto 0);
           sel : in  STD_LOGIC;
           output : out  STD_LOGIC_VECTOR (N-1 downto 0));
end MUX;

architecture Behavioral of MUX is
begin
process (input1,input2,sel)
	begin
		 if sel = '0' then
			output <= input1;
		 elsif sel = '1' then
			output <= input2;
		 end if;
end process;
end Behavioral;

