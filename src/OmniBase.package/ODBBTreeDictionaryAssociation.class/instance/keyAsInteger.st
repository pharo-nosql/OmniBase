accessing
keyAsInteger
		"Convert from BCD encoded byte array into integer."

	| value |
	value := 0.
	1 to: key size do: [:i | value := (value * 100) + ((key at: i) & 15) + (((key at: i) bitShift: -4) * 10) ].
	^value