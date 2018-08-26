
--*****  This is a very wise Control Unit because it tries to use as little logic as possible to produce
--       the correct functioning of the DLX.
--       We tried using the OPCODE and the FUNC spaces in the Intruction word to produce the correct 
--       signals for ALU and other signals. Thus, its physical area should be as little as possible aswell.   

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity DLX_CU is
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
end DLX_CU;

architecture Behavioral of DLX_CU is

signal opcode : STD_LOGIC_VECTOR(5 downto 0);
signal func : STD_LOGIC_VECTOR(5 downto 0);
signal shamt : STD_LOGIC_VECTOR(4 downto 0);
signal imm : STD_LOGIC_VECTOR(15 downto 0);

signal CS_IF_NPC_en_tmp	  : std_logic := '0'; 		
signal CS_IF_IR_en_tmp	  : std_logic := '0';
signal CS_IF_PC_en_tmp	  : std_logic := '0';
signal CS_ID_REGA_en_tmp  : std_logic := '0';
signal CS_ID_REGB_en_tmp  : std_logic := '0';
signal CS_ID_IMM_en_tmp	  : std_logic := '0';
signal CS_MA_JUMP_en_tmp  : std_logic := '0';
signal CS_EC_MUXA_sel_tmp : std_logic := '0';
signal CS_EC_MUXB_sel_tmp : std_logic := '0';
signal CS_ALUREG_en_tmp   : std_logic := '0';
signal CS_ID_REGF_rw_tmp  : std_logic := '0';
signal CS_MA_LMD_en_tmp   : std_logic := '0';
signal CS_MA_MEM_rw_tmp	  : std_logic := '0';
signal CS_WB2_MUX_sel_tmp : std_logic := '0';
signal CS_WB_MUX_sel_tmp  : std_logic := '0';
signal CS_EC_ALU_OP_in_tmp	  : std_logic_vector(3 downto 0) := (others=>'0');		
signal CS_EC_COND_en_tmp  : std_logic_vector(3 downto 0) := (others=>'0');

signal CW1 : std_logic_vector(22 downto 0) := (others=>'0');
signal CW2 : std_logic_vector(20 downto 0) := (others=>'0');
signal CW3 : std_logic_vector(11 downto 0) := (others=>'0');
signal CW4 : std_logic_vector(5 downto 0) := (others=>'0');
signal CW5 : std_logic_vector(0 downto 0) := (others=>'0');

begin

opcode <= TL_IF_IR_out(31 downto 26); --CS_ID_OP_CODE_out;
CS_EC_SHAMT_in <= TL_IF_IR_out(10 downto 6);
func <= TL_IF_IR_out(5 downto 0);

DECODE:process(RST,opcode,func)
begin
	
	--Initial conditions for every cycle
	CS_IF_NPC_en_tmp	    <= '1';		--Always enable NPC
	CS_IF_IR_en_tmp		 <= '1';		--Always enable IR
	CS_ID_IMM_en_tmp		 <= '1';		--Always enable IMM
	CS_ID_REGA_en_tmp		 <= '1';		--Always enable REGA
	CS_ID_REGB_en_tmp		 <= '1';		--Always enable REGB
	CS_EC_MUXA_sel_tmp	 <= '1';		--Always select RegA
	CS_EC_MUXB_sel_tmp	 <= '1';		--Always select IMM
	CS_EC_ALU_OP_in_tmp	 <= "0000";	--Always perform signed ADD
	CS_ALUREG_en_tmp	    <= '1';    --Always accept values from ALU
	CS_EC_COND_en_tmp 	 <= "1110"; --Never Jump condition
	CS_MA_JUMP_en_tmp		 <= '0';    --Never Jump
	CS_IF_PC_en_tmp		 <= '1';		--Always enable PC
	CS_MA_LMD_en_tmp      <= '0';		--Never enable LMD
	CS_MA_MEM_rw_tmp		 <= '0';		--Never write into memory
	CS_WB_MUX_sel_tmp		 <= '1';	   --Always select data from ALU
	CS_WB2_MUX_sel_tmp	 <= '0';		--Always select data coming from WB mux 
	CS_ID_REGF_rw_tmp		 <= '0';		--Never write in register file
	
	if (RST = '0') then
	--Some of them get changed along the way, depending on opcode
	case opcode is
	
		 --R-type instructions
		when "000000" => 
				CS_EC_MUXA_sel_tmp	 <= '1'; --Select RegA
				CS_EC_MUXB_sel_tmp 	 <= '0'; --Select RegB
				CS_ID_REGF_rw_tmp		 <= '1';	--Write on RegFile		
				case func is
					when "001000" | "001001"  =>-- jr and jalr  
						CS_MA_JUMP_en_tmp	   <= '1';    --Enable Jump
						CS_EC_COND_en_tmp	 	 <= "1111";
					--***************************************************************
					--	if func = "001001" then						
					--		CS_WB2_MUX_sel_tmp	 <= '1';   --If Jump and link reg instruction, then save NPC into regs[31]
					-- end if;
					   CS_WB2_MUX_sel_tmp	 <= func(0);
					--***************************************************************  
					  
					-- Add/Addu/Sub/Subu/Mult/Multu/logics 		
					when "100000"  | "100001" | "100010" | "100011" | "011000" | "011001" |	"100100" | "100101" | "100110" | "100111"  => 
							CS_EC_ALU_OP_in_tmp 	<= func(3 downto 0);
						
				   when "000010" | "000011" | "000000" => -- shifts 
						   CS_EC_ALU_OP_in_tmp 	<= not(func(3 downto 0));
					
					when others => null;
				end case;
				
		-- J-type instructions		
		when "000010" | "000011" => --Jump and link instructions
			CS_EC_MUXA_sel_tmp 	 <= '1';   --Select Reg[0] = 0
			CS_MA_JUMP_en_tmp	    <= '1';   --Enable Jumps
			CS_EC_COND_en_tmp	 	 <= "1111"; --Jump always
			
			--****** Commented code produces same functionality as the following 2 uncommented code lines ****
			--if(opcode(0) = '1') then
			--	CS_ID_REGF_rw_tmp     <= '1';
			--	CS_WB2_MUX_sel_tmp	 <= '1';
			--end if;
			CS_ID_REGF_rw_tmp     <= opcode(0);
			CS_WB2_MUX_sel_tmp	 <= opcode(0);
			--************************************************************************************************
			
			
		-- Immediate instructions
			-- branch instructions
		when "000100" | "000001" | "000111" | "000110" | "000101" =>
				CS_EC_MUXA_sel_tmp  <= '0';      --Select NPC
				CS_MA_JUMP_en_tmp   <= '1';		--enable Jump
				CS_EC_COND_en_tmp   <= opcode(3 downto 0);
				
				if(opcode="000001") then 
					if(TL_IF_IR_out(20 downto 16) = "00001") then
						CS_EC_COND_en_tmp <= "0011";
					end if;
				end if;
				
			--Load word and Store word respectively
		when "100011" | "101011" =>
				CS_EC_MUXA_sel_tmp  <= '1';  --Select RegA 
				CS_WB_MUX_sel_tmp   <= '0';  --Select LMD value to store in Regs
				
				--********  The commented code can be expressed as the 3 following uncommented code ********
				--if it's a load instruction then 
				--if(opcode(3)='0') then 
				--	CS_MA_LMD_en_tmp	  <= '1';  --Get data from memory
				--	CS_ID_REGF_rw_tmp	  <= '1';  --Write data into Regs		
				--else --if it's a store instruction
				--	CS_MA_MEM_rw_tmp	  <= '1';  --Write data into memory
				--end if;
				CS_MA_LMD_en_tmp	  <= not(opcode(3));   --Because they have inverse functionalities
		      CS_ID_REGF_rw_tmp	  <= not(opcode(3));
		      CS_MA_MEM_rw_tmp	  <= opcode(3);
				
				--******************************************************************************************
		
			--Addi/Addui/Andi/Xori/Ori /and others 
		when "001000" |"001001" |"001010" |"001011" |"001100" |"001101" |
			  "001110" | "001111"  =>
				CS_EC_ALU_OP_in_tmp <= '0'&opcode(2 downto 0);
				CS_ID_REGF_rw_tmp	  <= '1';  --Write data into Regs		

		when others => null;
	end case;
	end if;
end process;

--These following stages could have been implemented using structural registers
--but for understanding its functionalities it was better to leave them described in a behavioral architecture
--Still part of the decoding part
STAGE0:process(CS_IF_NPC_en_tmp	   ,
               CS_IF_IR_en_tmp		,
               CS_IF_PC_en_tmp		,
               CS_ID_REGA_en_tmp		,	
               CS_ID_REGB_en_tmp		,	
               CS_ID_IMM_en_tmp		,
               CS_EC_COND_en_tmp 	,
               CS_ALUREG_en_tmp	   ,
               CS_ID_REGF_rw_tmp		,	
               CS_MA_JUMP_en_tmp  	,		
               CS_MA_LMD_en_tmp    	, 
               CS_MA_MEM_rw_tmp		,
               CS_WB2_MUX_sel_tmp	,	
               CS_WB_MUX_sel_tmp   	,		
               CS_EC_ALU_OP_in_tmp 	,	
               CS_EC_MUXA_sel_tmp  	,	
               CS_EC_MUXB_sel_tmp	)
begin
	
		CW1(22) <= CS_IF_NPC_en_tmp; 
		CW1(21) <= CS_IF_IR_en_tmp;
		
	   --Second stage control signals
		CW1(20) <= CS_ID_IMM_en_tmp; 
		CW1(19) <= CS_ID_REGA_en_tmp;
		CW1(18) <= CS_ID_REGB_en_tmp;
		CW1(17) <= CS_EC_MUXA_sel_tmp;
		CW1(16) <= CS_EC_MUXB_sel_tmp;
	
		--Third stage control signals
		CW1(15 downto 12) <= CS_EC_ALU_OP_in_tmp;
		CW1(11) <= CS_ALUREG_en_tmp;
		CW1(10 downto 7) <= CS_EC_COND_en_tmp;
		CW1(6) <= CS_MA_JUMP_en_tmp;
	
		--Fourth stage control signals
		CW1(5) <= CS_IF_PC_en_tmp; 
		CW1(4) <= CS_MA_LMD_en_tmp; 
		CW1(3) <= CS_MA_MEM_rw_tmp;
		
		--Fith stage control signals
		CW1(2) <= CS_WB_MUX_sel_tmp;
		CW1(1) <= CS_WB2_MUX_sel_tmp;
		CW1(0) <= CS_ID_REGF_rw_tmp;
		
end process;

STAGE1:process(RST,CLK)
begin
		CW2<=CW1(20 downto 0);
		CS_IF_NPC_en <= CW1(22); 
		CS_IF_IR_en  <= CW1(21);
end process;	

STAGE2:process(RST,CLK)
begin
	if(RST='1') then
		CW3<=CW1(11 downto 0);
		
	elsif(CLK='1' and CLK'event) then
		CW3<=CW2(11 downto 0);
		CS_ID_IMM_en 	 <= CW2(20);
		CS_ID_REGA_en   <= CW2(19);
		CS_ID_REGB_en   <= CW2(18);
		CS_EC_MUXA_sel  <= CW2(17);
		CS_EC_MUXB_sel  <= CW2(16);
		CS_EC_ALU_OP_in  <= CW2(15 downto 12);
	end if;
end process;
	
STAGE3:process(CLK,RST)
begin
	if(RST='1') then
		CW4<=CW1(5 downto 0);
	
	elsif(CLK='1' and CLK'event) then
		CW4<=CW3(5 downto 0);
		CS_ALUREG_en  	  <= CW3(11);
		CS_EC_COND_en    <= CW3(10 downto 7);
		CS_MA_JUMP_en    <= CW3(6);
		CS_WB2_MUX_sel <= CW3(1);
	end if;
end process;

STAGE4:process(CLK,RST)
begin
	if(RST='1') then
		CW5<=CW1(0 downto 0);
		CS_WB_MUX_sel  <= CW1(2);
--		CS_WB2_MUX_sel <= CW1(1);
	
	elsif(CLK='1' and CLK'event) then
		CW5<=CW4(0 downto 0);
		CS_IF_PC_en  <= CW4(5);
		CS_MA_LMD_en <= CW4(4); 
		CS_MA_MEM_rw <= CW4(3);
		CS_WB_MUX_sel  <= CW4(2);
--		CS_WB2_MUX_sel <= CW4(1);
		
	end if;
end process;
	
STAGE5:process(CLK,RST)
begin
	if(RST='1') then
		CS_ID_REGF_rw  <= CW1(0);
		
	elsif(CLK='1' and CLK'event) then
		CS_ID_REGF_rw  <= CW5(0);
		
	end if;
end process;
	
end behavioral;