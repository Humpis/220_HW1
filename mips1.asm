.text

# Helper macro for grabbing command line arguments
.macro load_args
	lw $t0, 0($a1)
	sw $t0, arg1
	lw $t0, 4($a1)
	sw $t0, arg2
.end_macro

.globl main

main:
	load_args()				# Only do this once0
	
	lw $t1, arg2				# address of second arg
	lb $t2, 0($t1)				# letter of arg2
	beq $t2, '1', arg2_1			# string[i] is "1"
	beq $t2, 's', arg2_s			# string[i] is "s"
	beq $t2, 'g', arg2_g			# string[i] is "g"
	
	la $a0, error 				# print error
	li $v0, 4				# syscall 4 is print_string
	syscall
	j exit
	
arg2_1:
	j main2
	
arg2_s:
	j main2
	
arg2_g:
	j main2

main2:
	li $t0, 0				# sum
	lw $t1, arg1				# address of string
	li $t3, 0				# initialize negative to false
	li $t4, 48				# for converting ascii to decimal
	li $t6, 10				# for multiplication by 10
	
	lb $t2, 0($t1)				# string[i]
	beq $t2, 45, negative			# string[i] is "-"
	j loop1
	
negative:
	li $t3, 1				#set negative to true
	j next_char
	
loop1:
	lb $t2, 0($t1)				# string[i]
	beqz $t2, done1				# hit NULL character at end of string
	blt $t2, 48, done1			# minimum ASCII value
	bgt $t2, 57, done1		 	# maximum ASCII value
	sub $t5, $t2, $t4			# set t5 to the decimal value of string[i]
	mul $t0, $t0, $t6			# sum = sum * 10
	add $t0, $t0, $t5			# sum = sum + deciamal value of string[i]

next_char:		
	addi $t1, $t1, 1			# advance to next character of string
	j loop1	

done1:
	beq $t3, 0, done2
	sub $t0, $zero, $t0
	
done2:
	la $a0, msg1 	
	li $v0, 4				# syscall 4 is print_string
	syscall
	
	lw $a0, arg1				# get input
	li $v0, 4				# syscall 4 is print_string
	syscall
	
	la $a0, msg2 	
	li $v0, 4				# syscall 4 is print_string
	syscall	
	
	move $a0, $t0				# get sum
	li $v0, 1				# syscall 1 is print_integer
	syscall

	la $a0, endl 	
	li $v0, 4				# syscall 4 is print_string
	syscall		
	
	la $a0, msg3 	
	li $v0, 4				# syscall 4 is print_string
	syscall
	
	move $a0, $t0				# get sum
	li $v0, 34				# syscall 34 is print integer in hex
	syscall

exit:
	# terminate program
	li $v0, 10
	syscall

.data
.align 2
arg1: .word 0
arg2: .word 0
error: .asciiz "Incorrect argument provided.\n"
sm: .asciiz "Signed Magnitude: "
one: .asciiz "One's Complement: "
gray: .asciiz "Gray Code: "
dbl: .asciiz "Double Dabble: "
msg1: .asciiz "You entered "
msg2: .asciiz " which parsed to "
msg3: .asciiz "In hex it looks like "
endl: .ascii "\n"
