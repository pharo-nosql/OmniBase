public
lockAdd: anODBLock 
	"Add lock to transaction file."

	| mStream bytes |
	recovery isNil ifFalse: [OmniBase signalError: 'Can not lock in the middle of commit'].
	anODBLock lockIndex isNil ifFalse: [OmniBase signalError: 'Lock is allready stored'].
	locks add: anODBLock.
	lockPositions add: newLockPosition.
	anODBLock lockIndex: locks size.
	(mStream := ODBMemoryWriteStream new) putByte: 0.
	anODBLock storeOnStream: mStream.
	mStream putByte: 0.
	stream
		position: newLockPosition;
		putBytesFrom: (bytes := mStream asByteArray);
		position: newLockPosition;
		putByte: anODBLock class lockClassID.
	stream flush.
	newLockPosition := newLockPosition + bytes size - 1