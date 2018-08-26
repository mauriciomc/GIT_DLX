library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity NPCREG is
	  generic (N:integer:=32); 
    Port ( CLK : in  STD_LOGIC;
           RST : in  STD_LOGIC;
			  EN : in  STD_LOGIC;
           INPUT : in  STD_LOGIC_VECTOR (N-1 downto 0);
           OUTPUT : out  STD_LOGIC_VECTOR (N-1 downto 0));
end NPCREG;

architecture Behavioral of NPCREG is

begin
process(CLK,RST)
begin
if(RST='1') then
	OUTPUT<=(N-1 downto 3=>'0')&"100";
elsif(CLK'event and CLK='1') then
	if(EN='1') then
		OUTPUT<=INPUT;
	end if;
end if;
end process;
end Behavioral;

