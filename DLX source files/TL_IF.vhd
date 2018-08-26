library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity TL_IF is
	 Generic (N : integer:=32);
    Port ( CLK : in  STD_LOGIC;
           RST : in  STD_LOGIC;
			  CS_IF_PC_en : in STD_LOGIC;
			  CS_IF_NPC_en : in STD_LOGIC;
			  CS_IF_IR_en : in STD_LOGIC;
			  TL_MA_MUX_out : in  STD_LOGIC_VECTOR (N-1 downto 0);
			  TL_IF_NPC_out : out  STD_LOGIC_VECTOR (N-1 downto 0);
			  TL_IF_IR_in : in  STD_LOGIC_VECTOR (N-1 downto 0);
           TL_IF_IR_out : out  STD_LOGIC_VECTOR (N-1 downto 0);
			  TL_IF_MEM_out : out  STD_LOGIC_VECTOR (N-1 downto 0);
			  TL_IF_PC_out : out STD_LOGIC_VECTOR(N-1 downto 0);
			  TL_IF_IR_S : out STD_LOGIC_VECTOR(4 downto 0);
			  TL_IF_IR_T : out STD_LOGIC_VECTOR(4 downto 0);
			  TL_IF_IR_D : out STD_LOGIC_VECTOR(4 downto 0);
			  TL_IF_IR_IMM : out STD_LOGIC_VECTOR(15 downto 0);
			  TL_IF_TARGET : out STD_LOGIC_VECTOR(25 downto 0);
			  CS_ID_MUX_sel: out std_logic;
			  TL_IF_SHAMT : out STD_LOGIC_VECTOR(4 downto 0));
			  
end TL_IF;

architecture Structural of TL_IF is

	component REGISTER_N is
	 GENERIC (N : INTEGER);
    Port ( CLK : in  STD_LOGIC;
           RST : in  STD_LOGIC;
			  ENABLE : in  STD_LOGIC;
           INPUT : in  STD_LOGIC_VECTOR (N-1 downto 0);
           OUTPUT : out  STD_LOGIC_VECTOR (N-1 downto 0));
	end component;
	
	component ADD_N is
		generic (N : integer);
		port(input : in std_logic_vector (N-1 downto 0);
			  output : out std_logic_vector (N-1 downto 0));
		
	end component;
	
	component INS_MEM is
		generic (N : integer);
		port (RST : in std_logic;
				CLK : in std_logic;
				address : in std_logic_vector (6 downto 0);
				data : out std_logic_vector (N-1 downto 0));
		
	end component;
	
	
	component IREGISTER is
	generic (N:integer);
   Port ( CLK : in  STD_LOGIC;
           RST : in  STD_LOGIC;
           ENABLE : in  STD_LOGIC;
           INPUT : in  STD_LOGIC_VECTOR (31 downto 0);
           OUTPUT : out  STD_LOGIC_VECTOR (31 downto 0);
			  IR_S : out  STD_LOGIC_VECTOR (4 downto 0);
			  IR_T : out  STD_LOGIC_VECTOR (4 downto 0);
			  IR_D : out  STD_LOGIC_VECTOR (4 downto 0);
			  IR_IMM : out  STD_LOGIC_VECTOR (15 downto 0);
			  IR_TARGET : out std_logic_vector(25 downto 0);
			  CS_ID_MUX_sel : out std_logic;
			  IR_SHAMT : out std_logic_vector (4 downto 0));
	
	end component;
	
	component NPCREG is
   generic (N:integer:=32); 
	Port ( CLK : in  STD_LOGIC;
           RST : in  STD_LOGIC;
			  EN : in  STD_LOGIC;
           INPUT : in  STD_LOGIC_VECTOR (N-1 downto 0);
           OUTPUT : out  STD_LOGIC_VECTOR (N-1 downto 0));
	end component;


	
	signal PC_out : std_logic_vector (N-1 downto 0);
	signal MEM_out : std_logic_vector (N-1 downto 0);
	signal ADD_out : std_logic_vector (N-1 downto 0);
	signal NPC_out : std_logic_vector (N-1 downto 0);
	signal IR_out : std_logic_vector (N-1 downto 0);
	
	
begin
   		
	PC:REGISTER_N generic map (N) port map (CLK,RST,CS_IF_PC_en,TL_MA_MUX_out,PC_out);
														 
	IR:IREGISTER generic map (N) port map (CLK,RST,CS_IF_IR_en,MEM_out,TL_IF_IR_out,TL_IF_IR_S,TL_IF_IR_T,TL_IF_IR_D,TL_IF_IR_IMM,TL_IF_TARGET,CS_ID_MUX_sel,TL_IF_SHAMT);
	
	NPC:REGISTER_N generic map (N) port map (not(CLK),RST,CS_IF_NPC_en,ADD_out,TL_IF_NPC_out);
	
	ADDER:ADD_N generic map (N) port map (PC_out,ADD_out);
	
	MEM:INS_MEM generic map (N) port map (RST,CLK,PC_out(6 downto 0),MEM_out);
	
	TL_IF_MEM_out <= MEM_out;
	TL_IF_PC_out <= PC_out;
	
end Structural; 
