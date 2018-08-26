library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity CLA is
    Port ( A : in  STD_LOGIC_VECTOR (3 downto 0);
           B : in  STD_LOGIC_VECTOR (3 downto 0);
           Cin : in  STD_LOGIC;
           S : out  STD_LOGIC_VECTOR (3 downto 0);
           Cout : out  STD_LOGIC);
end CLA;

architecture Behavioral of CLA is

component FullAdder is
    Port ( A : in  STD_LOGIC;
           B : in  STD_LOGIC;
           Cin : in  STD_LOGIC;
           S : out  STD_LOGIC;
			  G : out STD_LOGIC;
			  P : out STD_LOGIC);
end component;


signal Si : std_logic_vector(3 downto 0);
signal Gi : std_logic_vector(3 downto 0);
signal Pi : std_logic_vector(3 downto 0);
signal Cii : std_logic_vector(4 downto 0);

begin
	G1:for i in 0 to 3 generate
		adder:FullAdder port map(A(i),B(i),Cii(i),Si(i),Gi(i),Pi(i));
	end generate G1;
	
signals:
process(A,B,Cin,Si,Gi,Pi,Cii)
	begin
		Cii(0)<=Cin;
		Cii(1)<=Gi(0) or (Cii(0) and Pi(0));
		Cii(2)<=Gi(1) or (Gi(0) and Pi(1)) or (Cii(0) and Pi(1) and Pi(0));
		Cii(3)<=Gi(2) or (Gi(1) and Pi(2)) or (Gi(0) and Pi(2) and Pi(1)) or (Cii(0) and Pi(2) and Pi(1) and Pi(0));
		Cii(4)<=Gi(3) or (Gi(2) and Pi(3)) or (Gi(1) and Pi(3) and Pi(2)) or (Gi(0) and Pi(3) and Pi(2) and Pi(1)) or (Cii(0) and Pi(3) and Pi(2) and Pi(1) and Pi(0));
	end process signals;

	Cout<=Cii(4);
	S<=Si;		

end Behavioral;

