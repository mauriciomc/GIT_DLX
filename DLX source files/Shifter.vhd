library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Shifter is
	 generic(N:integer:=32);
    Port ( ARITH : in  STD_LOGIC;
           DIR : in  STD_LOGIC;
           D_IN : in  STD_LOGIC_VECTOR (N-1 downto 0);
           SHAMT : in  STD_LOGIC_VECTOR (4 downto 0);
           D_OUT : out  STD_LOGIC_VECTOR (N-1 downto 0);
			  R_OUT : out  STD_LOGIC_VECTOR (N-1 downto 0));
end Shifter;

architecture Behavioral of Shifter is

subtype array_type is natural range 0 to N-1; -- using natural type
type shift_array is array (array_type) of std_logic_vector(N-1 downto 0);

signal shift : shift_array;
signal mask : shift_array;
signal arithm : shift_array;
signal D_OUT_tmp : std_logic_vector(N-1 downto 0);
signal R_OUT_tmp : std_logic_vector(N-1 downto 0);
signal NOTSHAMT : std_logic_vector(4 downto 0);

begin

	shift(0)<=D_IN;
	mask(0) <= (others => '0');
	arithm(0) <= (others =>'0');
	
	NOTSHAMT <= not(SHAMT)+'1';
	
   process(ARITH,D_IN)
	begin
		for i in 1 to N-1 loop
			 if(ARITH='1') then
				arithm(i) <= (N-1 downto i => (D_IN(N-1)))&(i-1 downto 0 =>'0');
			 else
				arithm(i) <= (N-1 downto 0 => '0');
			 end if;
		end loop;
	end process;
		
	process(ARITH,D_IN,DIR,SHAMT)
	begin
		for i in 1 to N-1 loop
			mask(i) <= (N-1 downto i => '1')&(i-1 downto 0 =>'0');
		end loop;
	end process;
		
	process(D_IN)
	begin
	loop1:for i in 1 to N-1 loop
				shift(i)<=D_IN(N-1-i downto 0)&D_IN(N-1 downto N-i); --Rotate Left always
			end loop;
	end process;
	
	process(SHAMT,NOTSHAMT,DIR,shift,mask,arithm)
	begin
		case DIR is                                                                 
			when '1' 	=>	D_OUT_tmp <= ((shift(conv_integer(unsigned(NOTSHAMT))) and not mask(conv_integer(unsigned(NOTSHAMT)))) or arithm(conv_integer(unsigned(NOTSHAMT))));
								R_OUT_tmp <= shift(conv_integer(unsigned(NOTSHAMT)));
			
			when others =>	D_OUT_tmp <= shift(conv_integer(unsigned(SHAMT))) and mask(conv_integer(SHAMT));
								R_OUT_tmp <= shift(conv_integer(unsigned(SHAMT)));
		end case;
	end process;		 
	
	D_OUT <= D_OUT_tmp;
	R_OUT <= R_OUT_tmp;

end Behavioral;
