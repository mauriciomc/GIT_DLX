library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Reg is
	 Generic(N:integer);
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           enable : in  STD_LOGIC;
           input : in  STD_LOGIC_VECTOR (N-1 downto 0);
           output : out  STD_LOGIC_VECTOR (N-1 downto 0));
end Reg;

architecture Structural of Reg is

component ff is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           enable : in  STD_LOGIC;
           input : in  STD_LOGIC;
           output : out  STD_LOGIC);
end component;

begin

GEN:for i in 0 to N-1 generate 
	Flip_Flop:ff port map(clk,rst,enable,input(i),output(i));
end generate;

end Structural;

