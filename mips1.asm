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
	load_args()		# Only do this once
	# counts number of uppercase letters: ASCII values in the range 65-90
	li $t0, 0	# count of uppercase letters
	lw $t1, arg1	# address of string
	
loop1:
	lb $t2, 0($t1)		# string[i]
	beqz $t2, done1		# hit NULL character at end of string
	blt $t2, 65, not_uppercase_letter # minimum ASCII value
	bgt $t2, 90, not_uppercase_letter # maximum ASCII value
	addi $t0, $t0, 1	# add 1 to count of uppercase letters

not_uppercase_letter:		
	addi $t1, $t1, 1	# advance to next character of string
	j loop1

done1:
	la $a0, count_msg 	
	li $v0, 4		# syscall 4 is print_string
	syscall
	
	move $a0, $t0		# get count
	li $v0, 1		# syscall 1 is print_integer
	syscall
	
	la $a0, endl 	
	li $v0, 4		# syscall 4 is print_string
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
input: .asciiz "Computer Science @ Stony Brook University 2016"
count_msg: .asciiz "Number of uppercase letters: "
space: .asciiz " "
endl: .ascii "\n"
