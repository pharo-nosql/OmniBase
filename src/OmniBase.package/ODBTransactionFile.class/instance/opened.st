public
opened
	"Private - Load all stored locks and recovery information."

	"collect lock classes class IDs"

	| classes storedID classID obj startingPosition |
	classes := IdentityDictionary new.
	self collectLockClassIDsFrom: ODBLock to: classes.
	"load locks first"
	locks := OrderedCollection new.
	lockPositions := OrderedCollection new.
	stream position: self headerLength + 10.
	
	[startingPosition := stream position.
	(storedID := stream getByte) == 0] whileFalse: 
				[storedID > 100 ifTrue: [classID := storedID - 100] ifFalse: [classID := storedID].	"removed locks have classID > 100"
				obj := (classes at: classID ifAbsent: [OmniBase signalError: 'Unknown lock classID']) new 
							loadFromStream: stream.
				storedID > 100 
					ifFalse: 
						["if lock is still active"
						locks add: obj.
						obj lockIndex: locks size.
						lockPositions add: startingPosition]].
	"load recovery information next"
	stream position: self headerLength + 4.
	(startingPosition := stream getLong) == 0 
		ifFalse: 
			[stream position: startingPosition.
			recovery := ODBChangesPackage new loadFromStream: stream]