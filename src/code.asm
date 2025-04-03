display_previous_lap_time:
	PHP
	LDA !practice_mode_flag
	BEQ .league
	LDA !current_lap
	DEC
	BNE .not_first_lap
	JSR .record_first_lap
	PLP
	RTL

.not_first_lap:
	SED
	SEC

	LDA !course_timer+$2
	SBC !lap_timers-$1,y
	PHA
	JSR .extract_digit
	STA $0A47
	PLA
	AND #$0F
	STA $0A48

	LDA !course_timer+$1
	STA !lap_timers+$1,y  			;hijacked instruction
	SBC !lap_timers-$2,y
	PHP
	BCS +
	SEC
	SBC #$40
+:
	PLP
	PHA
	JSR .extract_digit
	STA $0A44
	PLA 
	AND #$0F
	STA $0A45

	LDA !course_timer
	SBC !lap_timers-$3,y
	STA $0A42
	PLP
	RTL

.league:
	LDA !current_lap
	DEC
	BNE ..not_first_lap
	JSR .record_first_lap_league
	PLP
	RTL

..not_first_lap:
	SED
	SEC

	LDA !course_timer+$2
	SBC !lap_timers-$1,y
	PHA
	JSR .extract_digit
	STA $0A25
	PLA
	AND #$0F
	STA $0A26

	LDA !course_timer+$1
	STA !lap_timers+$1,y
	SBC !lap_timers-$2,y
	PHP
	BCS +
	SEC
	SBC #$40
+:
	PLP
	PHA
	JSR .extract_digit
	STA $0A23
	PLA 
	AND #$0F
	STA $0A24

	LDA !course_timer
	SBC !lap_timers-$3,y
	STA $0A22
	PLP
	RTL	



.extract_digit:
	PHP
	AND #$F0
	LSR A
	LSR A
	LSR A
	LSR A   
	PLP
	RTS

.record_first_lap:
	SED
	LDA !course_timer
	STA $0A42
	LDA !course_timer+$1
	STA !lap_timers+$1,y  			;hijacked instruction
	PHA
	JSR .extract_digit
	STA $0A44
	PLA
	AND #$0F
	STA $0A45
	LDA !course_timer+$2
	PHA
	JSR .extract_digit
	STA $0A47
	PLA
	AND #$0F
	STA $0A48
	RTS

.record_first_lap_league:
	SED
	LDA !course_timer
	STA $0A22
	LDA !course_timer+$1
	STA !lap_timers+$1,y  			;hijacked instruction
	PHA
	JSR .extract_digit
	STA $0A23
	PLA
	AND #$0F
	STA $0A24
	LDA !course_timer+$2
	PHA
	JSR .extract_digit
	STA $0A25
	PLA
	AND #$0F
	STA $0A26
	RTS


nmi_hijack:
	REP #$30			;\
	PHA				; |
	PHX				; | Hijacked instructions
	PHY				; |
	PHD				; |
	PHB				;/
	LDA $54
	CMP #$0302
	BNE .done
	JSR update_input_display
.done:
	JML $0080E0



;using DMA here instead was breaking things, so yeehaw dial-up speeds
update_input_display:
	PHP
	PHB
	PHK 
	PLB
	LDA #$4880
	STA $2116
	LDX #$0020
	LDY #$0000
.write_top_half:
	LDA input_display_gfx,y
	STA $2118
	INY
	INY
	DEX
	BNE .write_top_half
	LDA #$4980
	STA $2116
	LDX #$0020
	LDY #$0000
.write_bottom_half:
	LDA input_display_gfx+$40,y
	STA $2118
	INY
	INY
	DEX
	BNE .write_bottom_half
	JSR .handle_oam
	PLB
	PLP
	RTS




.handle_oam:
	LDY #$0000
	LDX #$0000
..write_positions:
	LDA inputs_oam_positions,y
	STA !oam_mirror+$20,x
	INX
	INX
	INX
	INX
	INY
	INY
	CPY #$0014
	BCC ..write_positions
	LDY #$0000
	LDX #$0000
..write_properties:
	LDA inputs_oam_properties,y
	PHA
	PHX
	TYA
	TAX
	LDA !player_held
	JSR (handle_inputs,x)
	PLX
	PLA
	BCC +
	EOR #$0A00
+:
	STA !oam_mirror+$22,x
	INX
	INX
	INX
	INX
	INY
	INY
	CPY #$0014
	BCC ..write_properties
	RTS


handle_inputs:
	dw .up
	dw .down
	dw .left
	dw .right
	dw .a
	dw .b
	dw .x
	dw .y
	dw .l
	dw .r


.up:
	BIT #$0800
	BNE .pressed
	CLC
	RTS


.down:
	BIT #$0400
	BNE .pressed
	CLC
	RTS


.left:
	BIT #$0200
	BNE .pressed
	CLC
	RTS


.right:
	BIT #$0100
	BNE .pressed
	CLC
	RTS


.a:
	BIT #$0080
	BNE .pressed
	CLC
	RTS


.b:
	BIT #$8000
	BNE .pressed
	CLC
	RTS


.x:
	BIT #$0040
	BNE .pressed
	CLC
	RTS


.y:
	BIT #$4000
	BNE .pressed
	CLC
	RTS


.l:
	BIT #$0020
	BNE .pressed
	CLC
	RTS


.r:
	BIT #$0010
	BNE .pressed
	CLC
	RTS



.pressed:
	SEC
	RTS





inputs_oam_positions:
	dw $A0CA			;Up
	dw $B5CA			;Down
	dw $ABBF			;Left
	dw $ABD5			;Right

	dw $AAF2			;A
	dw $B5EA			;B
	dw $A0EA			;X
	dw $AAE2			;Y

	dw $94CA			;L
	dw $94EA			;R

inputs_oam_properties:
	dw $3A88			;Up
	dw $BA88			;Down
	dw $7A89			;Left
	dw $AA89			;Right

	dw $3A99			;A
	dw $3A99			;B
	dw $3A99			;X
	dw $3A99			;Y

	dw $BA98			;L
	dw $BA98			;R