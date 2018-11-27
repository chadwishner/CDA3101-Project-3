.section .data

	prompt:
		.asciz "Input an integer: "
	stringread:
		.asciz "%s" 
	intbuffer:
		.space 32
	intformat:
		.asciz "%d"
	printstring:
		.asciz "00000000000000000000000000000000"
	flush:
		.asciz "\n"

.text
.global main

main:
 	#print prompt
	ldr x0, =stringread
	ldr x1, =prompt
	bl printf

	#save input
	ldr x0, =intformat
	ldr x1, =intbuffer
	bl scanf

	#load integer input into x9 for further calculations
	ldr x9, =intbuffer
	ldr x9, [x9]
	ldr x11, =printstring
	
	#instantiate variables for later use (x12 for division, x13 for string position pointer, w14 for ascii value)
	mov x12, #2
	mov x13, #31
	mov w14, #49

loop:
	
	#load x10 with either a 0 or 1 for the binary reprentation of the smallest digit
	#tried using MOD, but it didnt work so i did it myself
	
	#x15 = x9/x12 (2)
	udiv x15, x9, x12 
	#x16 = x15 * x12
	mul x16, x15, x12
	#x10 = x9 - x16
	sub x10, x9, x16

	#if x10 != 0, then we must add that bit "1" in the proper position of the string
	cbnz x10, addbit
	
return:	
	#decriment x13 to get the proper position for the next "1" or "0"
	sub x13, x13, #1

	# x9 = x9 / x12 in order to caclculate the next bit
	udiv x9, x9, x12

    #if x9 is zero, then we have reached the end of the conversion and can print the binary we calculated
	cbz x9, printbinary

	#if not loop back to calculate the next bit
	b loop

addbit:
	#add the "1" in x11[x13]
	strb w14, [x11, x13]
	#return back to previous position in loop
	b return

printbinary:
	
	#print the binary output
	ldr x0, =stringread
	
	#fix x13 to point to the right character, and print out from that character onward
	add x13, x13, #1
	add x1, x11, x13

	bl printf

	#flush
	ldr x0, =stringread
	ldr x1, =flush
	bl printf	

	#exit program
	b exit

exit:       
	#exit program
	mov x0, #0
    mov x8, #93
    svc #0
