library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity REGFILE is
	 generic(N:integer:=32);
    Port ( CLK : in  STD_LOGIC;
           RST : in  STD_LOGIC; 
           PORT_S_ADDR : in  STD_LOGIC_VECTOR (4 downto 0);
           PORT_T_ADDR : in  STD_LOGIC_VECTOR (4 downto 0);
           PORT_D_ADDR : in  STD_LOGIC_VECTOR (4 downto 0);
           WRITE_D_EN : in  STD_LOGIC;
           PORT_D_IN : in  STD_LOGIC_VECTOR (N-1 downto 0);
           PORT_S_OUT : out  STD_LOGIC_VECTOR (N-1 downto 0);
           PORT_T_OUT : out  STD_LOGIC_VECTOR (N-1 downto 0);
           OUTPUT_DEP : out  STD_LOGIC);
end REGFILE;

architecture Structural of REGFILE is

component REGISTER_N is
	 Generic(N:integer);
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           enable : in  STD_LOGIC;
           input : in  STD_LOGIC_VECTOR (N-1 downto 0);
           output : out  STD_LOGIC_VECTOR (N-1 downto 0));
end component;

subtype register_address is natural range 0 to 31;
type register_array is array (register_address) of std_logic_vector(N-1 downto 0);

--Create array of signals 
signal reg_i : register_array; 
signal en  : std_logic_vector (31 downto 0) := (others=>'0') ;


begin

--Make as if reg[0]="000000...00" ALWAYS
reg_i(0)<=(others=>'0');

--Generates 30 registers
GEN:for i in 1 to 31 generate
	REGBANK:REGISTER_N generic map(32) port map(CLK,RST,en(i),PORT_D_IN,reg_i(i));
	end generate;

--Enables only the selected registers, specified by PORT_D_ADDR, which will receive the input data to store
--No need to insert RST because they are reseted at RTL level on each register
P1:process(RST,CLK,WRITE_D_EN,PORT_D_ADDR)
begin
	if(RST='1') then
		en<=(others=>'0');
	
	elsif(CLK'event and CLK='0') then
		if(WRITE_D_EN='1') then
				en<=(others=>'0');
				en(conv_integer(unsigned(PORT_D_ADDR)))<='1';
		else
			en<=(others=>'0');
		end if;
	end if;
end process;

--Always send output values from PORT_S and PORT_T selected by Instruction Register 	
PORT_S_OUT<=reg_i(conv_integer(unsigned(PORT_S_ADDR)));
PORT_T_OUT<=reg_i(conv_integer(unsigned(PORT_T_ADDR)));
		
end Structural;