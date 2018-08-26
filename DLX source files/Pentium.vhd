library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Pentium is
	 generic (N : integer := 32);
    Port ( A : in  STD_LOGIC_VECTOR (N-1 downto 0);
           B : in  STD_LOGIC_VECTOR (N-1 downto 0);
           cin : in std_logic;
			  Sum : out  STD_LOGIC_VECTOR (N-1 downto 0);
			  carry_out : out STD_LOGIC);
end Pentium;

architecture Behavioral of Pentium is

component CLA is
    Port ( A : in  STD_LOGIC_VECTOR (3 downto 0);
           B : in  STD_LOGIC_VECTOR (3 downto 0);
           Cin : in  STD_LOGIC;
           S : out  STD_LOGIC_VECTOR (3 downto 0);
           Cout : out  STD_LOGIC);
end component;

component sparse_tree is
	 generic (N : integer :=32);
    Port ( a : in  STD_LOGIC_VECTOR (N-1 downto 0);
           b : in  STD_LOGIC_VECTOR (N-1 downto 0);
           cin : in std_logic;
			  output : out  STD_LOGIC_VECTOR (N/4-1 downto 0));
end component;

component CSA is
	Port ( A : in  STD_LOGIC_VECTOR (3 downto 0);
          B : in  STD_LOGIC_VECTOR (3 downto 0);
          Cin : in  STD_LOGIC;
          S : out  STD_LOGIC_VECTOR (3 downto 0);
			 Cout : out STD_LOGIC);
end component;

signal Cout : std_logic_vector(N/4-1 downto 0); 
signal couts : std_logic_vector(N/4-1 downto 0); 

begin

stree:sparse_tree generic map (N) port map (A,B,Cin,Cout);

ADD0 : CSA port map (A(3 downto 0),B(3 downto 0),Cin,Sum(3 downto 0),couts(0));

ADDERS:for i in 1 to N/4 - 1 generate
			GEN1:CSA port map (A(i*4+3 downto i*4),B(i*4+3 downto i*4),Cout(i-1),Sum(i*4+3 downto i*4),couts(i));
		 end generate;

carry_out<=couts(N/4-1);

end Behavioral;
