library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ADDSUB is
    Generic(N:integer := 32);
	 Port ( A : in  STD_LOGIC_VECTOR (N-1 downto 0);
           B : in  STD_LOGIC_VECTOR (N-1 downto 0);
           SUB : in  STD_LOGIC;
           SIGN : in  STD_LOGIC;
           OV : out  STD_LOGIC;
			  Carry_out: out STD_LOGIC;
           S : out  STD_LOGIC_VECTOR (N-1 downto 0));
end ADDSUB;

architecture Behavioral of ADDSUB is

component Pentium is
	 generic (N : integer := 32);
    Port ( A : in  STD_LOGIC_VECTOR (N-1 downto 0);
           B : in  STD_LOGIC_VECTOR (N-1 downto 0);
           cin : in std_logic;
			  Sum : out  STD_LOGIC_VECTOR (N-1 downto 0);
			  carry_out : out std_logic);
end component;

signal Bi,Stemp: std_logic_vector(N-1 downto 0);
signal Cin,Cout,carry,OVtmp  : std_logic := '0';

begin

P1:process(A,B,SUB,SIGN,Cout,Stemp)
begin
	if(SIGN='0') then
		if(SUB='0') then
			OVtmp <= Cout;
			Bi <= B;
			carry<='0';
		else
			Bi <= not B;
			carry <= '1';
			if(B>A) then
				OVtmp <= '1';
			else
				OVtmp <= '0';
			end if;
		end if;
	else
		if (SUB='0') then
			Bi<=B;
			carry<='0';
		else
			Bi <= not B;
			carry <= '1';
		end if;
		
		if(A(N-1) /= Bi(N-1)) then
			Ovtmp <= '0';
		else
			if Bi(N-1) /= Stemp(N-1) then
				OVtmp <= '1';
			else
				OVtmp <= '0';
			end if;
		end if;
	end if;
end process;		
	
	
ADDER: Pentium generic map(N) port map(A,Bi,carry,Stemp,cout);		
carry_out<=cout;
OV <= OVtmp;
S<=Stemp;

end Behavioral;

