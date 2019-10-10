.data

#============================================================ MENSAGENS =============================================================
msg1: .ascii "\n1 - REGISTRAR DESPESA."
 "\n2 - LISTAR DESPESAS."
 "\n3 - EXCLUIR DESPESA."
 "\n4 - EXIBIR GASTO MENSAL."
 "\n5 - EXIBIR GASTO POR CATEGORIA."
 "\n6 - EXIBIR RANKING DE DESPESAS."
 "\n0 - SAIR."
 "\n\n DIGITE A OPÇÃO DESEJADA: \0"

msg2: .ascii "\n DIGITE A CATEGORIA: \0"

msg3: .ascii " DIGITE O PRECO: \0"

msg4: .ascii " DIGITE O DIA: \0"

msg5: .ascii " DIGITE O MES: \0"

msg6: .ascii " DIGITE O ANO: \0"

msg7:  .ascii "\n DIGITE O CODIGO DA DESPESA QUE DESEJA EXCLUIR: \0"

msg8:   .ascii "\n ID NÃO ENCONTRADO!!! \0"

msg9:   .ascii "\n gasto mensal nulo \0"

msgDiax: .ascii " MÊS/ANO:\0"

msgCodigo: .ascii "\n CÓDIGO (ID): \0"

msgCategoria: .ascii " CATEGORIA: \0"

msgPreco: .ascii " VALOR GASTO EM REAIS: \0"

msgData: .ascii " DATA: \0"

msgbarra: .ascii "/\0"

msgPulaLinha: .ascii "\n\0"

msgDespesa: .ascii "\n NENHUMA DESPESA CADASTRADA!\0"

msgCabecalho: .ascii "\n       CATEGORIA       PRECO\0"

#=================================== VARIÁVEIS =====================================
vetor: .align 2
.space 3000

vetor_mensal: .align 2
.space 520

vetor_categoria: .align 2
.space 1500

codigo: .word 0

cont: .word 0

posicao: .word 0

posicao_categoria: .word 0

#===================================================================================

.text
.globl main

main:
li $v0, 4 # Codigo SysCall p/ escrever strings
la $a0, msg1
syscall

li $v0, 5 # Codigo SysCall p/ receber inteiros
syscall
add $s0, $v0, $zero

addi $t0, $t0, 6
ble $s0, $t0, Verificar
j main

Verificar:
blt $v0, $zero, main
beq $s0, 1, listar
beq $s0, 2, exbir
beq $s0, 3, excluir
beq $s0, 4, gasto_mensal
beq $s0, 5, gasto_categoria_E_ranking
beq $s0, 6, gasto_categoria_E_ranking
beq $s0, 0, sair 

#==================================================================================1-LISTAR

listar :
lw $t3,posicao
lw $t0,codigo
addi $t0,$t0,1    #incrementa o contador do codigo, gerando automaticamente
sw $t0, codigo
sw $t0, cont
sw $t0,vetor($t3)  #guarda o codigo no vetor t3


li $v0, 4 # Codigo SysCall p/ escrever strings
la $a0, msg2  #digite categoria
syscall

addi $t3,$t3,4    #anda com a posicao e acessa categoria
li $v0,8
li $a1,18  #18 caracteres para categoria
la $a0,vetor($t3)
syscall
#sw $a0,vetor($t3)

li $v0, 4 # Codigo SysCall p/ escrever strings
la $a0, msg3 #digitar preco
syscall


addi $t3, $t3, 20 #(perguntar)   sai do campo categoria para o preco
li $v0, 6        #preco
syscall
#abs.d $f12, $f0
swc1 $f0,vetor($t3)

li $v0, 4 # Codigo SysCall p/ escrever strings
la $a0, msg4 #digitar dia
syscall

addi $t3,$t3,4   # digitar dia
li $v0,5
syscall
sw $v0,vetor($t3)


li $v0, 4 # Codigo SysCall p/ escrever strings
la $a0, msg5 #digitar mês
syscall

addi $t3,$t3,4   # mês
li $v0,5
syscall
sw $v0,vetor($t3)

li $v0, 4 # Codigo SysCall p/ escrever strings
la $a0, msg6 #digitar ano
syscall

addi $t3,$t3,4   # ano
li $v0,5
syscall
sw $v0,vetor($t3) 

addi $t3,$t3,4   #para guardar a ultima posicao na variavel
sw $t3,posicao
j main

#==================================================================================2-EXIBIR

exbir :
lw $t0,posicao
li $t1,0
#---------------------------------------------------------------------------------
repeticao:

ble $t0,$t1,main   #vai para main se o contador for maior que a ultima posicao
li $v0, 4
la $a0, msgCodigo #imprime codigo
syscall

lw $a0,vetor($t1) #recebe codigo
li $v0,1
syscall

li $v0, 4
la $a0, msgPulaLinha #imprime Pula Linha
syscall

li $v0, 4
la $a0, msgCategoria #imprime Categoria
syscall

addi $t1,$t1,4        #recebe categoria
li $v0, 4
la $a0,vetor($t1)
syscall

li $v0, 4
la $a0, msgPreco #imprime Preco
syscall

addi $t1,$t1,20        #recebe preco
lwc1 $f12, vetor($t1)
li $v0, 2
syscall

li $v0, 4
la $a0, msgPulaLinha #imprime Pula Linha
syscall

li $v0, 4
la $a0, msgData #imprime Data
syscall

addi $t1,$t1,4    #recebe dia
lw $a0,vetor($t1)
li $v0,1
syscall

li $v0, 4
la $a0, msgbarra #imprime a barra
syscall

addi $t1,$t1,4    #recebe mes
lw $a0,vetor($t1)
li $v0,1
syscall

li $v0, 4
la $a0, msgbarra
syscall

addi $t1,$t1,4   #recebe ano
lw $a0,vetor($t1)
li $v0,1
syscall

li $v0, 4
la $a0, msgPulaLinha #imprime Pula Linha
syscall

addi $t1,$t1,4
sub $t0,$t0,1
j repeticao

#=====================================================================================================================================

excluir:

li $v0, 4
la $a0, msg7   #digite id
syscall

li $v0,5   #recebe o id
syscall

li $t0,0   #indice do vetor

lw $t2, posicao
sub $t2, $t2,4

loop :
lw $t1, vetor($t0)
bgt $t0, $t2, alerta

beq $t1, $v0, eliminar
addi $t0, $t0, 40    # é o i que caminha pelo vetor
j loop

alerta:
li $v0, 4
la $a0, msg8
syscall
j main

eliminar:
beq $t0, $t2, ultimo #pergunta se o ID que deseja remover é o ultimo
	li $t3,0
	add $t3,$t0,$zero
	addi $t3,$t3,40	
	
	loop1:
	bgt $t3,$t2,ultimo
		
	lw $t5,vetor($t3)		#carregou o ultimo para por no comeco
	sw $t5,vetor($t0)
	
	addi $t0,$t0,4                  #andando com o i
	addi $t3,$t3,4			
	
	#andando para categoria do ultimo
	add $s0,$t3,$0
	add $s2,$t0,$0
	loop14:
	lb $s1,vetor($s0)
	sb $s1,vetor($s2)
	beq $s1,0,j5
	addi $s2,$s2,1
	addi $s0,$s0,1
	j loop14
	j5:
	
	addi $t0,$t0,20                 #andando no campo preco
	addi $t3,$t3,20
	lwc1 $f1,vetor($t3)
	swc1 $f1,vetor($t0)
	
	addi $t0,$t0,4                   #andando no dia
	addi $t3,$t3,4
	lw $t5,vetor($t3)
	sw $t5,vetor($t0)
	
	addi $t0,$t0,4                   #andando no mes                 
	addi $t3,$t3,4
	lw $t5,vetor($t3)
	sw $t5,vetor($t0)
	
	addi $t0,$t0,4                   #andando no ano
	addi $t3,$t3,4
	lw $t5,vetor($t3)
	sw $t5,vetor($t0)
	
	addi $t0,$t0,4                   #andando no ano
	addi $t3,$t3,4
	j loop1	

ultimo:
sub $t2, $t2, 36  #remove o ultimo ID registrado tirando (28 - 4)
sw $t2, posicao
j main

#==================================================================================4-GASTO-MENSAL

gasto_mensal :

li $t0,24   # o indice do vetor original
li $t3,0    # inicial do vetor mensal
li $t4,0    #final do vetor mensal
lw $t2, posicao  #guarda a ultima posicao no t2
sub $t2, $t2,4   #estamos no ano do ultimo registrado
loop5:
li $t3,0 
bge $t0,$t2,imprimir 
loop6:
bge $t3,$t4,inserir
addi $t3,$t3,4
addi $t0,$t0,8
lw $t5,vetor($t0)
lw $t6,vetor_mensal($t3)
beq $t5,$t6,verano
addi $t3,$t3,8
sub $t0,$t0,8
j loop6

verano:
addi $t3,$t3,4
addi $t0,$t0,4
lw $t5,vetor($t0)
lw $t6,vetor_mensal($t3)
beq $t5,$t6,incrementar
addi $t3,$t3,4
sub $t0,$t0,12
j loop6

incrementar:
sub $t0,$t0,12
sub $t3,$t3,8
lwc1 $f0, vetor($t0)
lwc1 $f1, vetor_mensal($t3)
add.s $f1, $f0, $f1
swc1 $f1,vetor_mensal($t3)
addi $t0,$t0,40
j loop5

inserir:
lwc1 $f0,vetor($t0)
swc1 $f0,vetor_mensal($t4)
addi $t0,$t0,8
addi $t4,$t4,4
lw $t5,vetor($t0)
sw $t5,vetor_mensal($t4)
addi $t0,$t0,4
addi $t4,$t4,4
lw $t5,vetor($t0)
sw $t5,vetor_mensal($t4)
addi $t4,$t4,4
addi $t0,$t0,28
j loop5

imprimir:
sub $t4,$t4,4
li $t3,0

loop_imprimir:
bge $t3,$t4,main

li $v0, 4       #preco
la $a0, msgPreco
syscall

lwc1 $f12,vetor_mensal($t3)
li $v0,2
syscall

li $v0, 4          #pula linha
la $a0, msgPulaLinha
syscall

li $v0, 4          
la $a0, msgDiax #msg data
syscall

addi $t3,$t3,4
lw $a0,vetor_mensal($t3)
li $v0,1
syscall

li $v0, 4          
la $a0, msgbarra #msg data
syscall

addi $t3,$t3,4
lw $a0,vetor_mensal($t3)
li $v0,1
syscall

li $v0, 4          
la $a0, msgPulaLinha #msg data
syscall

addi $t3,$t3,4
j loop_imprimir

print_mensal:
sub $t1,$t1, 8

gasto_categoria_E_ranking:
add $s7, $s0, $zero 
lw $t0, posicao
bne $t0, $zero, Verificacao
li $v0, 4 # Codigo SysCall p/ escrever strings
la $a0, msgDespesa #Nenhuma despesa cadastrada
syscall
j main

Verificacao:
lw $t7, posicao
li $t6, 40
blt $t7, $t6, Sair
li $t0, 4
la $a1, vetor($t0)
jal Lower
jal Organizar_Vetor_Auxiliar

addi $t0, $zero, 6
beq $s7, $t0, ranking

addi $s0, $zero, 24 # $s0 = i = 24, meu indice é 24
add $s1, $zero, $zero # $s1 = j = zero
lw $s2, posicao_categoria #$s2 é o tamanho do meu vetor  
addi $s3, $s2, -24 #$3 recebe o tamanho do vetor menos 24 que é o meu indice
jal Bublle_Sort
j main

ranking:
addi $s0, $zero, 44 # $s0 = i = 44, meu indice é 24
addi $s1, $zero, 20 # $s1 = j = 20
lw $s2, posicao_categoria #$s2 é o tamanho do meu vetor 
addi $s3, $s2, -4 #$3 recebe o tamanho do vetor menos 4
jal Bublle_Sort
j main

sair :
li $v0,10
syscall

#============================================================= FUNÇÕES ===================+==========================================
#Colocar em t0 posicao inicial e em a1, o conteudo da posicao 
#inicial da string que deseja realizar "lower"
Lower: #FUNÇÃO PARA DEIXAR TODAS AS LETRAS MINÚSCULAS, MENOS A PRIMEIRA
add $s0, $zero, $zero
add $s1, $zero, $zero

Lower2:	
	add $t1, $s0, $a1
	lbu $t2, 0($t1)
	
	beq $t2, $zero, exit
	li $t5, 0x10
	ble $t2, $t5, exit
   	
   	li $t6, 0x60        #todas as letras em minusculas menos a primeira
   	or $t2, $t2, $t6
   	
   	beq $s0, $zero, primeira_maiscula
   	sb $t2, 0($t1) #Sobreescrevo letras minusculas no vetor
   	j outras_letras
   	
      	primeira_maiscula:
      			  li $t5, -32       #transformar em maiscula a primeira letra
     			  add $t2, $t2, $t5
      			  sb $t2, 0($t1)
   	
   	outras_letras:
         addi $s0, $s0, 1
         j Lower2     
       
	 exit:
	 addi $s1, $s1, 1
	 li $s0, 0
	 lw $t3, cont
	 addi $t0, $t0, 40
	 la $a1, vetor($t0)
	 ble $s1, $t3, Lower2
	 jr $ra

#====================================================================================================================================
#Colocar a posicao inicial da primeira string no $t0 e o conteudo 
#da posicao do vetor para a1
#Colocar a posicao inicial da segunda string no $t0 e o conteudo 
#da posicao do vetor para a2
#se retornar 1 no $s1 sao iguais e se retornar 0 no $s1 são diferentes
strcmp: #comparar se duas strings sao iguais
 addi $sp, $sp, -16
 sw $t3, 12($sp) 
 sw $t1, 8($sp)
 sw $t2, 4($sp)
 sw $t0, 0($sp)
 
add $s0, $zero, $zero # s0 = 0
add $s1, $zero, $zero # s1 = 0

 L3: add $t0, $s0, $a1 #addr de string1[i] in $t1
      lbu  $t1, 0($t0)  #t2 = string1[i]
      beq $t1, $zero, compara1
      li $t4, 0x10
      ble $t1, $t4, compara2
      add $t2, $s0, $a2 #addr de string2[i] in $t1
      lbu $t3, 0($t2)   #t2 = string1[i]
      bne $t1, $t3, diferentes
      addi $s0, $s0, 1
      j L3

compara1:
      add $t2, $s0, $a2 #addr de string2[i] in $t1
      lbu $t3, 0($t2)   #t2 = string1[i]
      beq $t3, $zero, iguais     
      lw $t0, 0($sp)
      lw $t2, 4($sp)
      lw $t1, 8($sp)
      lw $t3, 12($sp)
      addi $sp, $sp, 16
      jr $ra
   
compara2:
      add $t2, $s0, $a2 #addr de string2[i] in $t1
      lbu $t3, 0($t2)   #t2 = string1[i]
      
      li $t4, 0x10
      ble $t3, $t4, iguais
      lw $t0, 0($sp)
      lw $t2, 4($sp)
      lw $t1, 8($sp)
      lw $t3, 12($sp)
      addi $sp, $sp, 16 
      jr $ra

iguais:
      addi $s1, $s1, 1
      lw $t0, 0($sp)
      lw $t2, 4($sp)
      lw $t1, 8($sp)
      lw $t3, 12($sp)
      addi $sp, $sp, 16
      jr $ra

diferentes:
      lw $t0, 0($sp)
      lw $t2, 4($sp)
      lw $t1, 8($sp)
      lw $t3, 12($sp)
      addi $sp, $sp, 16
      jr $ra

#====================================================================================================================================

Organizar_Vetor_Auxiliar:
or $t7, $31, $zero
li $t1, 0
li $t2, 0
li $t3, 20

L4:
addi $t1, $t1, 4
lw $a1, vetor($t1)
sw $a1, vetor_categoria($t2)

addi $t2, $t2, 4
bne $t2, $t3, L4

addi $t1, $t1, 4
lwc1 $f1, vetor($t1)
swc1 $f1, vetor_categoria($t2)

li $t0, 24
sw $t0, posicao_categoria

L5:
lw $t5, posicao
li $t6, 80
blt $t5, $t6, Sair

li $t0, 0 #duplique para facilitar se caso ocorrer categoria repetida
li $t2, 0 
li $t1, 44 #duplique para facilitar se caso ocorrer categoria repetida
li $t3, 44
  
 L6:
 la $a1, vetor_categoria($t0)
 la $a2, vetor($t1)
 jal strcmp
 or $31, $t7, $zero
 bne $s1, $zero, categoria_repetida 
 
 addi $t2, $t2, 24
 lw $t4, posicao_categoria
 beq $t2, $t4, categoria_nova
 
 add $t0, $zero, $t2
 j L6
 
 categoria_nova:
li $t3, 20

L7:
lw $a2, vetor($t1)
sw $a2, vetor_categoria($t2)

addi $t1, $t1, 4
addi $t2, $t2, 4
addi $t3, $t3, -4
bne $t3, $zero, L7

lwc1 $f1, vetor($t1)
swc1 $f1, vetor_categoria($t2)

addi $t1, $t1, 4
addi $t2, $t2, 4

sw $t2, posicao_categoria
addi $t1, $t1, 12
lw $t3, posicao
beq $t1, $t3, Sair

add $t0, $zero, $zero
add $t2, $zero, $zero 
addi $t1, $t1, 4
add $t3, $zero, $t1
j L6
 
categoria_repetida:
addi $t2, $t2, 20
addi $t3, $t3, 20

lwc1 $f0, vetor_categoria($t2)
lwc1 $f1, vetor($t3)
add.s $f2, $f0, $f1
swc1 $f2, vetor_categoria($t2)

addi $t3, $t3, 16
lw $t5, posicao
beq $t3, $t5, Sair
add $t0, $zero, $zero 
add $t2, $zero, $zero 
addi $t1, $t1, 40
add $t3, $t1, $zero
j L6

Sair:
jr $ra

#==================================================================================================================================
        
#COLOCAR ENDERECO DE STRING 1 EM $T5
#COLOCAR ENDERECO DE STRING 2 EM $T6
#ZERAR $T7
inverter:     #INVERTER STRINGS
      lw $t0, vetor_categoria($t6)
      
      lw $t1,vetor_categoria($t5)
      sw $t1,vetor_categoria($t6)
      
      sw $t0, vetor_categoria($t5)
      
      addi $t5, $t5, 4
      addi $t6, $t6, 4
      addi $t7, $t7, 4
      li $t0, 20
      bne $t7, $t0, inverter 
     
      lwc1 $f0, vetor_categoria($t6)
      
      lwc1 $f1, vetor_categoria($t5)
      swc1 $f1, vetor_categoria($t6)
	
      swc1 $f0, vetor_categoria($t5)
	jr $ra

#==================================================================================================================================

Bublle_Sort:
or $v1, $31, $zero

for_i:
bge $s0, $s2, sair_i

for_j: 
bge $s1, $s3, sair_j
addi $s4, $s1, 24

Comparacao: 
addi $t0, $zero, 6
beq $s7, $t0, Condicao_ranking

la $a1, vetor_categoria($s1)
add $t5, $s1, $zero

la $a2, vetor_categoria($s4)
add $t6, $s4, $zero

add $s5, $zero, $zero # s0 = 0
     
      add $t0, $s5, $a1 #addr de string1[i] in $t1
      lbu  $t1, 0($t0)  #t2 = string1[i]
      
      add $t2, $s5, $a2 #addr de string2[i] in $t1
      lbu $t3, 0($t2)   #t2 = string1[i]
            
      bgt $t1, $t3, inverter_posicoes
      blt $t1, $t3, Fim_String
      addi $s5, $s5, 1
      j Comparacao
          
      inverter_posicoes:
      add $t7, $zero, $zero
      jal inverter
      or $31, $v1, $zero
      addi $s1, $s1, 24
      j for_j
      
      Condicao_ranking:
      lwc1 $f1,  vetor_categoria($s1)
      add $t5, $s1, $zero
      addi $t5, $t5, -20 

      lwc1 $f2, vetor_categoria($s4)
      add $t6, $s4, $zero
      addi $t6, $t6, -20
      c.lt.s 6 $f1, $f2
      bc1f 6 maior
      j inverter_posicoes
      
      maior: 
      addi $s1, $s1, 24
      j for_j
      
      Fim_String:
      addi $s1, $s1, 24
      j for_j
      
sair_j:
addi $t0, $zero, 6
beq $s7, $t0, setar_j
addi $s0, $s0, 24
add $s1, $zero, $zero # $s1 = j = zero
j for_i

setar_j:
addi $s0, $s0, 24
addi $s1, $zero, 20 # $s1 = j = 20
j for_i

sair_i:
add $t0, $zero, $zero
add $t1, $zero, $zero
add $s5, $zero, $zero
la $a1, vetor_categoria($t0)
li $t5, 20
li $v0, 4
la $a0, msgCabecalho #imprime cabeçalho da 6
syscall

impressao_tabela:
li $v0, 4
la $a0, msgPulaLinha #imprime Pula Linha
syscall

li $v0, 11
addi $a0, $zero, 32
syscall

beq $t5, $zero, fim_string
addi $t1, $t1, 1

add $a0, $t1, $zero
li $v0,1
syscall

li $v0, 11
addi $a0, $zero, 32
syscall

li $v0, 11
addi $a0, $zero, 32
syscall

impressao_caracteres:
beq $t5, $zero, fim_string
add $t2, $s5, $a1 #addr de string2[i] in $t1
lbu $t3, 0($t2)   #t3 = string1[i]

beq $t3, $zero, imprimir_espaco
li $t4, 0x10
ble $t3, $t4, imprimir_espaco

li $v0, 11
add $a0, $zero, $t3
syscall
addi $s5, $s5, 1
addi $t5, $t5, -1
j impressao_caracteres

imprimir_espaco:
li $v0, 11
addi $a0, $zero, 32
syscall
addi $s5, $s5, 1
addi $t5, $t5, -1
beq $t5, $zero, fim_string
j imprimir_espaco

fim_string:
lwc1 $f12, vetor_categoria($s5)
li $v0, 2
syscall
addi $s5, $s5, 4
li $t5, 20

lw $s2, posicao_categoria
bne $s5, $s2, impressao_tabela

li $v0, 4
la $a0, msgPulaLinha #imprime Pula Linha
syscall

sw $zero, posicao_categoria
jr $ra
