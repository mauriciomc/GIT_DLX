library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity REGISTER_N is
	 GENERIC (N : INTEGER);
    Port ( CLK : in  STD_LOGIC;
           RST : in  STD_LOGIC;
			  ENABLE : in  STD_LOGIC;
           INPUT : in  STD_LOGIC_VECTOR (N-1 downto 0);
           OUTPUT : out  STD_LOGIC_VECTOR (N-1 downto 0));
end REGISTER_N;

architecture Behavioral of REGISTER_N is

component ff is
    Port ( CLK : in  STD_LOGIC;
           RST : in  STD_LOGIC;
			  input : in  STD_LOGIC;
           enable : in  STD_LOGIC;
           output : out  STD_LOGIC);
end component;


begin

G1: for X in 0 to N-1 generate
	REG:ff port map(CLK,RST,INPUT(X),ENABLE,OUTPUT(X));
	end generate G1;

end Behavioral;
