.data

vals: .word 8,8,3,1,5,6,2
.eqv n, 8

.text 

main:

#Bubble Sort
li x1,n
addi x1, x1, -1
li x2, 0

Loop:
bge x2, x1, exit
	la x4, vals
	li x3, 0 
	
	loop_inner:
	bge x3, x1 exit_inner
		lw x5, 0(x4)
		lw x6, 4(x4)
		
		ble x5, x6, skip
		
		sw x6, 0(x4)
		sw x5, 4(x4)
	
skip:	
addi x3, x3, 1
addi x4, x4, 4

j loop_inner
	
exit_inner:
addi x2, x2, 1
j Loop

exit:
