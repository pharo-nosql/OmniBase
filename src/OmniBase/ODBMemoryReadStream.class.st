"
ODBMemoryReadStream wraps a ReadStream and provides easy data reading (e.g. getByte)
"
Class {
	#name : #ODBMemoryReadStream,
	#superclass : #ODBStream,
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
ODBMemoryReadStream >> getBytesFor: aByteCollection len: len [ 
	"Read len bytes from stream to aByteCollection. Answer number of bytes actualy read."

	^ stream readInto: aByteCollection startingAt: 1 count: len
]

{ #category : #'instance creation' }
ODBMemoryReadStream >> readFrom: aStream [
	stream := aStream
]
