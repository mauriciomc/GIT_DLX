library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity BOOTHMUL is
	 generic (N:integer := 32);
    Port ( A : in  STD_LOGIC_VECTOR (N-1 downto 0);
           B : in  STD_LOGIC_VECTOR (N-1 downto 0);
           Y : out  STD_LOGIC_VECTOR (N-1 downto 0));
end BOOTHMUL;

architecture Behavioral of BOOTHMUL is

component MUX_5x1 is
    Generic (N:integer := 8);
				 
    Port ( A : in  STD_LOGIC_VECTOR (N-1 downto 0);
           S : in  STD_LOGIC_VECTOR (2 downto 0);
			  A2 : out STD_LOGIC_VECTOR (N-1 downto 0);
           Y : out  STD_LOGIC_VECTOR (N-1 downto 0));
end component;

component ADDSUB is
    Generic(N:integer := 8);
	 Port ( A : in  STD_LOGIC_VECTOR (N-1 downto 0);
           B : in  STD_LOGIC_VECTOR (N-1 downto 0);
           SUB : in  STD_LOGIC;
           SIGN : in  STD_LOGIC;
           OV : out  STD_LOGIC;
           S : out  STD_LOGIC_VECTOR (N-1 downto 0));
end component;

type A2_vec is array (N/2 downto 0) of std_logic_vector (N-1 downto 0);
type out_vector_sum is array (N/2  downto 0) of std_logic_vector (N-1 downto 0);


signal Stemp : std_logic_vector (N downto 0) := (others=>'0');
signal A2_vector : A2_vec; 
signal out_vector : out_vector_sum;
signal out_sum : out_vector_sum; 
signal OV_i:std_logic_vector(N-1 downto 0);

begin
Stemp <= B&'0';
A2_vector(0)<=A;
out_sum(0)<= out_vector(0);

gena:for i in 0 to N/2-1 generate
		muxes:MUX_5x1 generic map (N) port map (A2_Vector(i),Stemp(((i+1)*2) downto i*2),A2_Vector(i+1),out_vector(i));
			
    end generate;

genb:for i in 0 to N/2-1 generate
		adders:ADDSUB generic map (N) port map (out_vector(i+1),out_sum(i),'0','0',OV_i(i),out_sum(i+1));
	 end generate;
			
Y <= out_sum(N/2-1);

end Behavioral;

