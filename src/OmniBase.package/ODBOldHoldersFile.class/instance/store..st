public
store: aByteArray 
	"Store holder contents and answer its position on the stream."

	| result |
	buffer isNil 
		ifTrue: [self allocateBuffer]
		ifFalse: 
			[buffer size - bufPos < aByteArray size 
				ifTrue: 
					[self
						flush;
						allocateBuffer]].
	buffer 
		replaceFrom: bufPos + 1
		to: bufPos + aByteArray size
		with: aByteArray
		startingAt: 1.
	result := filePos + bufPos.
	bufPos := bufPos + aByteArray size.
	^result