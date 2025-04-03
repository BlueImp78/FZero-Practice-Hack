include


hijack_nmi = $0080D9
hijack_lap_time_store = $0099E9
hijack_last_prac_course_check = $008B4F
hijack_last_prac_course_set = $008B5B
hijack_race_start = $008D03
hijack_practice_flag_check_1 = $009F0F
hijack_league_score_update = $00AB38
hijack_course_number_set = $00AC0D
hijack_practice_flag_check_2 = $00D614

hijack_some_dma = $00D265




org hijack_lap_time_store
	JSL display_previous_lap_time
	WDM


org hijack_last_prac_course_check
	CMP #$0F


org hijack_last_prac_course_set
	LDA #$0E


;org hijack_race_start
;	JSL upload_input_display_gfx


org hijack_practice_flag_check_1
	WDM


org hijack_league_score_update
	NOP #16


org hijack_course_number_set
	JSL fix_course_name
	WDM


org hijack_practice_flag_check_2
	BRA $14


org $02C33F
	JSL fix_extra_course_glitches


org $03915C
	JSL fix_extra_course_glitches


org $039171
	JSL fix_extra_course_glitches


org hijack_nmi
	JML nmi_hijack