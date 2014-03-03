public
lockRemove: anODBLock 
	"Remove lock from transaction file."

	| i |
	(i := anODBLock lockIndex) isNil 
		ifTrue: [OmniBase signalError: 'Lock has not been stored yet'].
	locks at: i put: nil.
	stream position: (lockPositions at: i).
	stream putByte: 100 + anODBLock class lockClassID.
	anODBLock lockIndex: nil.
	stream flush