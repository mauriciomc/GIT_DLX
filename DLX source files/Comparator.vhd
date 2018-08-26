library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Comparator is
	 generic(N:integer:=32);
    Port ( A : in  STD_LOGIC_VECTOR (N-1 downto 0);
           B : in  STD_LOGIC_VECTOR (N-1 downto 0);
           SIGN : in  STD_LOGIC;
           CMP_LT : out  STD_LOGIC;
           CMP_GT : out  STD_LOGIC;
           CMP_EQ : out  STD_LOGIC);
end Comparator;

architecture Structural of Comparator is

begin

COMP:process(A,B,SIGN)
begin
	case SIGN is
		when '0' =>
			if(A < B) then CMP_LT<='1';CMP_GT<='0';CMP_EQ<='0';
			elsif(A > B) then CMP_LT<='0';CMP_GT<='1';CMP_EQ<='0';
			else CMP_LT<='0';CMP_GT<='0';CMP_EQ<='1'; end if;
	 
		when others =>
			if ((A(31) xor B(31)) = '0') then 
				if(A(31)='0') then
					if(A < B) then CMP_LT<='1';CMP_GT<='0';CMP_EQ<='0';
					elsif(A > B) then CMP_LT<='0';CMP_GT<='1';CMP_EQ<='0';
					else CMP_LT<='0';CMP_GT<='0';CMP_EQ<='1'; 
					end if;
				else
					if(A < B) then CMP_LT<='0';CMP_GT<='1';CMP_EQ<='0';
					elsif(A > B) then CMP_LT<='1';CMP_GT<='0';CMP_EQ<='0';
					else CMP_LT<='0';CMP_GT<='0';CMP_EQ<='1'; 
					end if;
				end if;
			else
				if(A(31)='1') then  CMP_LT<='1';CMP_GT<='0';CMP_EQ<='0'; 
				else CMP_LT<='0';CMP_GT<='1';CMP_EQ<='0';
				end if;
			end if;	
		end case;		
end process;

end Structural;
