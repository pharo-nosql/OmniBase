Class {
	#name : #ODBFileStream,
	#superclass : #ODBStream,
	#instVars : [
		'fileHandle',
		'mutex',
		'pathName'
	],
	#category : #'OmniBase-Streams'
}

{ #category : #'create/open flags' }
ODBFileStream class >> accessModeReadOnly [
	^#accessModeReadOnly
]

{ #category : #'create/open flags' }
ODBFileStream class >> accessModeReadWrite [
	^#accessModeReadWrite
]

{ #category : #'create/open flags' }
ODBFileStream class >> cacheModeAtomicWrite [
	^#cacheModeAtomicWrite
]

{ #category : #'create/open flags' }
ODBFileStream class >> createModeCreateAlways [
	^#createModeCreateAlways
]

{ #category : #'create/open flags' }
ODBFileStream class >> createModeCreateNew [
	^#createModeCreateNew
]

{ #category : #'create/open flags' }
ODBFileStream class >> createModeOpenAlways [
	^#createModeOpenAlways
]

{ #category : #'create/open flags' }
ODBFileStream class >> createModeOpenExisting [
	^#createModeOpenExisting
]

{ #category : #'create/open' }
ODBFileStream class >> createNewOn: pathName [
        "Create new file on pathName. Trigger an error 
        if the file allready exists or if it can not be created."

    ^self createOn: pathName
        createMode: self createModeCreateNew
        accessMode: self accessModeReadWrite
        shareMode: self shareModeShareAll
]

{ #category : #'create/open' }
ODBFileStream class >> createOn: pathName [
        "Create new file on pathName. Trigger an 
        exception if the file can not be created."

    ^self createOn: pathName
        createMode: self createModeCreateAlways
        accessMode: self accessModeReadWrite
        shareMode: self shareModeShareAll
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

	| fileStreamClass |
	fileStreamClass := Smalltalk os platformName
			caseOf: 
				{
				['unix'] -> [ODBUnixFileStream].
				['Mac OS'] -> [ODBMacFileStream].
				['Win32'] -> [ODBWin32FileStream].
				}
			otherwise: 
				[^self error: 'Platform not Supported'].
			
	^ fileStreamClass
		createOn: pathName 
		createMode: createMode 
		accessMode: accessMode 
		shareMode: shareMode 
		cacheMode: cacheMode
]

{ #category : #'directory operations' }
ODBFileStream class >> directoryCreate: aPath [

	aPath asFileReference ensureCreateDirectory.
	
	^true
]

{ #category : #'directory operations' }
ODBFileStream class >> directoryExists: aString [

	^ aString asFileReference exists
]

{ #category : #'directory operations' }
ODBFileStream class >> exists: fileName [
		
	"Answer <true> if file named fileName exists."

	
	^ fileName asFileReference exists
]

{ #category : #locking }
ODBFileStream class >> lockingMutex [

	lockingMutex isNil
		ifTrue: [
			lockingMutex := Semaphore forMutualExclusion.
			locks := Dictionary new ].
	^lockingMutex
]

{ #category : #'create/open' }
ODBFileStream class >> openExclusivelyOn: pathName [
		"Open an existing file on pathName exclusively so that no-one else can open it.
		Trigger an exception if the file can not be opened."

	^self createOn: pathName
		createMode: self createModeOpenExisting
		accessMode: self accessModeReadWrite
		shareMode: self shareModeShareNone
]

{ #category : #'create/open' }
ODBFileStream class >> openOn: pathName [
        "Open an existing file on pathName. Trigger an 
        exception if the file can not be opened."

    ^self createOn: pathName
        createMode: self createModeOpenExisting
        accessMode: self accessModeReadWrite
        shareMode: self shareModeShareAll
]

{ #category : #'create/open' }
ODBFileStream class >> openReadOnlyOn: pathName [ 
	"Open an existing file on pathName. Trigger an 
        exception if the file can not be opened."

	^self 
		createOn: pathName
		createMode: self createModeOpenExisting
		accessMode: self accessModeReadOnly
		shareMode: self shareModeShareAll
]

{ #category : #public }
ODBFileStream class >> pathSeparatorString [

	^ DiskStore delimiter asString

]

{ #category : #'directory operations' }
ODBFileStream class >> remove: fileName [
	"Remove file named fileName. Answer <true> if successful, <false> if failed."

	[ fileName asFileReference delete.
		^true ]
			on: Error
			do: [:ex | ^false ]
]

{ #category : #'create/open flags' }
ODBFileStream class >> shareModeShareAll [
	^#shareModeShareAll
]

{ #category : #'create/open flags' }
ODBFileStream class >> shareModeShareNone [
	^#shareModeShareNone
]

{ #category : #'create/open flags' }
ODBFileStream class >> shareModeShareRead [
	^#shareModeShareRead
]

{ #category : #'create/open flags' }
ODBFileStream class >> shareModeShareWrite [
	^#shareModeShareWrite
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

	^fileHandle flush; readInto: aByteCollection startingAt: 1 count: len
]

{ #category : #public }
ODBFileStream >> basicPosition: anInteger [
	"Positiones stream to anInteger. Answer anInteger."

	fileHandle position: anInteger.
	^anInteger
]

{ #category : #public }
ODBFileStream >> basicPutBytesFrom: aByteArray len: length [ 
	(fileHandle
		writeFrom: aByteArray
		startingAt: 1
		for: length)
		= length ifFalse: [OmniBase signalError: 'Could not write the whole data'].
	fileHandle flush.
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

	fileHandle flush
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
	fileHandle := anIOAccessor.
	mutex := Semaphore forMutualExclusion.
]

{ #category : #public }
ODBFileStream >> pathName [

    ^pathName
]

{ #category : #public }
ODBFileStream >> position [

	^fileHandle position
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
    ^self class remove: pathName
]

{ #category : #public }
ODBFileStream >> size [
	"Answer the size of the file in bytes or
	signal a FileException if the operation fails."

	^ fileHandle size
]

{ #category : #public }
ODBFileStream >> truncate: anInteger [ 
	"Truncate stream so that its size will be anInteger. 
        Position to anInteger."

	mutex critical: 
			[self basicPosition: anInteger.
			fileHandle truncate: anInteger]
]

{ #category : #public }
ODBFileStream >> unlockAt: pos length: length [
	"Unlock portion of file at position pos.
	Answer <true> if successfull, <false> if failed."

	self subclassResponsibility
]
