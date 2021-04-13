                .global read_board
                .text

// read_board(*input, *board) ->
//     0 for success
//     1 for input too short
//     2 for input contains invalid character
//     3 for input too long

read_board:
		// x0 is input string
		// x1 is board array
		mov x2, #0 // Induction variable
		mov x3, #0 // Current character		

.check:
		ldrb w3, [x0, x2]
		cmp x2, #81
		b.ge .long
		
.short:
		cbnz x3, .unfilled
		mov x0, #1
		ret

.unfilled:
		cmp x3, #'.'
		b.ne .filled
		str wzr, [x1, x2]
		b .endloop

.filled:
		cmp x3, #'1'
		b.lt .invalid
		cmp x3, #'9'
		b.gt .invalid
		sub x3, x3, #'0'
		str x3, [x1, x2]
		b .endloop

.invalid:
		mov x0, #2
		ret

.endloop:
		add x2, x2, #1
		b .check

.long:
		cbz x3, .end
		mov x0, #3
		ret
.end:
		mov x0, #0
		ret

