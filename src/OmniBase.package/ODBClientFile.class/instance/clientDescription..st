public
clientDescription: aString 
	"Set client description string."

	stream 
		atPosition: self headerLength
		putBytesFrom: ((String new: 128) 
				replaceFrom: 1
				to: (aString size min: 128)
				with: aString
				startingAt: 1)
		len: 128