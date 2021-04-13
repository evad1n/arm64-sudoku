                .global solve
                .text

// solve(board) -> 0 for success, 1 for failure
// on success, the board will be solved
// on failure, the board will be unchanged
solve:
               	sub sp, sp, #48
		str x19, [sp, #8]
		str x20, [sp, #16]
		str x21, [sp, #24]
		str x30, [sp, #32]

		mov x19, x0	// Board
		mov x20, #0	// Outer loop induction variable
		mov x21, #1	// Inner loop induction variable
			
		
		mov x0, x19
		bl has_conflict
		
		cbnz x0, .fail

.startloop_outer:
		cmp x20, #81
		b.ge .succeed

		ldrb w0, [x19, x20]
		cbnz x0, .endloop_outer

.startloop_inner:
		cmp x21, #10
		b.ge .inner_fail
		
		strb w21, [x19, x20]
		mov x0, x19
		bl solve

		cbz x0, .succeed

		add x21, x21, #1
		b .startloop_inner

.inner_fail:
		strb wzr, [x19, x20]
		b .fail		

.endloop_outer:
		add x20, x20, #1
		b .startloop_outer

.fail:
		mov x0, #1
		b .return

.succeed:	
		mov x0, #0	
		
.return:
		ldr x19, [sp, #8]
		ldr x20, [sp, #16]
		ldr x21, [sp, #24]
		ldr x30, [sp, #32]
		add sp, sp, #48
		ret
