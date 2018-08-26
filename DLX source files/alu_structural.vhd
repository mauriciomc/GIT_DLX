library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity alu_structural is
  generic (N : integer := 32);
  port 	 ( DATA1 : IN std_logic_vector(N-1 downto 0); 
				DATA2: IN std_logic_vector(N-1 downto 0);
				FUNC : IN std_logic_vector(3 downto 0);
				SHAMT : IN std_logic_vector(4 downto 0);
				OUTALU: OUT std_logic_vector(N-1 downto 0));

end alu_structural;
architecture Structural of alu_structural is

component BOOTHMUL is
	 generic (N:integer := 32);
    Port ( A : in  STD_LOGIC_VECTOR (N-1 downto 0);
           B : in  STD_LOGIC_VECTOR (N-1 downto 0);
           Y : out  STD_LOGIC_VECTOR (N-1 downto 0));
end component;

component ADDSUB is
    Generic(N:integer := 32);
	 Port ( A : in  STD_LOGIC_VECTOR (N-1 downto 0);
           B : in  STD_LOGIC_VECTOR (N-1 downto 0);
           SUB : in  STD_LOGIC;
           SIGN : in  STD_LOGIC;
           OV : out  STD_LOGIC;
           S : out  STD_LOGIC_VECTOR (N-1 downto 0));
end component;

component Shifter is
	 generic(N:integer:=32);
    Port ( ARITH : in  STD_LOGIC;
           DIR : in  STD_LOGIC;
           D_IN : in  STD_LOGIC_VECTOR (N-1 downto 0);
           SHAMT : in  STD_LOGIC_VECTOR (4 downto 0);
           D_OUT : out  STD_LOGIC_VECTOR (N-1 downto 0);
			  R_OUT : out  STD_LOGIC_VECTOR (N-1 downto 0));
end component;


signal sub,sign,ov,arith,dir : std_logic;
signal output_multiplier :  STD_LOGIC_VECTOR (N-1 downto 0);
signal output_adder: STD_LOGIC_VECTOR (N-1 downto 0);
signal output_shifter: std_logic_vector(N-1 downto 0);
signal outrotate : std_logic_vector(N-1 downto 0);

begin

ADDER_SUBTRACTER : ADDSUB generic map (N) port map (DATA1,DATA2,sub,sign,ov,output_adder);
MULTIPLIER : BOOTHMUL generic map (N) port map (DATA1,DATA2,output_multiplier);
SHIFT:Shifter generic map (N) port map(arith,dir,DATA2,SHAMT,output_shifter,outrotate);

P_ALU: process (FUNC, DATA1, DATA2,output_adder,output_multiplier,output_shifter)

  begin
    case FUNC is
	 
			--Arithmetic operations
			when "0000" 		=> sub <= '0'; sign <= '0'; OUTALU <= output_adder; --ADD
			when "0001"       => sub <= '0'; sign <= '1'; OUTALU <= output_adder; --ADDU 
			when "0010" 		=> sub <= '1'; sign <= '0'; OUTALU <= output_adder; --SUB
			when "0011" 		=> sub <= '1'; sign <= '0'; OUTALU <= output_adder; --SUBU
			when "1000"		   => OUTALU <= output_multiplier; --MULT
			when "1001"		   => OUTALU <= output_multiplier; --MULTU
			
			--Shift functions
			when "1100"			=> arith <= '1'; dir <= '1'; OUTALU<=output_shifter; --SRA
			when "1101"			=> arith <= '0'; dir <= '1'; OUTALU<=output_shifter; --SRL
			when "1111"			=> arith <= '0'; dir <= '0'; OUTALU<=output_shifter; --SLL
			
			--Bitwise operations
			when "0100"			=> OUTALU <= DATA1 and DATA2;--AND
			when "0101"			=> OUTALU <= DATA1 or DATA2; --OR
			when "0111"			=> OUTALU <= DATA1 nor DATA2; --NOR
			when "0110"			=> OUTALU <= DATA1 xor DATA2; --XOR
			when others => null;
    end case; 
  end process P_ALU;


end Structural;

