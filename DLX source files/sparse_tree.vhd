library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity sparse_tree is
	 generic (N : integer :=32);
    Port ( a : in  STD_LOGIC_VECTOR (N-1 downto 0);
           b : in  STD_LOGIC_VECTOR (N-1 downto 0);
			  cin : in std_logic;
           output : out  STD_LOGIC_VECTOR (N/4-1 downto 0));
end sparse_tree;

architecture Behavioral of sparse_tree is

component pg_block is
    Port ( cin : in std_logic;
			  a : in  STD_LOGIC;
           b : in  STD_LOGIC;
           g : out  STD_LOGIC;
           p : out  STD_LOGIC);
end component;

component sparse_tree_block is
	port ( p0   : in std_logic;
			 g0   : in std_logic;
			 p1   : in std_logic;
			 g1   : in std_logic;
			 p_out : out std_logic;
			 g_out : out std_logic);

end component;


signal P1 : std_logic_vector (N-1 downto 0);
signal G1 : std_logic_vector (N-1 downto 0);
signal P2 : std_logic_vector (N/2-1 downto 0);
signal G2 : std_logic_vector (N/2-1 downto 0);
signal P3 : std_logic_vector (N/4-1 downto 0);
signal G3 : std_logic_vector (N/4-1 downto 0);
signal P4 : std_logic_vector (N/8-1 downto 0);
signal G4 : std_logic_vector (N/8-1 downto 0);
signal P5,P6 : std_logic_vector (2 downto 0);
signal G5,G6 : std_logic_vector (2 downto 0);

begin
		
	B1:for i in 0 to N-1 generate
			FIRST: if(i=0) generate
				LSB_PG : pg_block port map (cin,a(i),b(i),G1(i),P1(i));
			end generate FIRST;
			OTHER: if(i>0) generate
				OTHERS_PG : pg_block port map ('0',a(i),b(i),G1(i),P1(i));
			end generate OTHER;
			
	end generate B1;
	
	B2:for i in 0 to N/2-1  generate
		BLACK_BOX1: if (i=0) generate
			SECOND_BLOCK0 : sparse_tree_block port map ('0',G1(2*i),P1(2*i+1),G1(2*i+1),P2(i),G2(i));
		end generate BLACK_BOX1;
		
		SPBLOCK : if(i>0) generate
			SECOND_BLOCK1 : sparse_tree_block port map (P1(2*i),G1(2*i),P1(2*i+1),G1(2*i+1),P2(i),G2(i));
		end generate SPBLOCK;
	end generate B2;
	
	B3:for i in 0 to N/4-1 generate
		BLACK_BOX2: if(i=0) generate
			THIRD_BLOCK0 : sparse_tree_block port map ('0',G2(2*i),P2(2*i+1),G2(2*i+1),P3(i),G3(i));
		end generate BLACK_BOX2;
		SPBLOCK1:if(i>0) generate
			THIRD_BLOCK1 : sparse_tree_block port map (P2(2*i),G2(2*i),P2(2*i+1),G2(2*i+1),P3(i),G3(i));
		end generate SPBLOCK1;
	end generate B3;
	
	B4:for i in 0 to N/8-1 generate
		BLACK_BOX3: if(i=0) generate
			FOURTH_BLOCK0 : sparse_tree_block port map ('0',G3(2*i),P3(2*i+1),G3(2*i+1),P4(i),G4(i));
		end generate BLACK_BOX3;
		SPBLOCK2:if(i>0) generate
			FOURTH_BLOCK1 : sparse_tree_block port map (P3(2*i),G3(2*i),P3(2*i+1),G3(2*i+1),P4(i),G4(i));
		end generate SPBLOCK2;
	end generate B4;
	
	FITH_BLOCK1 : sparse_tree_block port map (P4(0),G4(0),P3(2),G3(2),P5(0),G5(0));
	FITH_BLOCK2 : sparse_tree_block port map ('0',G4(0),P4(1),G4(1),P5(1),G5(1));
	FITH_BLOCK3 : sparse_tree_block port map (P4(2),G4(2),P3(6),G3(6),P5(2),G5(2));
	
	STH_BLOCK1 : sparse_tree_block port map (P5(1),G5(1),P3(4),G3(4),P6(0),G6(0));
	STH_BLOCK2 : sparse_tree_block port map (P5(1),G5(1),P4(2),G4(2),P6(1),G6(1));
	STH_BLOCK3 : sparse_tree_block port map ('0',G5(1),P5(2),G5(2),P6(2),G6(2)); 
	
	output <= G3(7)&G6(2)&G6(1)&G6(0)&G5(1)&G5(0)&G4(0)&G3(0);
	
end Behavioral;

