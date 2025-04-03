include


macro divide(divisor)
.loop
	CMP #<divisor>
	BMI .done

	SEC
	SBC #<divisor>
	INX
	BRA .loop
.done
endmacro


macro offset(label, offset)
	?tmp:
	pushpc
	org ?tmp+<offset>
	<label>:
	pullpc
endmacro