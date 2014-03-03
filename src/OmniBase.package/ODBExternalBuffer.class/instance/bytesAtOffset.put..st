converting
bytesAtOffset: offset put: bytes

	^contents
		replaceFrom: offset + 1
		to: offset + bytes size
		with: bytes
		startingAt: 1.