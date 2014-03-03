converting
uShortAtOffset: offset

	^(contents at: offset + 1) + ((contents at: offset + 2) bitShift: 8)