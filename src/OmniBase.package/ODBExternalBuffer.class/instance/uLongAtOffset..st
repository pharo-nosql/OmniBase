converting
uLongAtOffset: offset

	^(contents at: offset + 1) +
		((contents at: offset + 2) bitShift: 8) +
		((contents at: offset + 3) bitShift: 16) +
		((contents at: offset + 4) bitShift: 24)