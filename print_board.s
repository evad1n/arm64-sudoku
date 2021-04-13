                .global print_board
                .equ    stdout, 1
                .equ    sys_write, 64

		.data
.border:	.ascii  "+-------+-------+-------+\n"
		.balign 8

.template:	.ascii	"| 1 2 3 | 4 5 6 | 7 8 9 |\n"
		.equ .template_size, .-.template
		.balign 8

		.text

// print_board(board) -> 0 for success, >0 for error
print_board:
		mov x3, x0	// board	
		mov x4, #0	// outer loop induction variable
		mov x5, #0	// board index
		
.startloop:
		cmp x4, #13
		b.ge .return
		
		mov x7, #4	
		udiv x6, x4, x7
		mul x6, x6, x7
		sub x6, x4, x6
		
		cbnz x6, .numbers
		
		mov x0, #stdout
		ldr x1, =.border
		ldr x2, =.template_size
		b .write

.numbers:
		mov x0, #stdout	
       		ldr x1, =.template              // where to find the data to write
       		ldr x2, =.template_size		// number of bytes to write
		mov x6, #0			// inner loop induction variable
		mov x7, #0       		// inner loop border spacing counter

		// loop through numbers
		// create algorithm to skip borders
.readloop:
		cmp x6, #9
		b.ge .write

		ldrb w8, [x3, x5]	// get char to write
		add x8, x8, #'0'	// get ascii code for that number
		cmp x8, #'0'
		b.ne .find_position

		mov x8, #' '

.find_position:	
		mov x11, #9
	
		udiv x9, x5, x11	// modulus board index by 9 to get line index
		mul x9, x9, x11
		sub x9, x5, x9		// x9 has index i

		mov x11, #3

		udiv x10, x9, x11	// if multiple of 3
		mul x10, x10, x11
		sub x10, x9, x10

		cbnz x10, .load_char

		add x7, x7, #2 		// add border spacing

.load_char:
		mov x11, #2
		mul x9, x9, x11
		add x9, x7, x9		
		strb w8, [x1, x9]	// Stores at value[i] i = (2i + border) 
				
.end_readloop:
		add x6, x6, #1
		add x5, x5, #1
		b .readloop

.write:
		mov x8, #sys_write              
       		svc #0

.endloop:
		add x4, x4, #1
		b .startloop


.return:
		mov x0, #0
		ret
