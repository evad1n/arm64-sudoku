                .global get_within_column
                .text

// get_within_column(board, column, n)
get_within_column:
                // x0 board
		// x1 row
		// x2 n
		mov x3, #9
		// x4 index

		mul x4, x2, x3
		add x4, x4, x1
		ldrb w5, [x0, x4]
		mov x0, x5
		ret
