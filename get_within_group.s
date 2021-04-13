                .global get_within_group
                .text

// get_within_group(board, group, n)
get_within_group:
		// x0 board
		// x1 row
		// x2 n
		mov x3, #3
		mov x4, #9

.row:		
		udiv x5, x1, x3
		mul x5, x5, x3
		udiv x6, x2, x3
		add x7, x5, x6

.column:
		udiv x5, x1, x3
		mul x6, x5, x3
		sub x5, x1, x6
		
		mul x6, x5, x3

		udiv x5, x2, x3
		mul x3, x5, x3
		sub x5, x2, x3

		add x8, x6, x5

		mul x9, x7, x4
		add x9, x9, x8
		ldrb w1, [x0, x9]
		mov x0, x1
                ret
