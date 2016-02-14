# Homework #1
# name: Vidar Minkovsky
# sbuid: 109756598

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
	#li $s0, 0 		# Set sum to 0
	#li $s1, 0 		# Set isNegative to false
	
	lw $t0, 0($a1)
	lw $t0, 0($t0)
	lb $t1, 0($t0)
	srl $t2, $t0, 24
	
	
	#move $a0, $s2 		# Move word to s2
	#li $t0, 1 		# position = 1
	#li $t1, 0 		# i = 0
	
	#and $s3, $s2, $t0	# bit = num & position
	
	
	lw $a0, arg1
	li $v0, 4
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
