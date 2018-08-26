library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity TL_MA is
	 Generic (N:integer := 32);
    Port ( CLK : in std_logic;
			  RST : in std_logic;
			  CS_MA_LMD_en : in std_logic;
			  TL_EC_ALU_out : in  STD_LOGIC_VECTOR (N-1 downto 0);
           TL_EC_COND_out : in  STD_LOGIC;
           TL_IF_NPC_out : in  STD_LOGIC_VECTOR (N-1 downto 0);
			  TL_ID_REGB_out : in STD_LOGIC_VECTOR (N-1 downto 0);
           TL_MA_MUX_out : out  STD_LOGIC_VECTOR (N-1 downto 0);
           TL_MA_REG_out : out  STD_LOGIC_VECTOR (N-1 downto 0);
           CS_MA_MEM_rw : in  STD_LOGIC;
			  CS_MA_MUX_sel : in std_logic;
			  CS_MA_JUMP_en : in std_logic);
			  
end TL_MA;

architecture Structural of TL_MA is

	component MUX is
    Generic (N:integer);
	 Port ( input1 : in  STD_LOGIC_VECTOR (N-1 downto 0);
           input2 : in  STD_LOGIC_VECTOR (N-1 downto 0);
           sel : in  STD_LOGIC;
           output : out  STD_LOGIC_VECTOR (N-1 downto 0));
	end component;
	
	component DATA_MEM
		generic (N:integer);
		port (RST: in std_logic;
				CLK : in std_logic;
				DATA : in std_logic_vector (N-1 downto 0);
				ADDR  : in std_logic_vector (N-1 downto 0);
				rw : in std_logic;
				OUTPUT : out std_logic_vector (N-1 downto 0));
		end component;

	component REGISTER_N is
	 GENERIC (N : INTEGER);
    Port ( CLK : in  STD_LOGIC;
           RST : in  STD_LOGIC;
			  ENABLE : in  STD_LOGIC;
           INPUT : in  STD_LOGIC_VECTOR (N-1 downto 0);
           OUTPUT : out  STD_LOGIC_VECTOR (N-1 downto 0));
		end component;
				
	signal MEM_out : std_logic_vector (N-1 downto 0);
	signal MUXB_out : std_logic;
	
begin

	MUXA:MUX generic map (N) port map (TL_IF_NPC_out,TL_EC_ALU_out,MUXB_out,TL_MA_MUX_out);
--	MUXB:MUX generic map (1) port map ('0',TL_EC_COND_out,CS_MA_JUMP_en,MUXB_out);
	MEM:DATA_MEM generic map (N) port map (RST,CLK,TL_ID_REGB_out,TL_EC_ALU_out,CS_MA_MEM_rw,MEM_out);
	LMD:REGISTER_N generic map (N) port map (CLK,RST,CS_MA_LMD_en,MEM_out,TL_MA_REG_out);
	
MUXB:process(TL_EC_COND_out,CS_MA_JUMP_en)
begin
	if CS_MA_JUMP_en = '1' then
		MUXB_out <= TL_EC_COND_out;
	else
		MUXB_out <= '0';
	end if;
end process;
end Structural;

