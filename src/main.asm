lorom

optimize dp always
optimize address mirrors



org $008000
	incsrc "defines.asm"
	incsrc "hijacks.asm"
	incsrc "macros.asm"



org freerom
	incsrc "code.asm"
	incsrc "unlock_prac_courses.asm"


input_display_gfx:
	incbin "data/input_display_gfx.bin"


warnpc freerom|$FFFF