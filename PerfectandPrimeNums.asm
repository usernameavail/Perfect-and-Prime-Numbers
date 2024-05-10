	.data

prompt_user:		.asciiz "Please enter in a value greater than 1: "
perfect_number:		.asciiz "\nThis value is a perfect number."
not_perfect_number:	.asciiz "\nThis value is not a perfect number."
prime_number:		.asciiz "\nThe value is prime.\n\n"
not_prime_number:	.asciiz "\nThe value is not prime.\n\n"
your_number:		.asciiz "Your number was: "
factor_number:		.asciiz "\nThe sum of the factor of these numbers is: "
plus:			.asciiz "+"
new_line:		.asciiz "\n"
exiting_program:	.asciiz "Exiting program."
			.align 2
	

factor_array:		.space 100 #up to 25 factors



	.text
	.globl main
	
main:


	li $t7, 0 # using t7 for the array index
	li $t8, 0 # loop counter for displaying array

	li $v0, 4
	la $a0, prompt_user
	syscall

	
	li $v0, 5
	syscall
	

	move $t0, $v0
	
	bgt $t0, 1, is_perfect
	
	li $v0, 4
	la $a0, exiting_program
	syscall
	

	jr $ra
	
	

is_perfect:

	li $t1, 0 #variable for a sum value of factors

	li $t2, 1 #divisor
	
	j is_a_factor


prime:
	li $v0, 4
	la $a0, prime_number
	syscall

	j main


not_prime:

	li $v0, 4
	la $a0, not_prime_number
	syscall

	j main
	
	
perfection:

	li $v0, 4
	la $a0, perfect_number
	syscall

	j is_prime
	

not_perfect:
	li $v0, 4
	la $a0, not_perfect_number
	syscall

	j is_prime
	beq $s1, 1, prime

	j not_prime
	

is_a_factor:

	bge $t2, $t0, factor_loop_over #break if t2 >= n
	divu $t0, $t2
	mfhi $t3
	beq $t3, 0, add_divisor #if t3 = 0, it is a divisor

	j increment


add_divisor:

	sw $t2, factor_array($t7)
	addi $t7, $t7, 4
	add $t1, $t1, $t2


increment:
	
	addi $t2, $t2, 1
	j is_a_factor


factor_loop_over:

	li $v0, 4
	la $a0, your_number
	syscall

	li $v0, 1
	move $a0, $t0
	syscall

	li $v0, 4
	la $a0, factor_number
	syscall

	li $v0, 1
	move $a0, $t1
	syscall

	li $v0, 4
	la $a0, new_line
	syscall
	

	j print_sum_of_factors


perfectTrue:

	li $s0, 1
	j endPerfect


perfectFalse:

	li $s0, 0
	j endPerfect


print_sum_of_factors:

	beq $t7, $t8, exit_loop

	li $v0, 1
	lw $a0, factor_array($t8)
	syscall

	addi $t8, $t8, 4

	j put_plus

	
put_plus:
	
	beq $t7, $t8, exit_loop
	li $v0, 4
	la $a0, plus
	syscall

	j print_sum_of_factors


exit_loop:

	beq $t1, $t0, perfectTrue
	j perfectFalse

	
endPerfect:

	beq $s0, 1, perfection #branch to perfection if the number is perfect.
	j not_perfect


is_prime:

	#base 0-2

	beq $t0, 0, prime_false
	beq $t0, 1, prime_false
	beq $t0, 2, prime_true


	beq $t1, 1, prime_true
	
	j prime_false

	
prime_true:

	li $s1, 1
	j prime_end
	
	
prime_false:

	li $s1, 0
	j prime_end


prime_end:

	beq $s1, 1, prime
	j not_prime

	
