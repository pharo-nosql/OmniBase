Class {
	#name : #ODBCodecStream,
	#superclass : #ODBStream,
	#category : #'OmniBase-Streams'
}

{ #category : #'instance creation' }
ODBCodecStream class >> on: aStream [ 
	^ self new 
		stream: aStream
]

{ #category : #'initialize-release' }
ODBCodecStream >> close [
	stream ifNotNil: [
		stream close.
		stream := nil ]
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
ODBCodecStream >> getBytesFor: aByteCollection len: len [ 
	"Read len bytes from stream to aByteCollection. 
	Answer number of bytes actualy read."
	
	^ stream getBytesFor: aByteCollection len: len 
]

{ #category : #accessing }
ODBCodecStream >> lockAt: position length: length [ 

	^ stream lockAt: position length: length 
]

{ #category : #'as yet unclassified' }
ODBCodecStream >> nextPersistentDictionary: aDeserializer [
		| size dict key |
	size := stream getPositiveInteger.
	dict := ODBPersistentDictionary new: size.
	aDeserializer register: dict.
	size timesRepeat: 
			[key := aDeserializer odbNextObject.
			dict superAt: key put: aDeserializer odbNextObject].
	^dict
]

{ #category : #actions }
ODBCodecStream >> nextString [
	| buf len |
	buf := ByteArray new: (len := stream getPositiveInteger).
	stream getBytesFor: buf len: len.
	^  buf asString
]

{ #category : #accessing }
ODBCodecStream >> position: anInteger [ 
	^ stream position: anInteger 
]

{ #category : #accessing }
ODBCodecStream >> primitive [
	^ stream 
]

{ #category : #public }
ODBCodecStream >> putBytesFrom: aByteCollection len: len [ 
	"Write len bytes from aByteCollection to file."

	stream putBytesFrom: aByteCollection len: len
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

	stream truncate: anInteger 
]

{ #category : #accessing }
ODBCodecStream >> unlockAt: position length: length [

	^ stream unlockAt: position length: length 
]
