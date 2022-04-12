Class {
	#name : #ODBFileStreamWrapper,
	#superclass : #ODBPrimitiveEncodingStream,
	#instVars : [
		'mutex'
	],
	#category : #'OmniBase-Streams'
}

{ #category : #'instance creation' }
ODBFileStreamWrapper class >> on: aFileStream [ 
	^ self new 
		stream: aFileStream
]

{ #category : #accessing }
ODBFileStreamWrapper >> atPosition: anInteger getBytesFor: aByteCollection [ 
	"Read bytes from stream at position anInteger. 
        Answer number of bytes actualy read."

	| result |
	mutex critical: 
			[result := self
						basicPosition: anInteger;
						basicGetBytesFor: aByteCollection len: aByteCollection size].
	^result
]

{ #category : #accessing }
ODBFileStreamWrapper >> atPosition: anInteger getBytesFor: aByteCollection len: len [ 
	"Read len bytes from stream at position anInteger to aByteCollection. 
        Answer number of bytes actualy read."

	| result |
	mutex critical: 
			[result := self
						basicPosition: anInteger;
						basicGetBytesFor: aByteCollection len: len].
	^result
]

{ #category : #accessing }
ODBFileStreamWrapper >> atPosition: pos putBytesFrom: aByteCollection [ 
	"Write bytes from aByteCollection to file."

	mutex critical: 
			[self
				basicPosition: pos;
				basicPutBytesFrom: aByteCollection len: aByteCollection size]
]

{ #category : #accessing }
ODBFileStreamWrapper >> atPosition: pos putBytesFrom: aByteCollection len: len [ 
	"Write len bytes from aByteCollection to file."

	mutex critical: 
			[self
				basicPosition: pos;
				basicPutBytesFrom: aByteCollection len: len]
]

{ #category : #accessing }
ODBFileStreamWrapper >> atPosition: pos putLong: anInteger [ 
	| buf |
	buf := ByteArray new: 4.
	buf odbLongAt: 1 put: anInteger.
	self 
		atPosition: pos
		putBytesFrom: buf
		len: 4
]

{ #category : #accessing }
ODBFileStreamWrapper >> atPositionGetLong: pos [ 
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

{ #category : #accessing }
ODBFileStreamWrapper >> basicGetBytesFor: aByteCollection len: len [
		"Read len bytes from stream to aByteCollection. 
		Answer number of bytes actualy read."

	^ stream 
		flush; 
		readInto: aByteCollection startingAt: 1 count: len
]

{ #category : #accessing }
ODBFileStreamWrapper >> basicPosition: anInteger [
	"Positiones stream to anInteger. Answer anInteger."

	stream position: anInteger.
	^anInteger
]

{ #category : #accessing }
ODBFileStreamWrapper >> basicPutBytesFrom: aByteArray len: length [ 
	(stream
		writeFrom: aByteArray
		startingAt: 1
		for: length)
		= length ifFalse: [OmniBase signalError: 'Could not write the whole data'].
	stream flush.
	^self

]

{ #category : #'initialize-release' }
ODBFileStreamWrapper >> close [
	"Close file associatied with receiver."
	stream notNil ifTrue: [
		stream unlock.
		stream closed ifFalse: [ stream close ] ].
	stream := nil.
]

{ #category : #accessing }
ODBFileStreamWrapper >> closed [
	^ stream closed
]

{ #category : #public }
ODBFileStreamWrapper >> compare: aString at: pos [ 
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

{ #category : #finalization }
ODBFileStreamWrapper >> finalize [
	self close
]

{ #category : #accessing }
ODBFileStreamWrapper >> flush [
	stream flush
]

{ #category : #public }
ODBFileStreamWrapper >> getByte [
	"Read byte from file stream. Answer <nil> if
	end of file has been reached."

	| buf |
	buf := ByteArray new: 1.
	^(self getBytesFor: buf len: 1) == 1 ifTrue: [buf at: 1]
]

{ #category : #public }
ODBFileStreamWrapper >> getBytesFor: aByteCollection len: len [ 
	"Read len bytes from stream to aByteCollection. 
	Answer number of bytes actualy read."

	| result |
	mutex critical: [result := self basicGetBytesFor: aByteCollection len: len].
	^result
]

{ #category : #public }
ODBFileStreamWrapper >> getLong [
	"Read long integer from stream. 
	Answer <nil> if end of file has been reached."

	| buf |
	buf := ByteArray new: 4.
	^(self getBytesFor: buf len: 4) == 4 ifTrue: [buf odbLongAt: 1]
]

{ #category : #public }
ODBFileStreamWrapper >> getWord [
	"Read word from file stream.
	Answer <nil> if end of file has been reached."

	| buf |
	buf := ByteArray new: 2.
	^(self getBytesFor: buf len: 2) == 2 ifTrue: [buf odbShortAt: 1]
]

{ #category : #initialization }
ODBFileStreamWrapper >> initialize [ 
	super initialize.
	mutex := Semaphore forMutualExclusion 
]

{ #category : #public }
ODBFileStreamWrapper >> lockAt: position length: length [ 

	^ stream lockAt: position length: length 
]

{ #category : #accessing }
ODBFileStreamWrapper >> name [
	^ stream name
]

{ #category : #accessing }
ODBFileStreamWrapper >> position: anInteger [ 
	"Positiones stream to anInteger. Answer anInteger."

	| result |
	mutex critical: [result := self basicPosition: anInteger].
	^result
]

{ #category : #public }
ODBFileStreamWrapper >> putByte: anInteger [

    self putBytesFrom: (ByteArray with: anInteger) len: 1
]

{ #category : #public }
ODBFileStreamWrapper >> putBytesFrom: aByteCollection len: len [ 
	"Write len bytes from aByteCollection to file."

	mutex critical: [self basicPutBytesFrom: aByteCollection len: len]
]

{ #category : #public }
ODBFileStreamWrapper >> putLong: anInteger [ 
	| buf |
	buf := ByteArray new: 4.
	buf odbLongAt: 1 put: anInteger.
	self putBytesFrom: buf len: 4
]

{ #category : #public }
ODBFileStreamWrapper >> putWord: anInteger [ 
	| buf |
	buf := ByteArray new: 2.
	buf odbShortAt: 1 put: anInteger.
	self putBytesFrom: buf len: 2
]

{ #category : #accessing }
ODBFileStreamWrapper >> readInto: readBufger startingAt: startIndex count: count [
	^ stream readInto: readBufger startingAt: startIndex count: count
]

{ #category : #removing }
ODBFileStreamWrapper >> remove [
	"Close and remove receiver. Answer <true> if removed."
	| file |
	file := stream name asFileReference.
	self close.
	[ file delete ]
		on: Error 
		do: [:err | ^ false ].
	^ true
]

{ #category : #accessing }
ODBFileStreamWrapper >> setToEnd [
	^ stream 
		setToEnd;
		position 
]

{ #category : #accessing }
ODBFileStreamWrapper >> stream: aFileStream [ 
	stream := aFileStream 
]

{ #category : #accessing }
ODBFileStreamWrapper >> truncate: anInteger [ 
	"Truncate stream so that its size will be anInteger. 
	Position to anInteger."

	mutex critical: [ 
		self basicPosition: anInteger.
		stream truncate: anInteger ]
]

{ #category : #locking }
ODBFileStreamWrapper >> unlock [
	stream unlock
]

{ #category : #accessing }
ODBFileStreamWrapper >> unlockAt: position length: length [

	^ stream unlockAt: position length: length 
]
