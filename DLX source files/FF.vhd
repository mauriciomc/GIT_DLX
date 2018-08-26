library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ff is
    Port ( CLK : in  STD_LOGIC;
           RST : in  STD_LOGIC;
           input : in  STD_LOGIC;
           enable : in  STD_LOGIC;
           output : out  STD_LOGIC);
end ff;

architecture Behavioral of ff is

begin
P1:process(CLK,RST)
begin
	if(RST='1') then
		output<='0';
	
	elsif(CLK='1' and CLK'event) then
			if(enable = '1') then
				output <= input;
			end if;
		
	end if;

end process;
end Behavioral;
