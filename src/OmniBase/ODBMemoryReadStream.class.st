Class {
	#name : #ODBMemoryReadStream,
	#superclass : #ODBStream,
	#instVars : [
		'current'
	],
	#category : 'OmniBase'
}

{ #category : #'as yet unclassified' }
ODBMemoryReadStream class >> createOn: bytes [

    ^self new createOn: bytes
]

{ #category : #'as yet unclassified' }
ODBMemoryReadStream class >> readFrom: aStream [

    ^self new readFrom: aStream
]

{ #category : #initializing }
ODBMemoryReadStream >> createOn: aByteArray [

    position := 0.
    current := aByteArray
]

{ #category : #public }
ODBMemoryReadStream >> getByte [

    ^current at: (position := position + 1)
]

{ #category : #public }
ODBMemoryReadStream >> getBytesFor: aByteCollection len: len [

    aByteCollection
        replaceFrom: 1
        to: len
        with: current
        startingAt: position + 1.
    position := position + len
]

{ #category : #public }
ODBMemoryReadStream >> getChar [

    ^Character value: (current at: (position := position + 1))
]

{ #category : #public }
ODBMemoryReadStream >> getLong [
	position := position + 4.
	^current odbLongAt: position - 3
]

{ #category : #public }
ODBMemoryReadStream >> getPositiveInteger [
	"Answer the next Integer encoded in the receiver. 
	Works for one collection only."

	| answer |
	(answer := current at: (position := position + 1)) > 127 ifFalse: [^answer].
	^(self getPositiveInteger bitShift: 7) bitOr: (answer bitAnd: 127)
]

{ #category : #public }
ODBMemoryReadStream >> getWord [
	position := position + 2.
	^current odbShortAt: position - 1
]

{ #category : #public }
ODBMemoryReadStream >> position [
        "Answer current position on stream."

    ^position
]

{ #category : #public }
ODBMemoryReadStream >> position: anInteger [

    position := anInteger
]

{ #category : #initializing }
ODBMemoryReadStream >> readFrom: aStream [
        "Read receivers contents from aStream."

    | size |
    size := aStream getLong.
    aStream position + size > aStream size ifTrue: [^self error: 'Read beyond stream size !'].
    current := ByteArray new: size.
    aStream getBytesFor: current len: size.
    position := 0
]

{ #category : #public }
ODBMemoryReadStream >> size [

    ^current size
]
