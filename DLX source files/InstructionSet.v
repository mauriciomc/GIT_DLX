--R-type instructions opcode = 000000
					func
jr    				001000    --Jump to register
jalr  				001001    --Jump and link register
Add				100000	
Addu				100001
Sub 	         		100010 
Subu				100011			
Mult           			011000
Multu          			011001
And	         		100100
Or		         	100101
Xor				100110
Nor				100111
srl				000010
sra				000011
sll				000000

-- J-type instructions		
				Opcode
Jmp    				000010
Jal    				000011


-- Conditional 		        Opcode
beq			   	000100	
blez				000001
blz				000001  RT = 00001
bgtz				000111
bgez				000110
bne				000101
		
-- Memory
lw 				100011		
sw				101011


-- Immediate instructions
Addi           			001000
Addui				001001
Subi				001010
Subui				001011
Ori				001101 				
Andi				001100
Nori				001111				
Xori				001110
