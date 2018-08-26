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
			  CS_IF_NPC_en : in STD_LOGIC;
			  CS_IF_IR_en : in STD_LOGIC;			  
			  CS_ID_REGA_en : in std_logic;
			  CS_ID_REGB_en : in std_logic;
			  CS_ID_IMM_en : in std_logic;	
			  CS_ID_REGF_rw: out STD_LOGIC; 
			  CS_ALUREG_en : IN STD_LOGIC;
			  CS_EC_ALU_OP_in : out STD_LOGIC_VECTOR(5 downto 0);
			  CS_EC_SHAMT_in : out STD_LOGIC_VECTOR (4 downto 0);
			  CS_EC_COND_en : out STD_LOGIC_VECTOR(3 downto 0);  
			  CS_EC_MUXA_sel : out STD_LOGIC; 
			  CS_EC_MUXB_sel : out STD_LOGIC; 
			  CS_MA_LMD_en : out STD_LOGIC; 
			  CS_MA_MEM_rw : out STD_LOGIC; 
			  CS_WB_MUX_sel : out STD_LOGIC;
			  CS_WB2_MUX_sel : out STD_LOGIC);
end DLX_CU;

architecture Behavioral of DLX_CU is

signal opcode : STD_LOGIC_VECTOR(5 downto 0);
signal func : STD_LOGIC_VECTOR(5 downto 0);
signal shamt : STD_LOGIC_VECTOR(4 downto 0);
signal imm : STD_LOGIC_VECTOR(15 downto 0);

begin

opcode <= TL_IF_IR_out(31 downto 26); --CS_ID_OP_CODE_out;
CS_EC_SHAMT_in <= TL_IF_IR_out(10 downto 6);
func <= TL_IF_IR_out(5 downto 0);


DECODE:process(TL_IF_IR_out)
begin
	case opcode is
		when "000000" =>  --R-type instructions
				
					
				
				
				
				CS_EC_MUXA_sel_tmp 	 <= '1'; 
				CS_EC_MUXB_sel_tmp 	 <= '0';
				
				
				CS_EC_ALU_OP_in_tmp   <= func;
				CS_EC_COND_en_tmp 	 <= "0000";
				CS_IF_PC_en_tmp 		 <=
				
				
				CS_WB_MUX_sel_tmp 	 <= '1';
				CS_REGF_rw				 <= ' ';
			

























PC_REFRESH:process(CLK,RST)
begin
	if(RST='1') then -- asynchronous reset
		TL_IF_PC_en <= '0';
		TL_IF_NPC_en <= '0';
	
	else
		if(CLK='1' and CLK'event) then
			TL_IF_PC_en  <= '1';
			TL_IF_NPC_en <= '1';
		else
			TL_IF_PC_en <= '0';
			TL_IF_NPC_en <= '0';
		
		end if;
	end if;
end process;
				

MEMORY_WRITE:process(CS_MA_en_tmp)
begin
	if(CS_MA_en_tmp = '1') then
		CS_IF_PC_en <= '1';
		case opcode is
			when "010000" | "010001" | "010010" => -- for Store instructions
				CS_MA_MEM_rw <= '1';

			when others => -- for load instructions
				CS_MA_MEM_rw <= '0';
		end case;
	else 
		CS_MA_MEM_rw <= '0';
		CS_IF_PC_en <= '0';
	end if;
end process;

REGISTER_FILE_WRITE:process(CS_WB_en_tmp)
begin
	if(CS_WB_en_tmp ='1') then
		case opcode(5 downto 4) is
			when "01" | "11" | "10"    => 	CS_ID_REGF_rw <='0';
			when others                =>    CS_ID_REGF_rw <='1';
		end case;
		case opcode is
			when "010100" | "010101" => 
				CS_ID_REGF_rw <='1';
				CS_WB2_MUX_sel <='1'; --select NPC
			when others =>CS_WB2_MUX_sel <='0';
		end case;
	else
		CS_ID_REGF_rw <= '0';
		CS_WB2_MUX_sel <='0';
	end if;
end process;



DECODE: process (opcode)
begin
case opcode is
	when "000000" =>  --OP_NOP
		CS_EC_MUXA_sel 	<= '1'; 
		CS_EC_MUXB_sel 	<= '1';
		CS_EC_ALU_OP_in 	<= "000000";
		CS_EC_COND_en 		<= "0000";
		CS_WB_MUX_sel 		<= '1';
		
	when "000001" =>  --OP_ADDI
		CS_EC_MUXA_sel 	<= '1'; 
		CS_EC_MUXB_sel 	<= '1';
		CS_EC_ALU_OP_in 	<= "000000";
		CS_EC_COND_en 		<= "0000";
		CS_WB_MUX_sel 		<= '1';
		
	when "000010" =>  --OP_ADDUI
		CS_EC_MUXA_sel 	<= '1'; 
		CS_EC_MUXB_sel 	<= '1';
		CS_EC_ALU_OP_in 	<= "000000";
		CS_EC_COND_en 		<= "0000";
		CS_WB_MUX_sel 		<= '1';
		
	when "000011" =>  --OP_SUBI
		CS_EC_MUXA_sel 	<= '1'; 
		CS_EC_MUXB_sel 	<= '1';
		CS_EC_ALU_OP_in 	<= "000010";
		CS_EC_COND_en 		<= "0000";
		CS_WB_MUX_sel 		<= '1';
		
	when "000100" =>  --OP_SUBUI
		CS_EC_MUXA_sel 	<= '1'; 
		CS_EC_MUXB_sel 	<= '1';
		CS_EC_ALU_OP_in 	<= "000010";
		CS_EC_COND_en 		<= "0000";
		CS_WB_MUX_sel 		<= '1';
		
	when "000101" =>  --OP_MULI
		CS_EC_MUXA_sel 	<= '1'; 
		CS_EC_MUXB_sel 	<= '1';
		CS_EC_ALU_OP_in 	<= "000100";
		CS_EC_COND_en 		<= "0000";
		CS_WB_MUX_sel 		<= '1';
		
	when "000110" =>  --OP_MULUI
		CS_EC_MUXA_sel 	<= '1'; 
		CS_EC_MUXB_sel 	<= '1';
		CS_EC_ALU_OP_in 	<= "000100";
		CS_EC_COND_en 		<= "0000";
		CS_WB_MUX_sel 		<= '1';
		
	when "000111" =>  --OP_DIVI
		CS_EC_MUXA_sel 	<= '1'; 
		CS_EC_MUXB_sel 	<= '1';
		CS_EC_ALU_OP_in 	<= "000100";
		CS_EC_COND_en 		<= "0000";
		CS_WB_MUX_sel 		<= '1';
		
	when "001000" =>  --OP_DIVUI
		CS_EC_MUXA_sel 	<= '1'; 
		CS_EC_MUXB_sel 	<= '1';
		CS_EC_ALU_OP_in 	<= "000100";
		CS_EC_COND_en 		<= "0000";
		CS_WB_MUX_sel 		<= '1';
		
	when "001001" =>  --OP_ANDI
		CS_EC_MUXA_sel 	<= '1'; 
		CS_EC_MUXB_sel 	<= '1';
		CS_EC_ALU_OP_in 	<= "000101";
		CS_EC_COND_en 		<= "0000";
		CS_WB_MUX_sel 		<= '1';
		
	when "001010" =>  --OP_ORI
		CS_EC_MUXA_sel 	<= '1'; 
		CS_EC_MUXB_sel 	<= '1';
		CS_EC_ALU_OP_in 	<= "000110";
		CS_EC_COND_en 		<= "0000";
		CS_WB_MUX_sel 		<= '1';
		
	when "001011" =>  --OP_XORI
		CS_EC_MUXA_sel 	<= '1'; 
		CS_EC_MUXB_sel 	<= '1';
		CS_EC_ALU_OP_in 	<= "000111";
		CS_EC_COND_en 		<= "0000";
		CS_WB_MUX_sel 		<= '1';
		
	when "001100" =>  --OP_ALU
		CS_EC_MUXA_sel 	<= '1'; 
		CS_EC_MUXB_sel 	<= '0';
		CS_EC_ALU_OP_in 	<= func;
		CS_EC_COND_en 		<= "0000";
		CS_WB_MUX_sel 		<= '1';
		
	when "001101" =>  --OP_LW
		CS_EC_MUXA_sel 	<= '1'; 
		CS_EC_MUXB_sel 	<= '1';
		CS_EC_ALU_OP_in 	<= "000000";
		CS_EC_COND_en 		<= "0000";
		CS_WB_MUX_sel 		<= '0';
		
	when "001110" =>  --OP_LH
		CS_EC_MUXA_sel 	<= '1'; 
		CS_EC_MUXB_sel 	<= '1';
		CS_EC_ALU_OP_in 	<= "000000";
		CS_EC_COND_en 		<= "0000";
		CS_WB_MUX_sel 		<= '0';
		
	when "001111" =>  --OP_LB
		CS_EC_MUXA_sel 	<= '1'; 
		CS_EC_MUXB_sel 	<= '1';
		CS_EC_ALU_OP_in 	<= "000000";
		CS_EC_COND_en 		<= "0000";
		CS_WB_MUX_sel 		<= '0';
		
	when "010000" =>  --OP_SW
		CS_EC_MUXA_sel 	<= '1'; 
		CS_EC_MUXB_sel 	<= '1';
		CS_EC_ALU_OP_in 	<= "000000";
		CS_EC_COND_en 		<= "0000";
		CS_WB_MUX_sel 		<= '1';
			
	when "010001" =>  --OP_SH
		CS_EC_MUXA_sel 	<= '1'; 
		CS_EC_MUXB_sel 	<= '1';
		CS_EC_ALU_OP_in 	<= "000000";
		CS_EC_COND_en 		<= "0000";
		CS_WB_MUX_sel 		<= '1';
		
	when "010010" =>  --OP_SB
		CS_EC_MUXA_sel 	<= '1'; 
		CS_EC_MUXB_sel 	<= '1';
		CS_EC_ALU_OP_in 	<= "000000";
		CS_EC_COND_en 		<= "0000";
		CS_WB_MUX_sel 		<= '1';
		
	when "010011" =>  --OP_J
		CS_EC_MUXA_sel 	<= '0'; 
		CS_EC_MUXB_sel 	<= '1';
		CS_EC_ALU_OP_in 	<= "010010";
		CS_EC_COND_en 		<= "1101";
		CS_WB_MUX_sel 		<= '1';
		
	when "010100" =>  --OP_JAL
		CS_EC_MUXA_sel 	<= '0'; 
		CS_EC_MUXB_sel 	<= '1';
		CS_EC_ALU_OP_in 	<= "010010";
		CS_EC_COND_en 		<= "1101";
		CS_WB_MUX_sel 		<= '1';
			
	when "010101" =>  --OP_JALR
		CS_EC_MUXA_sel 	<= '0'; --select NPC
		CS_EC_MUXB_sel 	<= '1';
		CS_EC_ALU_OP_in 	<= "000000";
		CS_EC_COND_en 		<= "1101";
		CS_WB_MUX_sel 		<= '1';
			
	when "010110" =>  --OP_JR
		CS_EC_MUXA_sel 	<= '0'; 
		CS_EC_MUXB_sel 	<= '1';
		CS_EC_ALU_OP_in 	<= "000000";
		CS_EC_COND_en 		<= "1101";
		CS_WB_MUX_sel 		<= '1';
				
	when "010111" =>  --OP_BEQZ
		CS_EC_MUXA_sel 	<= '1'; 
		CS_EC_MUXB_sel 	<= '1';
		CS_EC_ALU_OP_in 	<= "000000";
		CS_EC_COND_en 		<= "0001";
		CS_WB_MUX_sel 		<= '1';
		
	when "011000" =>  --OP_BNEZ
		CS_EC_MUXA_sel 	<= '1'; 
		CS_EC_MUXB_sel 	<= '1';
		CS_EC_ALU_OP_in 	<= "000000";
		CS_EC_COND_en 		<= "0010";
		CS_WB_MUX_sel 		<= '1';
		
	when "011001" =>  --OP_BLTZ
		CS_EC_MUXA_sel 	<= '1'; 
		CS_EC_MUXB_sel 	<= '1';
		CS_EC_ALU_OP_in 	<= "000000";
		CS_EC_COND_en 		<= "0011";
		CS_WB_MUX_sel 		<= '1';
		
	when "011010" =>  --OP_BGTZ
		CS_EC_MUXA_sel 	<= '1'; 
		CS_EC_MUXB_sel 	<= '1';
		CS_EC_ALU_OP_in 	<= "000000";
		CS_EC_COND_en 		<= "0100";
		CS_WB_MUX_sel 		<= '1';
		
	when "011011" =>  --OP_BLEZ
		CS_EC_MUXA_sel 	<= '1'; 
		CS_EC_MUXB_sel 	<= '1';
		CS_EC_ALU_OP_in 	<= "000000";
		CS_EC_COND_en 		<= "0101";
		CS_WB_MUX_sel 		<= '1';
		
	when "011100" =>  --OP_BGEZ
		CS_EC_MUXA_sel 	<= '1'; 
		CS_EC_MUXB_sel 	<= '1';
		CS_EC_ALU_OP_in 	<= "000000";
		CS_EC_COND_en 		<= "0110";
		CS_WB_MUX_sel 		<= '1';
		
	when "011101" =>  --OP_BEQR
		CS_EC_MUXA_sel 	<= '1'; 
		CS_EC_MUXB_sel 	<= '1';
		CS_EC_ALU_OP_in 	<= "000000";
		CS_EC_COND_en 		<= "0111";
		CS_WB_MUX_sel 		<= '1';
		
	when "011110" =>  --OP_BNER
		CS_EC_MUXA_sel 	<= '1'; 
		CS_EC_MUXB_sel 	<= '1';
		CS_EC_ALU_OP_in 	<= "000010";
		CS_EC_COND_en 		<= "1000";
		CS_WB_MUX_sel 		<= '1';
		
	when "011111" =>  --OP_BLTR
		CS_EC_MUXA_sel 	<= '1'; 
		CS_EC_MUXB_sel 	<= '1';
		CS_EC_ALU_OP_in 	<= "000010";
		CS_EC_COND_en 		<= "1001";
		CS_WB_MUX_sel 		<= '1';
		
	when "100000" =>  --OP_BGTR
		CS_EC_MUXA_sel 	<= '1'; 
		CS_EC_MUXB_sel 	<= '1';
		CS_EC_ALU_OP_in 	<= "000010";
		CS_EC_COND_en 		<= "1010";
		CS_WB_MUX_sel 		<= '1';
		
	when "100001" =>  --OP_BLER
		CS_EC_MUXA_sel 	<= '1'; 
		CS_EC_MUXB_sel 	<= '1';
		CS_EC_ALU_OP_in 	<= "000010";
		CS_EC_COND_en 		<= "1011";
		CS_WB_MUX_sel 		<= '1';
		
	when "100010" =>  --OP_BGER
		CS_EC_MUXA_sel 	<= '1'; 
		CS_EC_MUXB_sel 	<= '1';
		CS_EC_ALU_OP_in 	<= "000010";
		CS_EC_COND_en 		<= "1100";
		CS_WB_MUX_sel 		<= '1';
		
	when others => 
		CS_EC_MUXA_sel 	<= '1'; 
		CS_EC_MUXB_sel 	<= '1';
		CS_EC_ALU_OP_in 	<= "000000";
		CS_EC_COND_en 		<= "0000";
		CS_WB_MUX_sel 		<= '1';
		-- unknown case

end case;

end process DECODE;

end Behavioral;