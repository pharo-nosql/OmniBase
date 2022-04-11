Class {
	#name : #ODBCodecStream,
	#superclass : #ODBStream,
	#instVars : [
		'mutex'
	],
	#category : #'OmniBase-Streams'
}

{ #category : #'instance creation' }
ODBCodecStream class >> on: aStream [ 
	^ self new 
		stream: aStream
]

{ #category : #accessing }
ODBCodecStream >> atPosition: anInteger getBytesFor: aByteCollection [ 
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
ODBCodecStream >> atPosition: anInteger getBytesFor: aByteCollection len: len [ 
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
ODBCodecStream >> atPosition: pos putBytesFrom: aByteCollection [ 
	"Write bytes from aByteCollection to file."

	mutex critical: 
			[self
				basicPosition: pos;
				basicPutBytesFrom: aByteCollection len: aByteCollection size]
]

{ #category : #accessing }
ODBCodecStream >> atPosition: pos putBytesFrom: aByteCollection len: len [ 
	"Write len bytes from aByteCollection to file."

	mutex critical: 
			[self
				basicPosition: pos;
				basicPutBytesFrom: aByteCollection len: len]
]

{ #category : #accessing }
ODBCodecStream >> atPosition: pos putLong: anInteger [ 
	| buf |
	buf := ByteArray new: 4.
	buf odbLongAt: 1 put: anInteger.
	self 
		atPosition: pos
		putBytesFrom: buf
		len: 4
]

{ #category : #accessing }
ODBCodecStream >> atPositionGetLong: pos [ 
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
ODBCodecStream >> basicGetBytesFor: aByteCollection len: len [
		"Read len bytes from stream to aByteCollection. 
		Answer number of bytes actualy read."

	^ stream 
		flush; 
		readInto: aByteCollection startingAt: 1 count: len
]

{ #category : #public }
ODBCodecStream >> basicPosition: anInteger [
	"Positiones stream to anInteger. Answer anInteger."

	stream position: anInteger.
	^anInteger
]

{ #category : #public }
ODBCodecStream >> basicPutBytesFrom: aByteArray len: length [ 
	(stream
		writeFrom: aByteArray
		startingAt: 1
		for: length)
		= length ifFalse: [OmniBase signalError: 'Could not write the whole data'].
	stream flush.
	^self

]

{ #category : #'initialize-release' }
ODBCodecStream >> close [
	"Close file associatied with receiver."
	stream notNil ifTrue: [
		stream unlock.
		stream closed ifFalse: [ stream close ] ].
	stream := nil.
]

{ #category : #public }
ODBCodecStream >> compare: aString at: pos [ 
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
ODBCodecStream >> finalize [
	self close
]

{ #category : #finalization }
ODBCodecStream >> flush [
	"Force all data written to the 
	receiver to be recorded on disk."

	stream flush
]

{ #category : #public }
ODBCodecStream >> getByte [
	"Read byte from file stream. Answer <nil> if
	end of file has been reached."

	| buf |
	buf := ByteArray new: 1.
	^(self getBytesFor: buf len: 1) == 1 ifTrue: [buf at: 1]
]

{ #category : #public }
ODBCodecStream >> getBytesFor: aByteCollection len: len [ 
	"Read len bytes from stream to aByteCollection. 
	Answer number of bytes actualy read."

	| result |
	mutex critical: [result := self basicGetBytesFor: aByteCollection len: len].
	^result
]

{ #category : #public }
ODBCodecStream >> getLong [
	"Read long integer from stream. 
	Answer <nil> if end of file has been reached."

	| buf |
	buf := ByteArray new: 4.
	^(self getBytesFor: buf len: 4) == 4 ifTrue: [buf odbLongAt: 1]
]

{ #category : #public }
ODBCodecStream >> getWord [
	"Read word from file stream.
	Answer <nil> if end of file has been reached."

	| buf |
	buf := ByteArray new: 2.
	^(self getBytesFor: buf len: 2) == 2 ifTrue: [buf odbShortAt: 1]
]

{ #category : #initialization }
ODBCodecStream >> initialize [ 
	super initialize.
	mutex := Semaphore forMutualExclusion 
]

{ #category : #accessing }
ODBCodecStream >> lockAt: position length: length [ 

	^ stream lockAt: position length: length 
]

{ #category : #accessing }
ODBCodecStream >> position: anInteger [ 
	"Positiones stream to anInteger. Answer anInteger."

	| result |
	mutex critical: [result := self basicPosition: anInteger].
	^result
]

{ #category : #accessing }
ODBCodecStream >> putByte: anInteger [

    self putBytesFrom: (ByteArray with: anInteger) len: 1
]

{ #category : #public }
ODBCodecStream >> putBytesFrom: aByteCollection len: len [ 
	"Write len bytes from aByteCollection to file."

	mutex critical: [self basicPutBytesFrom: aByteCollection len: len]
]

{ #category : #public }
ODBCodecStream >> putLong: anInteger [ 
	| buf |
	buf := ByteArray new: 4.
	buf odbLongAt: 1 put: anInteger.
	self putBytesFrom: buf len: 4
]

{ #category : #public }
ODBCodecStream >> putWord: anInteger [ 
	| buf |
	buf := ByteArray new: 2.
	buf odbShortAt: 1 put: anInteger.
	self putBytesFrom: buf len: 2
]

{ #category : #removing }
ODBCodecStream >> remove [
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
ODBCodecStream >> stream: aStream [ 
	stream := aStream
]

{ #category : #accessing }
ODBCodecStream >> truncate: anInteger [ 
	"Truncate stream so that its size will be anInteger. 
	Position to anInteger."

	mutex critical: [ 
		self basicPosition: anInteger.
		stream truncate: anInteger ]
]

{ #category : #accessing }
ODBCodecStream >> unlockAt: position length: length [

	^ stream unlockAt: position length: length 
]
