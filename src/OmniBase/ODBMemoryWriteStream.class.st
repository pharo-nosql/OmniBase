"
ODBMemoryWriteStream wraps a WriteStream and provides easy data reading (e.g. getByte)
"
Class {
	#name : #ODBMemoryWriteStream,
	#superclass : #ODBStream,
	#instVars : [
		'stream'
	],
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

{ #category : #accessing }
ODBMemoryWriteStream >> position [
	^ stream position
]

{ #category : #accessing }
ODBMemoryWriteStream >> position: aPostion [
	stream position: aPostion
]

{ #category : #public }
ODBMemoryWriteStream >> putByte: anInteger [

    self putBytesFrom: (ByteArray with: anInteger) len: 1
]

{ #category : #public }
ODBMemoryWriteStream >> putBytesFrom: aByteCollection len: len [
	stream next: len putAll: aByteCollection startingAt: 1
]

{ #category : #accessing }
ODBMemoryWriteStream >> size [
	^ stream size
]

{ #category : #converting }
ODBMemoryWriteStream >> writeOn: aStream [
	aStream putLong: self size.
	aStream putBytesFrom: stream contents
]
