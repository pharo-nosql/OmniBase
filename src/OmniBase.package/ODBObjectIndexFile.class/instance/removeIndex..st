public
removeIndex: index 
	self at: index put: (ByteArray new: valueLength).
	gcCount isNil 
		ifFalse: 
			[gcBuffer odbLongAt: ((gcCount \\ 256) * 4) + 1 put: index.
			gcCount := gcCount + 1.
			gcCount \\ 256 = 0 ifTrue: [self flushGCBuffer]]