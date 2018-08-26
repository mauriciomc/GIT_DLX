library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity DLX is
	generic (N: integer := 32);	
	port ( --CLK : in std_logic;
			 --RST : in std_logic;
			 OPCODE : out std_logic_vector(5 downto 0);
			 PC	: out std_logic_vector(N-1 downto 0);
			 NPC	: out std_logic_vector(N-1 downto 0);
			 ALU	: out std_logic_vector(N-1 downto 0);
			 ALU_OP:out std_logic_vector(3 downto 0);
			 LMD	: out std_logic_vector(N-1 downto 0);
			 IR	: out std_logic_vector(N-1 downto 0));
			
end DLX;

architecture Structural of DLX is

component TL_IF is
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
end component;

component TL_ID is 
		Generic (N : integer);
		Port (CLK : in std_logic;
				RST : in std_logic;
				CS_ID_REGA_en : in std_logic;
				CS_ID_REGB_en : in std_logic;
				CS_ID_IMM_en : in std_logic;
				TL_IF_IR_S : in std_logic_vector(4 downto 0);
				TL_IF_IR_T : in std_logic_vector(4 downto 0);
				TL_IF_IR_D : in std_logic_vector(4 downto 0);
				TL_IF_IR_IMM : in std_logic_vector(N/2-1 downto 0);
				TL_WB_MUX_out : in std_logic_vector (N-1 downto 0);
				CS_ID_REGF_rw	  : in std_logic;
				TL_ID_REGA_out	  : out std_logic_vector (N-1 downto 0);
				TL_ID_REGB_out   : out std_logic_vector (N-1 downto 0);
				TL_ID_IMM_out : out std_logic_vector (N-1 downto 0);
				CS_ID_MUX_sel : in std_logic;
				TL_IF_TARGET : in std_logic_vector(25 downto 0));
end component;

component TL_MA 
	 Generic (N:integer);
    Port ( CLK : in std_logic;
			  RST : in std_logic;
			  CS_MA_LMD_en : IN STD_LOGIC;
			  TL_EC_ALU_out : in  STD_LOGIC_VECTOR (N-1 downto 0);
           TL_EC_COND_out : in  STD_LOGIC;
           TL_IF_NPC_out : in  STD_LOGIC_VECTOR (N-1 downto 0);
			  TL_ID_REGB_out : in STD_LOGIC_VECTOR (N-1 downto 0);
           TL_MA_MUX_out : out  STD_LOGIC_VECTOR (N-1 downto 0);
           TL_MA_REG_out : out  STD_LOGIC_VECTOR (N-1 downto 0);
           CS_MA_MEM_rw : in  STD_LOGIC;
			  CS_MA_MUX_sel : in std_logic;
 			  CS_MA_JUMP_en : in std_logic);
           
	end component;
	
component TL_EC
	 Generic (N : integer);
    Port ( CLK : in std_logic;
			  RST : in std_logic;
			  CS_ALUREG_en : IN STD_LOGIC;
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
			  TL_EC_ALU_out :out  STD_LOGIC_VECTOR (N-1 downto 0));

end component;

component MUX is
    Generic (N:integer);
	 Port ( input1 : in  STD_LOGIC_VECTOR (N-1 downto 0);
           input2 : in  STD_LOGIC_VECTOR (N-1 downto 0);
           sel : in  STD_LOGIC;
           output : out  STD_LOGIC_VECTOR (N-1 downto 0));

end component;

component REGISTER_N is
	 GENERIC (N : INTEGER);
    Port ( RST : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
           ENABLE : in  STD_LOGIC;
           INPUT : in  STD_LOGIC_VECTOR (N-1 downto 0);
           OUTPUT : out  STD_LOGIC_VECTOR (N-1 downto 0));
	end component;

component DLX_CU is
	 generic (N:integer);
   Port ( CLK : in STD_LOGIC;
			  RST : in STD_LOGIC;
	   	  TL_IF_IR_out : in STD_LOGIC_VECTOR(N-1 downto 0);
			  CS_IF_PC_en : out STD_LOGIC;
			  CS_IF_NPC_en : out STD_LOGIC;
			  CS_IF_IR_en : out STD_LOGIC;			  
			  CS_ID_REGA_en : out std_logic;
			  CS_ID_REGB_en : out std_logic;
			  CS_ID_IMM_en : out std_logic;	
			  CS_ID_REGF_rw: out STD_LOGIC; 
			  CS_ALUREG_en : out STD_LOGIC;
			  CS_EC_ALU_OP_in : out STD_LOGIC_VECTOR(3 downto 0);
			  CS_EC_SHAMT_in : out STD_LOGIC_VECTOR (4 downto 0);
			  CS_EC_COND_en : out STD_LOGIC_VECTOR(3 downto 0);  
			  CS_EC_MUXA_sel : out STD_LOGIC; 
			  CS_EC_MUXB_sel : out STD_LOGIC; 
			  CS_MA_LMD_en : out STD_LOGIC; 
			  CS_MA_MEM_rw : out STD_LOGIC; 
			  CS_MA_JUMP_en : out STD_LOGIC;
			  CS_WB_MUX_sel : out STD_LOGIC;
			  CS_WB2_MUX_sel : out STD_LOGIC);
end component;

component HazardControl is
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
end component;


signal CLK : std_logic:='0';
signal RST : std_logic;
	
signal TL_IF_IR_in : std_logic_vector(N-1 downto 0);
signal TL_IF_MEM_out : std_logic_vector(N-1 downto 0);
signal TL_IF_NPC_out : std_logic_vector (N-1 downto 0);
signal TL_IF_IR_out : std_logic_vector (N-1 downto 0);
signal TL_IF_IR_S : std_logic_vector (4 downto 0);
signal TL_IF_IR_T : std_logic_vector (4 downto 0);
signal TL_IF_IR_D : std_logic_vector (4 downto 0);
signal TL_IF_IR_IMM : std_logic_vector (15 downto 0);
signal TL_IF_TARGET : STD_LOGIC_VECTOR(25 downto 0);
signal TL_IF_SHAMT : STD_LOGIC_VECTOR(4 downto 0);

--signal CS_IF_MEM_rw : std_logic;
signal CS_IF_PC_en : std_logic;
signal CS_IF_NPC_en : STD_LOGIC;
signal CS_IF_IR_en : STD_LOGIC;
			  
signal TL_ID_REGA_out : std_logic_vector (N-1 downto 0);
signal TL_ID_REGB_out : std_logic_vector (N-1 downto 0);
signal TL_ID_IMM_out : std_logic_vector (N-1 downto 0);
signal CS_ID_REGF_rw : std_logic;
signal CS_ID_REGA_en : std_logic;
signal CS_ID_REGB_en : std_logic;
signal CS_ID_IMM_en : std_logic;
signal CS_ID_MUX_sel : std_logic;
				
signal TL_EC_ALU_out : std_logic_vector (N-1 downto 0);
signal TL_EC_ALU_REG_out : std_logic_vector (N-1 downto 0);
signal TL_EC_COND_out : std_logic;
signal CS_EC_ALU_OP_in : std_logic_vector (3 downto 0);
signal CS_EC_COND_en : std_logic_VECTOR(3 downto 0);
signal CS_EC_MUXA_sel : std_logic;
signal CS_EC_MUXB_sel : std_logic;
signal CS_ALUREG_en : std_logic;
signal CS_EC_SHAMT_in : std_logic_vector (4 downto 0) := (others=>'0');
			  
signal TL_MA_REG_out : std_logic_vector (N-1 downto 0);
signal TL_MA_MEM_out : std_logic_vector (N-1 downto 0);
signal TL_MA_MUX_out : std_logic_vector (N-1 downto 0);
signal CS_MA_MEM_rw : std_logic;
signal CS_MA_MUX_sel : std_logic;
signal CS_MA_LMD_en : std_logic;
signal CS_MA_JUMP_en : std_logic; 

signal TL_WB_MUX_out : std_logic_vector (N-1 downto 0);
signal TL_WB2_MUX_out : std_logic_vector (N-1 downto 0);
signal CS_WB_MUX_sel : std_logic;
signal CS_WB2_MUX_sel : std_logic;

signal TL_IF_PC_out : std_logic_vector(N-1 downto 0);
 
--PIPELINE SIGNALS FOR DATAPATH
signal TL_ID_NPC_out : std_logic_vector(N-1 downto 0);
signal TL_EC_NPC_out : std_logic_vector(N-1 downto 0);
signal TL_MA_NPC_out : std_logic_vector(N-1 downto 0);
signal TL_WB_NPC_out : std_logic_vector(N-1 downto 0);
signal TL_EC_REGB_out : std_logic_vector(N-1 downto 0);
signal ENABLE_PIPE : std_logic := '1';
signal TL_ID_IR_D : std_logic_vector(4 downto 0);
signal TL_EC_IR_D : std_logic_vector(4 downto 0);
signal TL_WB_IR_D : std_logic_vector(4 downto 0);
signal TL_ID_SHAMT : std_logic_vector(4 downto 0);
signal TL_MA_ALU_REG_out : std_logic_vector(N-1 downto 0); 
signal TL_IF_MUX_PC_out : std_logic_vector(N-1 downto 0); 
signal TL_ID_IR_S : std_logic_vector (4 downto 0);
signal TL_ID_IR_T : std_logic_vector (4 downto 0);

--HAZARD CONTROL SIGNALS
signal HC_OP_RS : STD_LOGIC_VECTOR (N-1 downto 0);
signal HC_OP_RT  : STD_LOGIC_VECTOR (N-1 downto 0);
signal HC_OP_RS_sel : STD_LOGIC;
signal HC_OP_RT_sel : STD_LOGIC;
signal HC_MUX1_out : STD_LOGIC_VECTOR (N-1 downto 0);
signal HC_MUX2_out : STD_LOGIC_VECTOR (N-1 downto 0);
 
begin


RST <= '1','0' after 20 us;

process(RST,CLK)
begin
	if(RST='1') then 
		CLK<='0';
	else
		CLK <= not CLK after 100 us;
	end if;
end process;

	OPCODE <= TL_IF_IR_out(31 downto 26);
	PC  <= TL_IF_PC_out;
	NPC <= TL_IF_NPC_out;
	IR  <= TL_IF_IR_out;
	ALU <= TL_EC_ALU_REG_out;
	ALU_OP <= CS_EC_ALU_OP_in;
	LMD <= TL_MA_REG_out;
	ENABLE_PIPE<='1';
	
	--Pipeline registers which are needed to maintain states for the correct execution of each instruction
	PIPE_NPC : REGISTER_N generic map (N) port map(RST,CLK,ENABLE_PIPE,TL_IF_NPC_out,TL_ID_NPC_out);
	PIPE_NPC2: REGISTER_N generic map (N) port map(RST,CLK,ENABLE_PIPE,TL_ID_NPC_out,TL_EC_NPC_out);
	PIPE_NPC3: REGISTER_N generic map (N) port map(RST,CLK,ENABLE_PIPE,TL_EC_NPC_out,TL_MA_NPC_out);
	PIPE_NPC4: REGISTER_N generic map (N) port map(RST,CLK,ENABLE_PIPE,TL_MA_NPC_out,TL_WB_NPC_out);
	PIPE_REGB: REGISTER_N generic map (N) port map(RST,CLK,ENABLE_PIPE,TL_ID_REGB_out,TL_EC_REGB_out);
	PIPE_RD0	: REGISTER_N generic map (5) port map(RST,CLK,ENABLE_PIPE,TL_IF_IR_D,TL_ID_IR_D);
	PIPE_RD1 : REGISTER_N generic map (5) port map(RST,CLK,ENABLE_PIPE,TL_ID_IR_D,TL_EC_IR_D);
	PIPE_RD2	: REGISTER_N generic map (5) port map(RST,CLK,ENABLE_PIPE,TL_EC_IR_D,TL_WB_IR_D);
	PIPE_SHAMT:REGISTER_N generic map (5) port map(RST,CLK,ENABLE_PIPE,TL_IF_SHAMT,TL_ID_SHAMT);
	PIPE_ALUREG : REGISTER_N generic map (N) port map(RST,CLK,ENABLE_PIPE,TL_EC_ALU_REG_out,TL_MA_ALU_REG_out);
	PIPE_RS : REGISTER_N generic map (5) port map (RST,CLK,ENABLE_PIPE,TL_IF_IR_S,TL_ID_IR_S);
	PIPE_RT : REGISTER_N generic map (5) port map (RST,CLK,ENABLE_PIPE,TL_IF_IR_T,TL_ID_IR_T);
	
	INSTRUCTION_FETCH:TL_IF generic map (N) port map (   CLK, 
																		  RST, 
																		  CS_IF_PC_en, 
																		  CS_IF_NPC_en,
																		  CS_IF_IR_en, 
																		  TL_MA_MUX_out,
																		  TL_IF_NPC_out,
																		  TL_IF_IR_in, 
																		  TL_IF_IR_out,
																		  TL_IF_MEM_out, 
																		  TL_IF_PC_out, 
																		  TL_IF_IR_S, 
																		  TL_IF_IR_T, 
																		  TL_IF_IR_D, 
																		  TL_IF_IR_IMM,
   																	  TL_IF_TARGET, 
																		  CS_ID_MUX_sel,
																		  TL_IF_SHAMT);
																		  
	INSTRUCTION_DECODE:TL_ID generic map (N) port map (CLK, 
																		RST, 
																		CS_ID_REGA_en, 
																		CS_ID_REGB_en, 
																		CS_ID_IMM_en, 
																		TL_IF_IR_S, 
																		TL_IF_IR_T, 
																		--TL_WB_IR_D, --Pipelined 
																		TL_EC_IR_D, --Pipelined 
																		TL_IF_IR_IMM, 
																		TL_WB2_MUX_out, 
																		CS_ID_REGF_rw,	  
																		TL_ID_REGA_out,	 
																		TL_ID_REGB_out, 
																		TL_ID_IMM_out,
																		CS_ID_MUX_sel,
																		TL_IF_TARGET);
	
	EXECUTE_CALCULATION:TL_EC generic map (N) port map ( CLK, 
																		  RST, 
																		  CS_ALUREG_en, 
																		  HC_MUX1_out,--TL_ID_REGA_out -- HAZARD_CONTROL 
																		  HC_MUX2_out,--TL_ID_REGB_out -- HAZARD_CONTROL 
																		  TL_ID_NPC_out, --Pipelined
																		  TL_ID_IMM_out, 
																		  TL_EC_ALU_REG_out, 
																		  TL_EC_COND_out, 
																		  CS_EC_ALU_OP_in, 
																		  TL_ID_SHAMT,	  --Pipelined
																		  --CS_EC_SHAMT_in, 
																		  CS_EC_COND_en, 
																		  CS_EC_MUXA_sel, 
																		  CS_EC_MUXB_sel, 
																		  TL_EC_ALU_out );

																		 
	MEMORY_ACCESS:TL_MA generic map (N) port map ( CLK, 
																  RST, 
																  CS_MA_LMD_en, 
																  TL_EC_ALU_REG_out,
																  TL_EC_COND_out,
																  TL_IF_NPC_out,  
																  TL_EC_REGB_out, --Pipelined reg
																  TL_MA_MUX_out,
																  TL_MA_REG_out,
																  CS_MA_MEM_rw, 
																  CS_MA_MUX_sel,
																  CS_MA_JUMP_en);
	

	WRITE_BACK:MUX generic map (N) port map (TL_MA_REG_out,     --LMD
														  TL_EC_ALU_REG_out, --pipelined reg
														  CS_WB_MUX_sel,
														  TL_WB_MUX_out);
	
	
	WRITE_BACK2:MUX generic map (N) port map(TL_WB_MUX_out,
														  TL_MA_NPC_out,     --Pipelined reg
														  CS_WB2_MUX_sel,
														  TL_WB2_MUX_out);

		
	CONTROL_UNIT:DLX_CU generic map (N) port map(  CLK, 
																  RST, 
																  --TL_IF_MEM_out, 
																  TL_IF_IR_out,
																  CS_IF_PC_en, 
																  CS_IF_NPC_en, 
																  CS_IF_IR_en, 
																  CS_ID_REGA_en, 
																  CS_ID_REGB_en, 
																  CS_ID_IMM_en, 
																  CS_ID_REGF_rw,
																  CS_ALUREG_en, 
																  CS_EC_ALU_OP_in, 
																  CS_EC_SHAMT_in,
																  CS_EC_COND_en, 
																  CS_EC_MUXA_sel,
																  CS_EC_MUXB_sel,
																  CS_MA_LMD_en, 
																  CS_MA_MEM_rw, 
																  CS_MA_JUMP_en,
																  CS_WB_MUX_sel, 
																  CS_WB2_MUX_sel); 

   HAZARD_CU:HazardControl generic map (N)
									Port map ( CLK,
												  RST,
												  TL_ID_IR_S,    --pipelined   
									   		  TL_ID_IR_T,    --pipelined
												  TL_EC_IR_D,    --pipelined1
											     TL_WB_IR_D,	  --pipelined2	  
											     TL_EC_ALU_REG_out,
											     TL_MA_ALU_REG_out,
											     HC_OP_RS,  
											     HC_OP_RT,  
											     HC_OP_RS_sel, 
											     HC_OP_RT_sel);

	HAZARD_MUX1:MUX generic map (N)
						 port map (TL_ID_REGA_out,
									  HC_OP_RS,
									  HC_OP_RS_sel,
									  HC_MUX1_out);
	
   HAZARD_MUX2:MUX generic map (N)
						 port map (TL_ID_REGB_out,
									  HC_OP_RT,
									  HC_OP_RT_sel,
									  HC_MUX2_out);	
									  
	                     
end structural;      
                    
                    
