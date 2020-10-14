 .data
    path:                .asciiz "pokeTypes.txt"  #write the absolute path
    buffer:              .space 1824
    menu:                .space 400
    pokemon:             .space 120
    types:               .space 120 
    chosen_type1:        .space 11
    chosen_type2:        .space 11
    chosen_pokemon1:     .space 11
    chosen_pokemon2:     .space 11
    number1:             .space 15
    number2:             .space 15 
    columns:             .word  18
    types_valores:       .asciiz "normal,fighting,flying,poison,ground,rock,bug,ghost,steel,fire,water,grass,electric,psychic,ice,dragon,dark,fairy"
    atack_matrix:        .float 1    1    1    1    1   0.5   1    0   0.5   1    1    1    1    1    1    1    1    1
                         .float 2    1   0.5  0.5   1    2    0.5  0    2    1    1    1    1   0.5   2    1    2   0.5
                         .float 1    2    1    1    1   0.5   2    1   0.5   1    1    2   0.5   1    1    1    1    1
                         .float 1    1    1   0.5  0.5  0.5   1    0.5  0    1    1    2    1    1    1    1    1    2
                         .float 1    1    0    2    1    2   0.5   1    2    2    1   0.5   2    1    1    1    1    1
                         .float 1   0.5   2    1   0.5   1    2    1   0.5   2    1    1    1    1    2    1    1    1
                         .float 1   0.5  0.5  0.5   1    1    1   0.5  0.5  0.5   1    2    1    2    1    1    2   0.5
                         .float 0    1    1    1    1    1    1    2    1    1    1    1    1    2    1    1   0.5   1
                         .float 1    1    1    1    1    2    1    1   0.5  0.5  0.5   1   0.5   1    2    1    1    2
                         .float 1    1    1    1    1   0.5   2    1    2   0.5  0.5   2    1    1    2   0.5   1    1
                         .float 1    1    1    1    2    2    1    1    1    2   0.5  0.5   1    1    1   0.5   1    1
                         .float 1    1   0.5  0.5   2    2   0.5   1   0.5  0.5   2   0.5   1    1    1   0.5   1    1
                         .float 1    1    2    1    0    1    1    1    1    1    2   0.5  0.5   1    1   0.5   1    1
                         .float 1    2    1    2    1    1    1    1   0.5   1    1    1    1   0.5   1    1    0    1
                         .float 1    1    2    1    2    1    1    1   0.5  0.5  0.5   2    1    1   0.5   2    1    1
                         .float 1    1    1    1    1    1    1    1   0.5   1    1    1    1    1    1    2    1    0
                         .float 1   0.5   1    1    1    1    1    2    1    1    1    1    1    2    1    1   0.5  0.5
                         .float 1    2    1   0.5   1    1    1    1   0.5  0.5   1    1    1    1    1    2    2    1

                                                                    
    
   welcome_msg:          .asciiz "********Welcome to the Pokemon Battle Game********\n"
    #_____________________________________________________________________________________#
   bucle:                .asciiz "\nBoth Pokemon have 0 point attack\nCannot define a winner\n"
   msgOption:            .asciiz "\nEnter the number of the first Pokemon for the Combat: "
   msgOption2:           .asciiz "\nEnter the number of the second Pokemon for the Combat: "
   exit_option:          .asciiz "11. Exit\n"
   error:                .asciiz "Error with the input data, you must enter a number: "
   validNumber:          .asciiz "Error, enter a valid number (1 al 11): "
   msgSuccessExit:       .asciiz "EXIT PROGRAM SUCCESSFULLY\n"
   vs:                   .asciiz " vs. "
   msgPlayers:           .asciiz "\nFIGHTERS: "
   lineBreak:            .asciiz "\n"
   msgHealth:            .asciiz ": Health Points: "
   msgAttack:            .asciiz " Attack Points: "
   msgAttackTo:          .asciiz "   attacks   "
   msg_result:           .asciiz "\nATTACK RESULT: \n"
   winner:               .asciiz " is the Winner !!! "
   no_indice_tipo:       .asciiz "\nPokemon Type not found.\n"
   separator:            .asciiz "\n\n_________________________________________________________________________\n\n"
   decorator:            .asciiz "\n\n\n#########################################################################\n\n"
   space:                .asciiz "                      "
    
   .text
    
main:

 la $a0,welcome_msg 
 jal print_str

 jal getRandom
 move $s1, $v1      
 
 jal readFile
 la $a3, buffer
 la $a1, pokemon 
 move $a2, $s1    
 jal get_pokemon
 
 la $a3, pokemon
 jal print_menu_pokemon 
 
 jal print_menu      
 la $a0,msgOption 
 jal print_str
 jal input_number1
 	 
 move $a2, $v1
 la $a1, chosen_pokemon1
 la $a3, pokemon
 jal get_chosen
	
 la $a1, chosen_type1
 la $a3, types
 jal get_chosen
         
 la $a0,msgOption2 
 jal print_str
 jal input_number2
  	
 move $a2, $v1 
 la $a1, chosen_pokemon2
 la $a3, pokemon
 jal get_chosen
  	
 la $a1, chosen_type2
 la $a3, types
 jal get_chosen

 jal print_players
 j attack


        
#get the index of the matrix 
attack:
       
       la $a2, chosen_type1
       la $a3, types_valores
       jal get_index_type
       add $s1, $zero, $v1          #index type 1

       
       la $a2, chosen_type2
       la $a3, types_valores
       jal get_index_type
       add $s2, $zero, $v1          #index type2
       j validate_index
       
       
       
       
  #Get point attacks     
  point_attacks:     
        
       la $a3, atack_matrix
       add $a1, $zero, $s2    
       add $a2, $zero, $s1    
       jal getValue_row_column
       mov.s $f13, $f0                    
       
       #attack points of pokemon1 $s3
       jal get_attack  
       add $s3, $zero, $v1                
        
       add $a1, $zero, $s1
       add $a2, $zero, $s2
       jal getValue_row_column
       mov.s $f13, $f0               
            
       #attack points of pokemon2 $s4
       jal get_attack
       add $s4, $zero, $v1                
       
       
       beq $s3, $zero, check_ZeroHealthPoints
       
       j start_game

#Si ambos msgAttacks son de cero, bucle infinito
check_ZeroHealthPoints:
       beq $s4, $zero, finish_bucle
     

# $s1 Health Pokemon 1
# $s2 Health Pokemon 2                                              
start_game: 
      li $s1,5   #health points pokemon1         
      li $s2,5   #health points pokemon2       
      
      la $a0, lineBreak
      li $v0, 4
      syscall
 	
      #Call game function
      play:

	la $s0, chosen_pokemon1
	la $a3, chosen_pokemon2
	move $a1, $s3
	move $a2, $s1
	move $s6, $s4
	move $s7, $s2
	jal print_play_msg

	#decrease health points of pokemon 1
	sub $s2, $s2, $s3
	beq $s2, $zero, winner_player1
	blt $s2,$zero, winner_player1
	move $s7, $s2
	jal print_msg_result

	la $s0, chosen_pokemon2
	la $a3, chosen_pokemon1
	move $a1, $s4
	move $a2, $s2
	move $s6, $s3	
	move $s7, $s1
	jal print_play_msg

	#decrease health points of pokemon  2
	sub $s1, $s1, $s4
	beq $s1, $zero, winner_player2
	blt $s1,$zero, winner_player2
	move $s7, $s1
	jal print_msg_result

	j play

      winner_player1:
	li $s7, 0
	jal print_msg_result

	la $a1, chosen_pokemon1
	jal print_winner

      j finish_program


       winner_player2:
	li $s7, 0
	jal print_msg_result

	la $a1, chosen_pokemon2
	jal print_winner
      	
      		
      #Finish program				
      j finish_program
      
#Check if the index is valid
validate_index:
      blt $s2, $zero, finish_without_coincidence
      blt $s3, $zero, finish_without_coincidence 
      j point_attacks

#Termino si un �ndice es -1             
finish_without_coincidence:
      la $a0, no_indice_tipo
      li $v0, 4
      syscall 
      j finish_program



#-----------------------------------------------------------------FUNCTIONS-------------------------------------------------------

#GET FUNCTIONS -----------------------------------------------------

# $f13 pokemon factor
# $v1 return pokemon attack
# Return -1 if there is not coincidence
get_attack:
li $t4, 2
mtc1 $t4, $f4
cvt.s.w $f4, $f4

mul.s $f13, $f13, $f4
cvt.w.s $f13, $f13
mfc1 $t4, $f13
add $v1, $zero, $t4

jr $ra


# Find the index for a specific pokemon type in the matrix 
# $a2 chosen type for user
# $a3 buffer with all the pokemon types
# $v1 return index
get_index_type:
 addi $sp, $sp, -4
 sw $s0, 0($sp)
 
 move $s0, $a2
 addi $t4, $zero, 0  
 
 #loop compare types
 compare:
 lb $t2, 0($a2)       
 lb $t3, 0($a3)       
 beq $t2, 13, check_comma    
 beq $t2, $zero, check_comma
 bne $t2,$t3, next_type 
 addi $a2, $a2, 1
 addi $a3, $a3, 1
 j compare
 
 #if they are different, go to the next type
 next_type:
 lb $t3, 0($a3) 
 beq $t3, $zero, without_coincidence   
 beq $t3, 44, update_variables       
 addi $a3, $a3, 1    
 j next_type
 
 #Increase counter
 #Go to the next type after ,
 #Reload chosen type
 update_variables:
 addi $t4, $t4, 1                 
 addi $a3, $a3, 1                  
 move $a2, $s0                     
 j compare
 
 #Check if the next character is a comma 
 #is equal?
 check_comma:
 lb $t3, 0($a3)
 beq $t3, $zero, exit_get_index 
 bne $t3, 44, next_type     
 
 exit_get_index:               
 move $v1, $t4
 j return_index

 without_coincidence:            
 li $v1, -1                       
 j return_index
 
 return_index:
 lw $s0, 0($sp)
 addi $sp, $sp, 4
 jr $ra




# $a1 index desired row
# $a2 index desired column
# $a3 source-> matrix
# $f0 return value M[row, column]
getValue_row_column:
 addi $sp, $sp, -4
 sw $s2, 0($sp)
  
 lw $s2, columns  
 add $t1, $zero, $zero     #i para filas
 loop_rows:
 slt $t2, $t1, $s2 
 beq $t2, $zero, return_value
 mul $t3, $t1, $s2
  
 add $t4, $zero, $zero     # j para columns
 loop_columns:
 slt $t6, $t4, $s2
 beq $t6, $zero, end_column
 blt $t4, $a2, increase_columns
 bne $t1, $a1, end_column
     
 add $t5, $t3, $t4 
 sll $t5, $t5, 2
 add $t5, $t5, $a3   
 l.s $f0, 0($t5)     
 j return_value
    
 increase_columns:    
 addi $t4, $t4, 1
 j loop_columns
    
 end_column:
 addi $t1, $t1, 1
 j loop_rows
 
return_value: 
 lw $s2, 0($sp)
 addi $sp, $sp, 4
 jr $ra

  
    
 #Store the pokemon or chosen type 
 #a1 output buffer (chosen_type | chosen_pokemon) 
 #a2 number input pokemon / input user
 #a3 buffer that contains information (10 types | 10 pokemon)  
get_chosen:
 li $t1, 1                                   
 search_chosen:
 beq $a2, $t1, write_chosen
 lb $t3, 0($a3)
 beq $t3, $zero, end_get_chosen
 addi $a3, $a3, 1
 bne $t3, 10, search_chosen                 
 addi $t1, $t1, 1
 j search_chosen
 
 write_chosen:
 lb $t3, 0($a3)
 beq $t3, $zero, end_get_chosen
 beq $t3, 10, end_get_chosen
 sb $t3, 0($a1)
 addi $a1, $a1, 1
 addi $a3, $a3, 1
 j write_chosen
 
 end_get_chosen:
 jr $ra
 
 
 #a1 output buffer 
 #a3 pokemon buffer
print_menu_pokemon:
 addi $t1, $zero, 49   
 li $t3, 0            
 la $a1, menu         
 la $s1, 10
 la $t5, 46
 la $t7, 32
 
 add:
 slti $t4, $t3, 9
 beq $t4, $zero, add_last_index
 sb $t1, 0($a1)
 addi $a1, $a1, 1
 sb $t5, 0($a1)
 addi $a1, $a1, 1
 sb $t7, 0($a1)
 addi $a1, $a1, 1
 
 loop:
 lb $t2, 0($a3)
 beqz $t2, end_menu_pokemon
 beq $t2, $s1, sum
 sb $t2, 0($a1)
 addi $a1,$a1,1
 add $a3, $a3,1
  j loop 
 
 sum:
 add $a3, $a3,1
 sb $s1, 0($a1)
 addi $a1, $a1, 1
 addi $t3, $t3, 1
 addi $t1, $t1, 1
 j add

 add_last_index:
 slti $s4, $t3, 10
 beq $s4, $zero, end_menu_pokemon
 addi $s5, $zero, 49
 sb $s5, 0($a1)
 addi $a1, $a1, 1
 addi $s5, $s5, -1
 sb $s5, 0($a1)
 addi $a1, $a1, 1
 addi $s5, $s5, -2
 sb $s5, 0($a1)
 addi $a1, $a1, 1
 addi $s5, $s5, -14
 sb $s5, 0($a1)
 addi $a1, $a1, 1
 j loop
 
 end_menu_pokemon:
 jr $ra
 
 #Get 10 pokemon
 #a1 output buffer
 #a2 random
 #a3 buffer with all txt
 #t1 lines counter
 #t3 counter for 10 lines selected
get_pokemon:
 addi $sp, $sp, -12
 sw $s1, 0($sp)
 sw $s2, 4($sp)
 sw $s3, 8($sp)
 
 li $t1, 1 
 li $t3, 0  
 la $s1, 10  
 la $s2, 44  
 la $s3, types
 
 search_lines:
 beq $a2, $t1, get_pokemon10  
 lb $t2, 0($a3)                  
 beq $t2, $zero, end_get_pokemon           
 addi $a3, $a3, 1               
 bne $t2, $s1, search_lines     
 addi $t1, $t1, 1               
 j search_lines                

  get_pokemon10:
  slti $t4, $t3, 10               
  beq $t4, $zero, end_get_pokemon           
  
  lb $t2, 0($a3)                 
  beq $t2, $zero, end_get_pokemon            
  beq $t2, $s2, add_salto    
  sb $t2, 0($a1)                 
  addi $a1,$a1,1                 
  addi $a3, $a3,1
                 
  j get_pokemon10
  
  add_salto:
  addi $a3, $a3, 1
  sb $s1, 0($a1)                
  addi $a1, $a1, 1             
  
  go_next_line:
  lb $t2, 0($a3)
  beq $t2, $zero, end_get_pokemon
  bne $t2, $s1, process_type       
  sb $s1, 0($s3)
  addi $s3, $s3, 1
  addi $a3, $a3, 1
  addi $t3, $t3, 1            
  j get_pokemon10
  
  process_type:
  lb $t2, 0($a3)
  beq $t2, $zero, end_get_pokemon
  beq $t2, 32, next
  beq $t2, 9, next
  sb $t2, 0($s3)                
  addi $s3,$s3,1                
  next:
  addi $a3, $a3,1
  j go_next_line

  
 end_get_pokemon:
 lw $s1, 0($sp)
 lw $s2, 4($sp)
 lw $s3, 8($sp)
 addi $sp, $sp, 12
 jr $ra


#READ-FUNCTIONS-------------------------------------------------

#read and store buffer 
readFile:

 addi $sp, $sp, -8
 sw $t0, 0($sp)
 sw $t1, 4($sp)
  
 # open file
 li $v0, 13       
 la $a0, path     
 li $a1, 0        
 syscall          
 move $t0, $v0    		
 
 li $v0, 14        
 la $a1, buffer    
 li $a2, 1824     
 move $a0, $t0     		
 syscall           
 
 # close file
 li $v0, 16       
 move $a0, $t0    
 syscall      
 
 lw $t0, 0($sp)
 lw $t1, 4($sp)
 addi $sp, $sp, 8
 jr $ra    
 
#RANDOM-FUNCTIONS-----------------------------------------------------    
          
#Generate- random
getRandom:
   
  addi $sp, $sp, -4
  sw $t1, 0($sp)
  
  li $a1, 99   
  li $v0, 42   
  syscall
  add $a0, $a0, 1 
  move $t1, $a0 
  add $v1, $t1, $zero
  
  lw $t1, 0($sp)
  addi $sp, $sp, 4
  jr $ra


#INPUT FUNCTIONS ------------------------------------------------------

#Input First Pokemon
#v1 return number 
#t4 accumulate number
input_number1:
 is_number:
  la $a0, number1
  li $v0, 8
  li $a1, 15
  move $t0, $a0
  syscall
  li $t4, 0
 check_character_code: 
  lb $t1, 0($t0)
  beq $t1, 10, check_range
  slti $t2, $t1, 58
  beq $t2, $zero, ask_again
  slti $t2, $t1, 48
  bne $t2, $zero, ask_again
  
  mul $t5, $t4, 10
  addi $t4, $t1, -48
  add $t4, $t4, $t5
  addi $t0, $t0, 1
  j check_character_code
  
 ask_again:
 la $a0, error
 li $v0, 4
 syscall 
 j input_number1  
 
  show_message1:
  li $v0, 4
  la $a0, validNumber
  syscall
  j input_number1  
 
 check_range:
 beq $t4, $zero, show_message1
 slti $t3, $t4, 12
 beq $t3, $zero, show_message1
 beq $t4,11,finish_success
 	
 move $v1, $t4
 jr $ra    
  
  
  
#Pedir N�mero para el Segundo Pok�mon
#Retorna el n�mero en $v1 
input_number2:
 is_number2:
  la $a0, number2
  li $v0, 8
  li $a1, 15
  move $t0, $a0
  syscall
  li $t4, 0
 check_character_code2: 
  lb $t1, 0($t0)
  beq $t1, 10, check_range2
  slti $t2, $t1, 58
  beq $t2, $zero, ask_again2
  slti $t2, $t1, 48
  bne $t2, $zero, ask_again2
  
  mul $t5, $t4, 10
  addi $t4, $t1, -48
  add $t4, $t4, $t5
  addi $t0, $t0, 1
  j check_character_code2
  
 ask_again2:
 la $a0, error
 li $v0, 4
 syscall 
 j input_number2  
 
  show_msg:
  li $v0, 4
  la $a0, validNumber
  syscall
  j input_number2  
 
 check_range2:
 beq $t4, $zero, show_msg 
 slti $t3, $t4, 12
 beq $t3, $zero, show_msg
 beq $t4,11,finish_success
 	
 move $v1, $t4
 jr $ra
 
#FUNCTIONS PRINT---------------------------------------------------

#Print Menu
print_menu: 
 la $a0, menu
 li $v0, 4
 syscall
 la $a0,exit_option 
 li $v0,4
 syscall 
 jr $ra 
 
#move to $a0 the string 
print_str:
 li $v0, 4
 syscall
 jr $ra
 
#move to $a0 the integer
print_int:
 li $v0, 1
 syscall 
 jr $ra
 
print_players:
 la $a0,msgPlayers 
 li $v0, 4
 syscall
 la $a0, chosen_pokemon1
 li $v0, 4
 syscall
 la $a0,vs  
 li $v0, 4
 syscall
 la $a0, chosen_pokemon2
 li $v0, 4
 syscall
 jr $ra
 
 
#Print result
# before use
# la $a0, pokemon_winner
print_result:
 li $v0, 4
 syscall
 la $a0, winner
 li $v0, 4
 syscall
 la $a0, decorator
 li $v0, 4
 syscall
 jr $ra

print_separator: 
 la $a0, separator
 li $v0, 4
 syscall
 jr $ra
 

#a1 pokemon winner name
print_winner:
la $a0, decorator
li $v0, 4
syscall

move $a0, $a1
syscall

la $a0, winner
syscall

la $a0, decorator
li $v0, 4
syscall

jr $ra


#s0 pokemon attacker name
#a3 pokemon victim name
#a1 attacker attack points
#a2 attacker health points
#s6 victim attack points
#s7 victim health points
print_play_msg:
 la $a0, separator
 li $v0, 4
 syscall

 move $a0, $s0
 syscall
 
 la $a0,msgHealth
 syscall
 
 move $a0, $a2
 li $v0, 1
 syscall
 
 la $a0,msgAttack
 li $v0, 4
 syscall
 
 move $a0, $a1
 li $v0, 1
 syscall
 
 la $a0,msgAttackTo
 li $v0, 4
 syscall
 
 move $a0, $a3
 syscall
 
 la $a0,msgHealth
 syscall
 
 move $a0, $s7
 li $v0, 1
 syscall
 
 la $a0,msgAttack
 li $v0, 4
 syscall
 
 move $a0, $s6
 li $v0, 1
 syscall
 jr $ra
 
 
#s0 pokemon attacker name
#a3 pokemon victim name
#a2 attacker health points
#s7 victim health points 
print_msg_result:
 la $a0, msg_result
 li $v0, 4
 syscall 
 
 
 move $a0, $s0
 li $v0, 4
 syscall
 
 la $a0,msgHealth
 li $v0, 4
 syscall
 
 move $a0, $a2
 li $v0, 1
 syscall

 
 la $a0,lineBreak
 li $v0, 4
 syscall
 
 move $a0, $a3
 li $v0, 4
 syscall
 
 la $a0,msgHealth
 li $v0, 4
 syscall
 
 move $a0, $s7
 li $v0, 1
 syscall
 
 
 jr $ra


 

#VALIDATOR FUNCTIONS------------------------------------------------



#FUNCTIONS EXIT ----------------------------------------------------
finish_program:
li $v0,10
syscall

#Finalizar en caso 0,0  
finish_bucle:
 la $a0, bucle
 li $v0, 4
 syscall 
 li $v0, 10
 syscall
 
finish_success: 
 li $v0, 4
 la $a0, msgSuccessExit
 syscall
 li $v0, 10
 syscall
 



