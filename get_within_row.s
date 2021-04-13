                .global get_within_row
                .text

// get_within_row(board, row, n)
get_within_row:
		// x0 board
		// x1 row
		// x2 n
		mov x3, #9
		// x4 index

		mul x4, x1, x3
		add x4, x4, x2
		ldrb w5, [x0, x4]
		mov x0, x5
                ret
