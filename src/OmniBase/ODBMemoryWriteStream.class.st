"
ODBMemoryWriteStream wraps a WriteStream and provides easy data reading (e.g. getByte)
"
Class {
	#name : #ODBMemoryWriteStream,
	#superclass : #ODBStream,
	#category : #'OmniBase-Streams'
}

{ #category : #converting }
ODBMemoryWriteStream >> asByteArray [
	^stream contents copy
]

{ #category : #initialization }
ODBMemoryWriteStream >> initialize [
	stream := WriteStream on: ByteArray new
]

{ #category : #public }
ODBMemoryWriteStream >> putBytesFrom: aByteCollection len: len [
	stream next: len putAll: aByteCollection startingAt: 1
]

{ #category : #converting }
ODBMemoryWriteStream >> writeOn: aStream [
	aStream putLong: self size.
	aStream putBytesFrom: stream contents
]
