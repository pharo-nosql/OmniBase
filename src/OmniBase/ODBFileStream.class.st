Class {
	#name : #ODBFileStream,
	#superclass : #ODBStream,
	#instVars : [
		'mutex',
		'pathName'
	],
	#category : #'OmniBase-Streams'
}

{ #category : #'create/open' }
ODBFileStream class >> createOn: pathName [
        "Create new file on pathName. Trigger an 
        exception if the file can not be created."

    ^self createOn: pathName
        createMode: #createModeCreateAlways
        accessMode: #accessModeReadWrite
        shareMode: #shareModeShareAll
]

{ #category : #'create/open' }
ODBFileStream class >> createOn: pathName createMode: createMode accessMode: accessMode shareMode: shareMode [
		"Create new instance of file stream on pathName with given flags."

	^self createOn: pathName
		createMode: createMode
		accessMode: accessMode
		shareMode: shareMode
		cacheMode: nil
]

{ #category : #'create/open' }
ODBFileStream class >> createOn: pathName createMode: createMode accessMode: accessMode shareMode: shareMode cacheMode: cacheMode [
		"Create new instance of file stream on pathName with given flags."

	 ^ Smalltalk os omnibaseFileStreamClass
		createOn: pathName 
		createMode: createMode 
		accessMode: accessMode 
		shareMode: shareMode 
		cacheMode: cacheMode
]

{ #category : #'create/open' }
ODBFileStream class >> openExclusivelyOn: pathName [
		"Open an existing file on pathName exclusively so that no-one else can open it.
		Trigger an exception if the file can not be opened."

	^ self createOn: pathName
		createMode: #createModeOpenExisting
		accessMode: #accessModeReadWrite
		shareMode: #shareModeShareNone
]

{ #category : #'create/open' }
ODBFileStream class >> openOn: aFileReference [ 
        "Open an existing file on pathName. Trigger an 
        exception if the file can not be opened."

    ^self createOn: aFileReference pathString
        createMode: #createModeOpenExisting
        accessMode: #accessModeReadWrite
        shareMode: #shareModeShareAll
]

{ #category : #'create/open' }
ODBFileStream class >> openReadOnlyOn: pathName [ 
	"Open an existing file on pathName. Trigger an 
        exception if the file can not be opened."

	^self 
		createOn: pathName
		createMode: #createModeOpenExisting
		accessMode: #accessModeReadOnly
		shareMode: #shareModeShareAll
]

{ #category : #public }
ODBFileStream >> atPosition: anInteger getBytesFor: aByteCollection [ 
	"Read bytes from stream at position anInteger. 
        Answer number of bytes actualy read."

	| result |
	mutex critical: 
			[result := self
						basicPosition: anInteger;
						basicGetBytesFor: aByteCollection len: aByteCollection size].
	^result
]

{ #category : #public }
ODBFileStream >> atPosition: anInteger getBytesFor: aByteCollection len: len [ 
	"Read len bytes from stream at position anInteger to aByteCollection. 
        Answer number of bytes actualy read."

	| result |
	mutex critical: 
			[result := self
						basicPosition: anInteger;
						basicGetBytesFor: aByteCollection len: len].
	^result
]

{ #category : #public }
ODBFileStream >> atPosition: pos putBytesFrom: aByteCollection [ 
	"Write bytes from aByteCollection to file."

	mutex critical: 
			[self
				basicPosition: pos;
				basicPutBytesFrom: aByteCollection len: aByteCollection size]
]

{ #category : #public }
ODBFileStream >> atPosition: pos putBytesFrom: aByteCollection len: len [ 
	"Write len bytes from aByteCollection to file."

	mutex critical: 
			[self
				basicPosition: pos;
				basicPutBytesFrom: aByteCollection len: len]
]

{ #category : #public }
ODBFileStream >> atPosition: pos putLong: anInteger [ 
	| buf |
	buf := ByteArray new: 4.
	buf odbLongAt: 1 put: anInteger.
	self 
		atPosition: pos
		putBytesFrom: buf
		len: 4
]

{ #category : #public }
ODBFileStream >> atPositionGetLong: pos [ 
	"Read long integer from stream. 
	Answer <nil> if end of file has been reached."

	| buf |
	buf := ByteArray new: 4.
	^(self 
		atPosition: pos
		getBytesFor: buf
		len: 4) == 4 
		ifTrue: [buf odbLongAt: 1]
]

{ #category : #public }
ODBFileStream >> basicGetBytesFor: aByteCollection len: len [
		"Read len bytes from stream to aByteCollection. 
		Answer number of bytes actualy read."

	^stream flush; readInto: aByteCollection startingAt: 1 count: len
]

{ #category : #public }
ODBFileStream >> basicPosition: anInteger [
	"Positiones stream to anInteger. Answer anInteger."

	stream position: anInteger.
	^anInteger
]

{ #category : #public }
ODBFileStream >> basicPutBytesFrom: aByteArray len: length [ 
	(stream
		writeFrom: aByteArray
		startingAt: 1
		for: length)
		= length ifFalse: [OmniBase signalError: 'Could not write the whole data'].
	stream flush.
	^self

]

{ #category : #public }
ODBFileStream >> close [
	self subclassResponsibility 
]

{ #category : #public }
ODBFileStream >> compare: aString at: pos [ 
	"Answer <true>, if aString is stored at pos."

	| str str2 len |
	len := aString size.
	str := String new: len.
	(self 
		atPosition: pos
		getBytesFor: str
		len: len) == len ifFalse: [^false].
	str := str select: [:each | each isDigit or: [each isLetter]].
	str2 := aString select: [:each | each isDigit or: [each isLetter]].
	^str = str2
]

{ #category : #public }
ODBFileStream >> finalize [
	self close
]

{ #category : #public }
ODBFileStream >> flush [
		"Force all data written to the 
		receiver to be recorded on disk."

	stream flush
]

{ #category : #public }
ODBFileStream >> getByte [
	"Read byte from file stream. Answer <nil> if
	end of file has been reached."

	| buf |
	buf := ByteArray new: 1.
	^(self getBytesFor: buf len: 1) == 1 ifTrue: [buf at: 1]
]

{ #category : #public }
ODBFileStream >> getBytesFor: aByteCollection len: len [ 
	"Read len bytes from stream to aByteCollection. 
	Answer number of bytes actualy read."

	| result |
	mutex critical: [result := self basicGetBytesFor: aByteCollection len: len].
	^result
]

{ #category : #public }
ODBFileStream >> getLong [
	"Read long integer from stream. 
	Answer <nil> if end of file has been reached."

	| buf |
	buf := ByteArray new: 4.
	^(self getBytesFor: buf len: 4) == 4 ifTrue: [buf odbLongAt: 1]
]

{ #category : #public }
ODBFileStream >> getWord [
	"Read word from file stream.
	Answer <nil> if end of file has been reached."

	| buf |
	buf := ByteArray new: 2.
	^(self getBytesFor: buf len: 2) == 2 ifTrue: [buf odbShortAt: 1]
]

{ #category : #public }
ODBFileStream >> lockAt: pos length: length [

	"Lock portion of file starting at position pos. 
	Answer <true> if successfull, <false> if failed.
	Also sets an internal lock to prevent setting lock twice.
	Unix style fcntl locking will answer true if a lock is set twice.
	For OmniBase this is not allowed."

	^ self subclassResponsibility
]

{ #category : #public }
ODBFileStream >> name [

    ^pathName
]

{ #category : #public }
ODBFileStream >> openOn: aString fileHandle: anIOAccessor [
		"Private - Initialize receiver."

	pathName := aString.
	stream := anIOAccessor.
	mutex := Semaphore forMutualExclusion.
]

{ #category : #public }
ODBFileStream >> pathName [

    ^pathName
]

{ #category : #public }
ODBFileStream >> position: anInteger [ 
	"Positiones stream to anInteger. Answer anInteger."

	| result |
	mutex critical: [result := self basicPosition: anInteger].
	^result
]

{ #category : #private }
ODBFileStream >> printOn: aStream [ 
	aStream nextPutAll: 'ODBFileStream on: ''' , pathName , ''''
]

{ #category : #public }
ODBFileStream >> putByte: anInteger [

    self putBytesFrom: (ByteArray with: anInteger) len: 1
]

{ #category : #public }
ODBFileStream >> putBytesFrom: aByteCollection len: len [ 
	"Write len bytes from aByteCollection to file."

	mutex critical: [self basicPutBytesFrom: aByteCollection len: len]
]

{ #category : #public }
ODBFileStream >> putLong: anInteger [ 
	| buf |
	buf := ByteArray new: 4.
	buf odbLongAt: 1 put: anInteger.
	self putBytesFrom: buf len: 4
]

{ #category : #public }
ODBFileStream >> putWord: anInteger [ 
	| buf |
	buf := ByteArray new: 2.
	buf odbShortAt: 1 put: anInteger.
	self putBytesFrom: buf len: 2
]

{ #category : #public }
ODBFileStream >> remove [
        "Close and remove receiver. Answer <true> if removed."

    self close.
    [ pathName asFileReference delete ]
		on: Error 
		do: [:err | ^ false ].
	^ true
]

{ #category : #public }
ODBFileStream >> truncate: anInteger [ 
	"Truncate stream so that its size will be anInteger. 
        Position to anInteger."

	mutex critical: 
			[self basicPosition: anInteger.
			stream truncate: anInteger]
]

{ #category : #public }
ODBFileStream >> unlockAt: pos length: length [
	"Unlock portion of file at position pos.
	Answer <true> if successfull, <false> if failed."

	self subclassResponsibility
]
