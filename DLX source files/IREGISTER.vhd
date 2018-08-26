library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity IREGISTER is
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

end IREGISTER;

architecture Behavioral of IREGISTER is

component REGISTER_N is
	 GENERIC (N : INTEGER);
    Port ( CLK : in  STD_LOGIC;
           RST : in  STD_LOGIC;
			  ENABLE : in  STD_LOGIC;
           INPUT : in  STD_LOGIC_VECTOR (N-1 downto 0);
           OUTPUT : out  STD_LOGIC_VECTOR (N-1 downto 0));
end component;

signal r_input : std_logic_vector(31 downto 0);
signal r_d,r_s,r_t : std_logic_vector(4 downto 0);
signal imm : std_logic_vector(15 downto 0);
signal opcode:std_logic_vector(5 downto 0);
signal shamt:std_logic_vector(4 downto 0);
signal func : std_logic_vector(5 downto 0);
signal r_output : std_logic_vector(31 downto 0);
signal target : std_logic_vector(25 downto 0);

begin

NOP:process(RST,r_output)
begin
		opcode <= r_output(31 downto 26); 
		r_s <= r_output(25 downto 21);
		r_t <= r_output(20 downto 16);
		r_d <= r_output(15 downto 11);
		imm <= r_output(15 downto 0); 
		target <= r_output(25 downto 0);
		shamt <= r_output(10 downto 6);
		func <= r_output(5 downto 0);
end process;


ADJUST:process(opcode,func)
begin
	CS_ID_MUX_sel <= '0';
	IR_SHAMT <= shamt;
	IR_IMM <= imm;
	IR_TARGET <= target;
   case opcode is 
		--R-type instructions
		when "000000" =>
							IR_S <= r_s;	 
							IR_D <= r_d;
							IR_T <= r_t;
							CS_ID_MUX_sel <= '0';
							--Jalr
							if(func = "001001") then
								IR_S <= "00000";
								IR_D <= "11111";
							elsif(func = "001000") then
								IR_S <= "00000";
							end if;
							
		-- J-type instructions
		when "000010" | "000011"  => --When JAL executed put writeback into REGS[31]
							IR_S <= "00000";
							IR_T <= r_t;
							CS_ID_MUX_sel <= '1';
							IR_D <= "00000";
						   if(opcode(0)='1') then
								IR_D <= "11111";
							end if;
		-- Immediate instructions
		when others   => -- change destination address
						   IR_S <= r_s;
							IR_D <= r_t;
							IR_T <= r_t;
							CS_ID_MUX_sel <= '0';
							
	end case;
end process;

IREG:REGISTER_N generic map (N) port map (CLK,RST,ENABLE,INPUT,r_output);

OUTPUT<=opcode&target;

end Behavioral;
