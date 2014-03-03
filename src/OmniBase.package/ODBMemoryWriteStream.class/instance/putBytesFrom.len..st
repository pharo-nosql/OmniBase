public
putBytesFrom: aByteCollection len: len 
	"Write aByteCollection to stream."

	len > (readLimit - position) 
		ifTrue: 
			[(current notNil 
				and: [collections last == current and: [len > 64 and: [len <= aByteCollection size]]]) 
					ifTrue: 
						[collections at: collections size put: (current copyFrom: 1 to: position).
						aByteCollection size = len 
							ifTrue: [collections add: aByteCollection]
							ifFalse: [collections add: (aByteCollection copyFrom: 1 to: len)].
						self makeSpace]
					ifFalse: [1 to: len do: [:i | self putByte: (aByteCollection at: i) asInteger]]]
		ifFalse: 
			[current 
				replaceFrom: position + 1
				to: position + len
				with: aByteCollection
				startingAt: 1.
			position := position + len]