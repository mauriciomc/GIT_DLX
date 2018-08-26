library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity DATA_MEM is
	generic (N:integer);
	port (RST : in std_logic;
			CLK : in std_logic;
			DATA : in std_logic_vector (N-1 downto 0);
			ADDR  : in std_logic_vector (N-1 downto 0);
			rw : in std_logic;
			OUTPUT : out std_logic_vector (N-1 downto 0));
	
end DATA_MEM;

architecture Behavioral of DATA_MEM is


type mem_block is array (0 to 31) of std_logic_vector(N-1 downto 0);

signal mem:mem_block;

begin

P1:process(RST,rw,ADDR,DATA)
begin
	if (RST='1') then
		for x in 0 to 31 loop
			mem(x)<=(others=>'0');
		end loop;
	elsif(rw = '1') then
			mem(conv_integer(unsigned((ADDR(4 downto 0))))) <= DATA;
	end if;		
end process;
		OUTPUT <= mem(conv_integer(unsigned(ADDR(4 downto 0))));
end Behavioral;

