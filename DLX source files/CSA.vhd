library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity CSA is
	Port ( A : in  STD_LOGIC_VECTOR (3 downto 0);
          B : in  STD_LOGIC_VECTOR (3 downto 0);
          Cin : in  STD_LOGIC;
          S : out  STD_LOGIC_VECTOR (3 downto 0);
			 Cout : out STD_LOGIC);
end CSA;

architecture Behavioral of CSA is

component CLA is
	Port ( A : in  STD_LOGIC_VECTOR (3 downto 0);
          B : in  STD_LOGIC_VECTOR (3 downto 0);
          Cin : in  STD_LOGIC;
          S : out  STD_LOGIC_VECTOR (3 downto 0);
          Cout : out  STD_LOGIC);
end component;

signal output_0,output_1 : std_logic_vector (3 downto 0);
signal couts : std_logic_vector (1 downto 0);

begin

CLA0:CLA port map (A,B,'0',output_0,couts(0));
CLA1:CLA port map (A,B,'1',output_1,couts(1));

behav_mux:process(A,B,Cin,output_0,output_1,couts(0),couts(1))
begin
	case Cin is
		when '0' => S <= output_0; Cout<=couts(0);
		when others => S <= output_1; Cout<=couts(1);
	end case;
end process;

end Behavioral;