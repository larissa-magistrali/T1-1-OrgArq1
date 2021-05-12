.text
main:		
	#Pilha
	addiu $sp,$sp,-24
	#Argumentos da funcao
	la $s0,A
	la $s1,Prim
	la $s2,Ult
	la $s3,Valor	
	lw $s1,($s1)
	lw $s2,($s2)
	lw $s3,($s3)
	
	sw $ra,16($sp)
	sw $s0,12($sp)
	sw $s1,8($sp)
	sw $s2,4($sp)
	sw $s3,0($sp)
	#msg
	li $v0,4
	la $a0,MsgPos
	syscall	
	#Chama funcao int BinSearch(const int A[], int Prim, int Ult, int Valor)
	jal buscaBin
	#esvazia pilha
	addiu $sp,$sp,20
	#resultado
	lw $v0,($sp)
	move $a0,$v0
	li $v0,1
	syscall
	addiu $sp,$sp,4
	#fim
	jal fim
	
fim:
	li $v0,10
	syscall
	
buscaBin:
	ble $s1,$s2,loop # se prim<=ult = loop	
 	j naoAchou
 	
naoAchou:
	li $v0,-1
	sw $v0,20($sp)
	jr $ra
		
loop:
	#indice do meio = s4
	addu $s4,$s1,$s2
	div $s4,$s4,2
	#pos vetor
	lw $t0,12($sp) #t0 = end de A
	add $s5,$s4,$s4
	add $s5,$s5,$s5 #x4
	add $t0,$s5,$t0 #soma no end
	lw $t0, 0($t0)
	#if ==
	beq $s3,$t0,achou
	beq $s1,$s2,naoAchou
	#if >
	bgt $s3,$t0,maior
	#if<
	bgt $t0,$s3, menor
	li $v0,11111 #teste
	sw $v0,20($sp)
	#volta
	jr $ra
	
menor:
	add $s4,$s4,-1
	sw $s4, 4($sp)
	lw $s2, 4($sp)
	j buscaBin

maior:  
	add $s4,$s4,1
	sw $s4, 8($sp)
	lw $s1, 8($sp)
	j buscaBin
	
achou: 
	move $v0,$s4
	sw $v0,20($sp)
	jr $ra

.data   #Variaveis
	A: 	.word -5 -1 5 9 12 15 21 29 31 58 250 325
	Prim:   .word 0
	Ult: 	.word 11
	Valor: 	.word 17 #BinSearch(A, 0, 11, 325); // Deve retornar 11 
	MsgPos:	 .asciiz "\nPosicao: "
