public
lock
	| pos |
	pos := self headerLength + 1.
	self waitForLockAt: pos length: 1.
	
	[(stream
		position: pos;
		getByte) == 0 
		ifFalse: [^false]
		ifTrue: 
			[stream
				position: pos;
				putByte: 1.
			^true]] 
			ensure: [self unlockAt: pos length: 1]