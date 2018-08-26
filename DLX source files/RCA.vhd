library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity RCA is
    Generic (N:integer);
	 Port ( A : in  STD_LOGIC_VECTOR (N-1 downto 0);
           B : in  STD_LOGIC_VECTOR (N-1 downto 0);
           Cin : in  STD_LOGIC;
           S : out  STD_LOGIC_VECTOR (N-1 downto 0);
           Cout : out  STD_LOGIC);
end RCA;

architecture Behavioral of RCA is

component CLA is
    Port ( A : in  STD_LOGIC_VECTOR (3 downto 0);
           B : in  STD_LOGIC_VECTOR (3 downto 0);
           Cin : in  STD_LOGIC;
           S : out  STD_LOGIC_VECTOR (3 downto 0);
           Cout : out  STD_LOGIC);
end component;

signal Cii : std_logic_vector ((N-1)/4 downto 0);
signal Coi : std_logic_vector ((N-1)/4 downto 0);

begin

	G1:for i in 0 to (N/4)-1 generate
		NAdder:CLA port map(A((i*4)+3 downto i*4),B((i*4)+3 downto i*4),Cii(i),S((i*4)+3 downto i*4),Coi(i));
		end generate G1;
	
	NAdder_signals:
	process(A,B,Cin,Cii,Coi)
	begin
		Cii(0) <= Cin;
		for i in 1 to N/4 - 1 loop
			Cii(i)<=Coi(i-1);
		end loop;
		Cout <= Coi(N/4-1);
	end process NAdder_signals;
end Behavioral;