library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_DLX is
	generic(N:integer:=32);
end tb_DLX;

architecture Testbench of tb_DLX is

component DLX1 is
	generic (N: integer := 32);	
	port ( CLK : in std_logic;
			 RST : in std_logic;
			 OPCODE : out std_logic_vector(5 downto 0);
			 PC	: out std_logic_vector(N-1 downto 0);
			 NPC	: out std_logic_vector(N-1 downto 0);
			 ALU	: out std_logic_vector(N-1 downto 0);
			 ALU_OP:out std_logic_vector(3 downto 0);
			 LMD	: out std_logic_vector(N-1 downto 0);
			 IR	: out std_logic_vector(N-1 downto 0));
			
end component;

signal CLK : std_logic;
signal RST : std_logic;
signal OPCODE : std_logic_vector(5 downto 0);
signal PC	: std_logic_vector(N-1 downto 0);
signal NPC	: std_logic_vector(N-1 downto 0);
signal ALU	: std_logic_vector(N-1 downto 0);
signal ALU_OP:std_logic_vector(3 downto 0);
signal LMD	: std_logic_vector(N-1 downto 0);
signal IR	: std_logic_vector(N-1 downto 0);

begin

RST <= '1','0' after 20 us;

process(RST,CLK)
begin
	if(RST='1') then 
		CLK<='0';
	else
		CLK <= not CLK after 10 us;
	end if;
end process;

MIPS:DLX1 generic map(N) port map(CLK,RST,OPCODE,PC,NPC,ALU,ALU_OP,LMD,IR);

end Testbench;

