converting
uLongAtOffset: offset put: longValue

	contents
		at: offset + 1 put: (longValue bitAnd: 16rFF);
		at: offset + 2 put: ((longValue bitShift: -8 ) bitAnd: 16rFF);
		at: offset + 3 put: ((longValue bitShift: -16 ) bitAnd: 16rFF);
		at: offset + 4 put: (longValue bitShift: -24).
	^longValue