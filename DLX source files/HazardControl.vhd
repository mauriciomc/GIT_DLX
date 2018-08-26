library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity HazardControl is
	 generic (N:integer := 32);
    Port ( CLK : in std_logic;
			  RST : in std_logic;
			  OP_RS     : in  STD_LOGIC_VECTOR (4 downto 0);
           OP_RT     : in  STD_LOGIC_VECTOR (4 downto 0);
           OP_RD1    : in  STD_LOGIC_VECTOR (4 downto 0);
           OP_RD2    : in  STD_LOGIC_VECTOR (4 downto 0);
           ALU1      : in  STD_LOGIC_VECTOR (N-1 downto 0);
           ALU2      : in  STD_LOGIC_VECTOR (N-1 downto 0);
           OP_HC_RS  : out  STD_LOGIC_VECTOR (N-1 downto 0);
           OP_HC_RT  : out  STD_LOGIC_VECTOR (N-1 downto 0);
           OP_RS_sel : out  STD_LOGIC;
           OP_RT_sel : out  STD_LOGIC);
end HazardControl;

architecture Behavioral of HazardControl is

begin

RAW_OP1:process(OP_RS,OP_RD1,OP_RD2,ALU1,ALU2,RST)
begin
	if(RST='1') then
		OP_HC_RS <= (others => '0');
		OP_RS_sel <= '0';
	else--if(CLK'event and CLK='1') then
		if(OP_RS = OP_RD1 and OP_RS /= 0) then
			OP_HC_RS <= ALU1;
			OP_RS_sel <= '1';
	
		elsif(OP_RS = OP_RD2 and OP_RS /= 0) then
			OP_HC_RS <= ALU2;
			OP_RS_sel <= '1';
	
		else
			OP_RS_sel <= '0';

		end if;
	end if;
end process;

RAW_OP2:process(OP_RT,OP_RD1,OP_RD2,ALU1,ALU2,RST)
begin
	if(RST='1') then
		OP_HC_RT <= (others => '0');
		OP_RT_sel <= '0';
	else--(CLK'event and CLK='1') then
		if(OP_RT = OP_RD1 and OP_RT /= 0) then
			OP_HC_RT <= ALU1;
			OP_RT_sel <= '1';
	
		elsif(OP_RT = OP_RD2 and OP_RT /= 0) then
			OP_HC_RT <= ALU2;
			OP_RT_sel <= '1';
		else
			OP_RT_sel <= '0';
		end if;
	end if;
end process;


end Behavioral;

