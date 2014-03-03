public
unlock
	| pos |
	pos := self headerLength + 1.
	self waitForLockAt: pos length: 1.
	
	[(stream
		position: pos;
		getByte) == 1 
		ifFalse: [^false]
		ifTrue: 
			[stream
				position: pos;
				putByte: 0.
			^true]] 
			ensure: [self unlockAt: pos length: 1]