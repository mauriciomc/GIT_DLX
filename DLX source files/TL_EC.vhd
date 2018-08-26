library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity TL_EC is
	 Generic (N : integer:=32);
    Port ( CLK : in std_logic;
			  RST : in std_logic;
			  CS_ALUREG_en : in std_logic;
			  TL_ID_REGA_out : in  STD_LOGIC_VECTOR (N-1 downto 0);
           TL_ID_REGB_out : in  STD_LOGIC_VECTOR (N-1 downto 0);
           TL_IF_NPC_out : in  STD_LOGIC_VECTOR (N-1 downto 0);
           TL_ID_IMM_out : in  STD_LOGIC_VECTOR (N-1 downto 0);
			  TL_EC_ALU_REG_out : out  STD_LOGIC_VECTOR (N-1 downto 0);
           TL_EC_COND_out : out  STD_LOGIC;
			  CS_EC_ALU_OP_in : in STD_LOGIC_VECTOR (3 downto 0);
			  CS_EC_SHAMT_in : in STD_LOGIC_VECTOR (4 downto 0);
           CS_EC_COND_en : in STD_LOGIC_VECTOR(3 downto 0);
			  CS_EC_MUXA_sel : in std_logic;
			  CS_EC_MUXB_sel : in std_logic;
			  TL_EC_ALU_out :out  STD_LOGIC_VECTOR (N-1 downto 0) );
end TL_EC;

architecture Structural of TL_EC is

Component VER_ZERO
	Generic (N : integer);
	Port ( input : in std_logic_vector (N-1 downto 0);
			 output : out std_logic);

end component;

Component MUX is
    Generic (N:integer);
	 Port ( input1 : in  STD_LOGIC_VECTOR (N-1 downto 0);
           input2 : in  STD_LOGIC_VECTOR (N-1 downto 0);
           sel : in  STD_LOGIC;
           output : out  STD_LOGIC_VECTOR (N-1 downto 0));
	
end component;


component alu_structural is
  generic (N : integer := 32);
  port 	 ( DATA1 : IN std_logic_vector(N-1 downto 0); 
				DATA2: IN std_logic_vector(N-1 downto 0);
				FUNC : IN std_logic_vector(3 downto 0);
				SHAMT : IN std_logic_vector(4 downto 0);
				OUTALU: OUT std_logic_vector(N-1 downto 0));

end component;

COMPONENT REGISTER_N 
	 GENERIC (N : INTEGER);
    Port ( CLK : in  STD_LOGIC;
           RST : in  STD_LOGIC;
           ENABLE : in  STD_LOGIC;
           INPUT : in  STD_LOGIC_VECTOR (N-1 downto 0);
           OUTPUT : out  STD_LOGIC_VECTOR (N-1 downto 0));
end COMPONENT;

component CONDITION_CHECK is
	 Generic (N:integer:=32);
    Port ( VER_ZERO_out : in  STD_LOGIC;
           CS_COND_en : in  STD_LOGIC_VECTOR(3 downto 0);
           TL_ID_REGA_out : in  STD_LOGIC_VECTOR (N-1 downto 0);
           TL_ID_REGB_out : in STD_LOGIC_VECTOR(N-1 downto 0);
			  COND_out : out  STD_LOGIC;
			  CLK : in STD_LOGIC;
			  RST : in std_logic);
end component;
		
signal VER_ZERO_out : std_logic;
signal MUXA_out : std_logic_vector (N-1 downto 0);
signal MUXB_out : std_logic_vector (N-1 downto 0);
signal ALU_out : std_logic_vector (N-1 downto 0);
signal COND_out : std_logic_vector (N-1 downto 0);
signal ALU_REG_out : std_logic_vector (N-1 downto 0);
signal TL_EC_REGA_out : std_logic_vector (N-1 downto 0);
signal TL_EC_REGB_out : std_logic_vector (N-1 downto 0);
begin
	
	REGA_PIPE:REGISTER_N generic map (N) port map (CLK,RST,'1',TL_ID_REGA_out,TL_EC_REGA_out);
	REGB_PIPE:REGISTER_N generic map (N) port map (CLK,RST,'1',TL_ID_REGB_out,TL_EC_REGB_out);
	ZERO:VER_ZERO generic map (N) port map (TL_ID_REGA_out,VER_ZERO_out);
	MUXA:MUX generic map (N) port map (TL_IF_NPC_out,TL_ID_REGA_out,CS_EC_MUXA_sel,MUXA_out);
	MUXB:MUX generic map (N) port map (TL_ID_REGB_out,TL_ID_IMM_out,CS_EC_MUXB_sel,MUXB_out);
	ALU:alu_structural generic map (N) port map (MUXA_out,MUXB_out,CS_EC_ALU_OP_in,CS_EC_SHAMT_in,ALU_out);
	ALU_OUTPUT:REGISTER_N generic map (N) port map (CLK,RST,CS_ALUREG_en,ALU_out,ALU_REG_out);
	TL_EC_ALU_out <= ALU_out;
	TL_EC_ALU_REG_out <= ALU_REG_out;
	COND:CONDITION_CHECK port map (VER_ZERO_out,CS_EC_COND_en,TL_EC_REGA_out,TL_EC_REGB_out,TL_EC_COND_out,CLK,RST);

end Structural;

