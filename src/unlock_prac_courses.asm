fix_course_name:
	CMP #$09
	BCC .one_digit
	LDA $0480
	SEC
	SBC #$04
	STA $0480
	LDY #$FF
-:
	INY
	LDA $0480+$3,y
	BNE -
--:
	LDA $0480+$3,y
	STA $0480+$4,y
	DEY
	BPL --

	PHX

	LDX #$00

	LDA $53
	INC A

	%divide($0A)
	
	PHA
	TXA

	CLC
	ADC #$80
	STA $0480+$3

	PLA

	CLC
	ADC #$80
	STA $0480+$4

	PLX

	RTL

.one_digit
	ADC #$81
	STA $0480+$3
	RTL


fix_extra_course_glitches:
	LDX #$00
	LDA $53
	%divide($05)
	ASL A
	ASL A
	RTL