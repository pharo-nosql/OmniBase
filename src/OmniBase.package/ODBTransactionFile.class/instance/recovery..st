public
recovery: anODBChangesPackage 
	"Set recovery instance variable and save recovery information."

	| recoveryPosition |
	anODBChangesPackage isNil 
		ifTrue: [recoveryPosition := 0]
		ifFalse: 
			[recoveryPosition := newLockPosition + 1.
			stream position: recoveryPosition.
			anODBChangesPackage storeOnStream: stream].
	stream
		atPosition: self headerLength + 4 putLong: recoveryPosition;
		flush.
	recovery := anODBChangesPackage