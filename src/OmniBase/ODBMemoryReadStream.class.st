"
ODBMemoryReadStream wraps a ReadStream and provides easy data reading (e.g. getByte)
"
Class {
	#name : #ODBMemoryReadStream,
	#superclass : #ODBStream,
	#instVars : [
		'stream'
	],
	#category : #'OmniBase-Streams'
}

{ #category : #'instance creation' }
ODBMemoryReadStream class >> createOn: bytes [

    ^self new createOn: bytes
]

{ #category : #'instance creation' }
ODBMemoryReadStream class >> readFrom: aStream [

    ^self new readFrom: aStream
]

{ #category : #'instance creation' }
ODBMemoryReadStream >> createOn: aByteArray [

	self readFrom: (ReadStream on: aByteArray)
]

{ #category : #public }
ODBMemoryReadStream >> getByte [
	"Read byte from file stream. Answer <nil> if the end has been reached."

	| buf |
	buf := ByteArray new: 1.
	^(self getBytesFor: buf len: 1) == 1 ifTrue: [buf at: 1] ifFalse: [ nil ]
]

{ #category : #public }
ODBMemoryReadStream >> getBytesFor: aByteCollection len: len [ 
	"Read len bytes from stream to aByteCollection. Answer number of bytes actualy read."

	^ stream readInto: aByteCollection startingAt: 1 count: len
]

{ #category : #accessing }
ODBMemoryReadStream >> position [
	^ stream position
]

{ #category : #accessing }
ODBMemoryReadStream >> position: aPostion [
	stream position: aPostion
]

{ #category : #'instance creation' }
ODBMemoryReadStream >> readFrom: aStream [
	stream := aStream
]

{ #category : #accessing }
ODBMemoryReadStream >> size [
	^ stream size
]
