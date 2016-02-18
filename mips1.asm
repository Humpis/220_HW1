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
	
	li $s1, 0				# init the stored second arg to 0
	lw $t1, arg2				# address of second arg
	beqz $t1, no_second_arg			# hit NULL character at end of string
	lb $t2, 0($t1)				# letter of arg2	
	#beqz $t2, no_second_arg		# hit NULL character at end of string
	
	beq $t2, '1', arg2_1			# string[i] is "1"
	beq $t2, 's', arg2_s			# string[i] is "s"
	beq $t2, 'g', arg2_g			# string[i] is "g"

no_second_arg:
	la $a0, error 				# print error if its not 1,s,or g
	li $v0, 4				# syscall 4 is print_string
	syscall
	j exit
	
arg2_1:
	li $s1, 1				# change stored second arg to 1
	addi $t1, $t1, 1			# advance to next character of string
	lb $t2, 0($t1)				# letter of arg2
	beqz $t2, main2				# hit NULL character at end of string
	la $a0, error 				# print error if its not 1,s,or g
	li $v0, 4				# syscall 4 is print_string
	syscall
	j exit
	
arg2_s:
	li $s1, 2				# change stored second arg to 2
	addi $t1, $t1, 1			# advance to next character of string
	lb $t2, 0($t1)				# letter of arg2
	beqz $t2, main2				# hit NULL character at end of string
	la $a0, error 				# print error if its not 1,s,or g
	li $v0, 4				# syscall 4 is print_string
	syscall
	j exit
	
arg2_g:
	li $s1, 3				# change stored second arg to 3
	addi $t1, $t1, 1			# advance to next character of string
	lb $t2, 0($t1)				# letter of arg2
	beqz $t2, main2				# hit NULL character at end of string
	la $a0, error 				# print error if its not 1,s,or g
	li $v0, 4				# syscall 4 is print_string
	syscall
	j exit

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
	beq $t3, 0, done2			# not negative
	sub $t0, $zero, $t0			# negative
	
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
	
	
	la $a0, endl 				# print new line
	li $v0, 4				# syscall 4 is print_string
	syscall	
# for 1's compliment	
	bge $s1, 2, sign_magnitude		# if its not 1s compliment
	la $a0, one				# print ones compliment
	li $v0, 4				# syscall 4 is print_string
	syscall	
	beq $t3, 0, not_negative1s		# not negative
	li $t7, 1				# for subtracting by 1
	sub $t0, $t0, $t7			# subtract 1 if it is ones compliment and negative
	
not_negative1s:
	move $a0, $t0				# get sum
	li $v0, 34				# syscall 34 is print integer in hex
	syscall
	j exit
	
sign_magnitude:
	bge $s1, 3, gray_code			# if its not sign magnitude
	la $a0, sm				# print sign mag
	li $v0, 4				# syscall 4 is print_string
	syscall	
	
	beq $t3, 0, not_negative_sm		# not negative
	li $t7, 1				# for subtracting by 1
	#sub $t0, $t0, $t7			# subtract 1 if it is negative
	sub $t0, $zero, $t0			# flip the bits
	li $t7, 1				# for 8 to be the first bit
	li $t8, 31				# I have no idea why it is 28
	sllv $t7, $t7, $t8			# if neg, put sign ???
	add $t0, $t0, $t7			# this works, but how it does is beyond me
	
not_negative_sm:
	move $a0, $t0				# get sum
	li $v0, 34				# syscall 34 is print integer in hex
	syscall
	j exit
	
gray_code:
	bge $s1, 4, exit			# if its not gray code
	la $a0, gray				# print gray
	li $v0, 4				# syscall 4 is print_string
	syscall
	srl $s3, $t0, 1				#store shifted num in s3	
	xor $t0, $t0, $s3			#xor shifted and num
	move $a0, $t0				# get sum
	li $v0, 34				# syscall 34 is print integer in hex
	syscall
	j exit
	
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
