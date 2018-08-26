library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity CONDITION_CHECK is
	 Generic (N:integer:=32);
    Port ( VER_ZERO_out : in  STD_LOGIC;
           CS_COND_en : in  STD_LOGIC_VECTOR(3 downto 0);
           TL_ID_REGA_out : in  STD_LOGIC_VECTOR (N-1 downto 0);
           TL_ID_REGB_out : in STD_LOGIC_VECTOR(N-1 downto 0);
			  COND_out : out  STD_LOGIC;
			  CLK : in STD_LOGIC;
			  RST : in std_logic);
end CONDITION_CHECK;

architecture Behavioral of CONDITION_CHECK is

component Comparator is
	 generic(N:integer:=32);
    Port ( A : in  STD_LOGIC_VECTOR (N-1 downto 0);
           B : in  STD_LOGIC_VECTOR (N-1 downto 0);
           SIGN : in  STD_LOGIC;
           CMP_LT : out  STD_LOGIC;
           CMP_GT : out  STD_LOGIC;
           CMP_EQ : out  STD_LOGIC);
end component;


component REGISTER_N is
	 GENERIC (N : INTEGER);
    Port ( CLK : in  STD_LOGIC;
           RST : in  STD_LOGIC;
           ENABLE : in  STD_LOGIC;
           INPUT : in  STD_LOGIC_VECTOR (N-1 downto 0);
           OUTPUT : out  STD_LOGIC_VECTOR (N-1 downto 0));
end component;


signal CMP_LT,CMP_GT,CMP_EQ : std_logic;
signal COND_out_tmp : std_logic;
signal TL_ID_REGA_out_tmp,TL_ID_REGB_out_tmp : std_logic_vector(N-1 downto 0); 
begin

COMP1:Comparator generic map (N) port map (TL_ID_REGA_out,TL_ID_REGB_out,'1',CMP_LT,CMP_GT,CMP_EQ); 
--COMP2:Comparator generic map (N) port map (TL_ID_REGA_out,TL_ID_REGB_out,'1',CMP_LT1,CMP_GT1,CMP_EQ1); 

CHECK:process(CLK,VER_ZERO_out,CS_COND_en,TL_ID_REGA_out,TL_ID_REGB_out,CMP_LT,CMP_GT,CMP_EQ)
begin
	case CS_COND_en is
		when "1111" => COND_out <= VER_ZERO_out;           -- for jumps (Rs must be Regs[0])
		when "0100" => COND_out <= CMP_EQ;						-- Rs =  Rt
		when "0110" => COND_out <= CMP_GT or CMP_EQ;       -- Rs >= 0   (Rt must be Regs[0])
		when "0111" => COND_out <= CMP_GT;					   -- Rs >  0	 (Rt must be Regs[0])
		when "0001" => COND_out <= CMP_LT or CMP_EQ;       -- Rs <= 0   (Rt must be Regs[0])
		when "0011" => COND_out <= CMP_LT;					   -- Rs <  0   (Rt must be 00001 )
		when "0101" => COND_out <= not CMP_EQ;             -- Rs != Rt
		when others => COND_out <= '0';
	end case;
end process;
end Behavioral;
