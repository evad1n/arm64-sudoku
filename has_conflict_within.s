                .global has_conflict_within
                .text

// has_conflict_within(board, get_within, major) -> 0 or 1
has_conflict_within:
		sub sp, sp, #48
		str x19, [sp, #0]
		str x20, [sp, #8]
		str x21, [sp, #16]
		str x22, [sp, #24]
		str x23, [sp, #32]
		str x30, [sp, #40]

                // your code goes here
		mov x19, x0	// Board
		mov x20, x1	// get_within function address
		mov x21, x2	// major
		mov x22, #0	// Used bits tracker
		mov x23, #0	// Induction variable

.startloop:
		cmp x23, #9
		b.ge .no_conflict

.get_cell:
		mov x0, x19	// Load parameters for get_within functions
		mov x1, x21
		mov x2, x23	

		blr x20		// Return value will be in x0

		cbz x0, .endloop

.bits:		
		mov x1, #1
		lsl x1, x1, x0	// bit position
		and x2, x22, x1
		
		cbnz x2, .has_conflict

		orr x22, x22, x1
		b .endloop

.endloop:
		add x23, x23, #1
		b .startloop

.has_conflict:
		mov x0, #1
		b .return

.no_conflict:
		mov x0, #0

.return:
		ldr x19, [sp, #0]
		ldr x20, [sp, #8]
		ldr x21, [sp, #16]
		ldr x22, [sp, #24]
		ldr x23, [sp, #32]
		ldr x30, [sp, #40]
		add sp, sp, #48
		ret
