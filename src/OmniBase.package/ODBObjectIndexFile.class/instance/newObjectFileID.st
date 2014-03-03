public
newObjectFileID
	"Get new ID for object file. Thread-safe."

	| newID |
	self waitForLockAt: self headerLength length: 4.
	
	[newID := (stream atPositionGetLong: self headerLength) + 1.
	stream atPosition: self headerLength putLong: newID] 
			ensure: [self unlockAt: self headerLength length: 4].
	^newID