library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity TL_ID is 
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
end TL_ID;

architecture Structural of TL_ID is
	
	
		
component REGISTER_N is
	 GENERIC (N : INTEGER);
    Port ( CLK : in  STD_LOGIC;
           RST : in  STD_LOGIC;
           ENABLE : in  STD_LOGIC;
           INPUT : in  STD_LOGIC_VECTOR (N-1 downto 0);
           OUTPUT : out  STD_LOGIC_VECTOR (N-1 downto 0));
end component;
	
component REGFILE 
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
end component;

component MUX is
    Generic (N:integer);
	 Port ( input1 : in  STD_LOGIC_VECTOR (N-1 downto 0);
           input2 : in  STD_LOGIC_VECTOR (N-1 downto 0);
           sel : in  STD_LOGIC;
           output : out  STD_LOGIC_VECTOR (N-1 downto 0));

end component;

	signal RB_REGA_out : std_logic_vector (N-1 downto 0);
	signal RB_REGB_out : std_logic_vector (N-1 downto 0);
	signal IMM_extended : std_logic_vector (N-1 downto 0);
	signal OUTPUT_DEP : std_logic;
	signal MUX_out : std_logic_vector(N-1 downto 0);
	signal TARGET : std_logic_vector(N-1 downto 0);
begin
		
	RB:REGFILE generic map (N) port map (CLK,RST,TL_IF_IR_S,TL_IF_IR_T,TL_IF_IR_D,CS_ID_REGF_rw,TL_WB_MUX_out,RB_REGA_out,RB_REGB_out,OUTPUT_DEP);
	
	REGA:REGISTER_N generic map (N) port map (CLK,RST,CS_ID_REGA_en,RB_REGA_out,TL_ID_REGA_out);
															
	REGB:REGISTER_N generic map (N) port map (CLK,RST,CS_ID_REGB_en,RB_REGB_out,TL_ID_REGB_out);
															
	IMM:REGISTER_N generic map (N) port map (CLK,RST,CS_ID_IMM_en,MUX_out,TL_ID_IMM_out);

	MUX1:MUX generic map (N) port map (IMM_extended,TARGET,CS_ID_MUX_sel,MUX_out);

	TARGET <= (3 downto 0 => TL_IF_TARGET(25))&TL_IF_TARGET&"00";
	
	IMM_extended <= (N-1 downto N/2 => TL_IF_IR_IMM(N/2-1)) & TL_IF_IR_IMM(N/2-1 downto 0);
end Structural;