# Homework #1
# name: Vidar Minkovsky
# sbuid: 109756598

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
# Helper macro for grabbing command line arguments
.macro load_args
lw $t0, 0($a1)
sw $t0, arg1
lw $t0, 4($a1)
sw $t0, arg2
.end_macro

.text
.globl main
main:
load_args() # Only do this once