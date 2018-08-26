library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MUX_5x1 is
    Generic (N:integer := 8);
    Port ( A : in  STD_LOGIC_VECTOR (N-1 downto 0);
           S : in  STD_LOGIC_VECTOR (2 downto 0);
           A2 : out STD_LOGIC_VECTOR (N-1 downto 0);
			  Y : out  STD_LOGIC_VECTOR (N-1 downto 0));
end MUX_5x1;

architecture Behavioral of MUX_5x1 is

begin

A2 <= A(N-3 downto 0)&"00";
	
MUX:process(A,S)
begin
	case S is
		when "000" => Y <= (others=>'0');
		when "001" => Y <= A;--&(N-1 downto 0=>'0');
		when "010" => Y <= A;--&(N-1 downto 0=>'0');
		when "011" => Y <= A(N-2 downto 0)&'0';
		when "100" => Y <= (not(A(N-2 downto 0)&'0')+'1');
		when "101" => Y <= (not(A)+'1')&'0';
		when "110" => Y <= (not(A)+'1')&'0';
		when "111" => Y <= (others=>'0');
		when others => Y <= (others=>'0');
	end case;
end process;


end Behavioral;

