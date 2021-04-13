                .global has_conflict
                .text

// has_conflict(board) -> 0 or 1
has_conflict:
		sub sp, sp, #32
		str x19, [sp, #8]
		str x20, [sp, #16]
		str x30, [sp, #24]

		mov x19, x0	// Board
		mov x20, #0	// Induction variable	

.startloop:
		cmp x20, #9
		b.ge .no_conflict

		mov x0, x19
		ldr x1, =get_within_row
		mov x2, x20
		bl has_conflict_within

		cbnz x0, .yes_conflict

		mov x0, x19
		ldr x1, =get_within_column
		mov x2, x20
		bl has_conflict_within		

		cbnz x0, .yes_conflict

		mov x0, x19
		ldr x1, =get_within_group
		mov x2, x20
		bl has_conflict_within

		cbnz x0, .yes_conflict

.endloop:	
		add x20, x20, #1
		b .startloop

.no_conflict:
		mov x0, #0
		b .return

.yes_conflict:
		mov x0, #1	

.return:
		ldr x19, [sp, #8]
		ldr x20, [sp, #16]
		ldr x30, [sp, #24]
		add sp, sp, #32
		ret
