                .global _start

                .equ    stdin, 0
                .equ    stdout, 1
                .equ    sys_read, 63
                .equ    sys_write, 64
                .equ    sys_exit, 93

		.data
prompt:		.ascii "Please type in a Sudoku puzzle to solve:\n> "
		.equ prompt_size, .-prompt
short:		.ascii "The input was too short\n"
		.equ short_size, .-short
long:		.ascii "The input was too long\n"
		.equ long_size, .-long
invalid:	.ascii "The input contained invalid characters\n"
		.equ invalid_size, .-invalid
unsolvable:	.ascii "The board has no solution\n"
		.equ unsolvable_size, .-unsolvable
		
		.bss
input:		.space 128
		.equ input_size, .-input

board:		.space 81
		.equ board_size, .-board		

		.text
_start:
                // prompt user
		mov x0, #stdout
		ldr x1, =prompt
		ldr x2, =prompt_size
		mov x8, #sys_write
		svc #0

		// read input
		mov x0, #stdin
		ldr x1, =input
		ldr x3, =input_size	// input size - 1
		sub x3, x3, #1
		mov x2, x3
		mov x8, #sys_read
		svc #0

		// no bytes read or last byte not a newline - > add a zero byte to end
		ldr x1, =input
		mov x2, #0
		
		ldrb w3, [x1, x2]
		cbz x3, .add_zero

.startloop:
		ldrb w3, [x1, x2]
		cbnz x3, .endloop
		
		sub x2, x2, #1
		ldrb w3, [x1, x2]
		cmp x3, #'\n'
		b.eq .overwrite
		b .add_zero 

.endloop:
		add x2, x2, #1
		b .startloop		
			
.add_zero:
		strb wzr, [x1, #82]
		b .read_board

.overwrite:
		strb wzr, [x1, x2]

.read_board:
		// parse with 'read_board'
		ldr x0, =input
		ldr x1, =board
		bl read_board

		cbz x0, .valid
.short:
		cmp x0, #1
		b.ne .invalid
		mov x0, #stdout
		ldr x1, =short
		ldr x2, =short_size
		mov x8, #sys_write
		svc #0
		b .return

.invalid:
		cmp x0, #2
		b.ne .long
		mov x0, #stdout
		ldr x1, =invalid
		ldr x2, =invalid_size
		mov x8, #sys_write
		svc #0
		b .return

.long:
		mov x0, #stdout
		ldr x1, =long
		ldr x2, =long_size
		mov x8, #sys_write
		svc #0
		b .return

.valid:
		// solve
		ldr x0, =board
		bl solve

		cbz x0, .print_board
		
		mov x0, #stdout
		ldr x1, =unsolvable
		ldr x2, =unsolvable_size
		mov x8, #sys_write
		svc #0

		b .return

.print_board:
		// print solved board
		ldr x0, =board
		bl print_board
		
.return:
		mov x0, #0
                mov     x8, #sys_exit
               	svc     #0
