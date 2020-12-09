Class {
	#name : #ODBStream,
	#superclass : #Object,
	#instVars : [
		'position'
	],
	#classInstVars : [
		'locks',
		'lockingMutex'
	],
	#category : 'OmniBase'
}

{ #category : #public }
ODBStream >> atEnd [
        "Answer <true> if at end of stream."

    ^self position == self size
]

{ #category : #public }
ODBStream >> flush [
]

{ #category : #public }
ODBStream >> getBoolean [

    ^self getByte = 1
]

{ #category : #public }
ODBStream >> getBytesFor: aByteCollection [

    ^self getBytesFor: aByteCollection len: aByteCollection size
]

{ #category : #public }
ODBStream >> getChar [

    ^Character value: self getByte
]

{ #category : #public }
ODBStream >> getInteger [
	"Answer the next Integer encoded in the receiver."

	| int |
	((int := self getPositiveInteger) bitAnd: 1) == 0 ifTrue: [^int bitShift: -1].
	^0 - (int bitShift: -1)
]

{ #category : #public }
ODBStream >> getLong [

    ^self getWord bitOr: (self getWord bitShift: 16)
]

{ #category : #public }
ODBStream >> getPositiveInteger [
	"Answer the next Integer encoded in the receiver."

	| answer |
	(answer := self getByte) < 128 ifTrue: [^answer].
	^(self getPositiveInteger bitShift: 7) bitOr: (answer bitAnd: 127)
]

{ #category : #public }
ODBStream >> getString [

	| size bytes |
	^(size := self getPositiveInteger) = 0
		ifTrue: [String new]
		ifFalse: [
			bytes := ByteArray new: size.
			self getBytesFor: bytes len: size.
			bytes asString ]
]

{ #category : #public }
ODBStream >> getWord [

    ^self getByte bitOr: (self getByte bitShift: 8)
]

{ #category : #public }
ODBStream >> putBoolean: aBool [

    self putByte: (aBool ifTrue: [ 1] ifFalse: [0])
]

{ #category : #public }
ODBStream >> putBytesFrom: aByteCollection [

    ^self putBytesFrom: aByteCollection len: aByteCollection size
]

{ #category : #public }
ODBStream >> putChar: aCharacter [

	self putByte: aCharacter asInteger
]

{ #category : #public }
ODBStream >> putInteger: anInteger [ 
	anInteger < 0 ifTrue: [^self putPositiveInteger: (0 - anInteger bitShift: 1) + 1].
	self putPositiveInteger: (anInteger bitShift: 1)
]

{ #category : #public }
ODBStream >> putLong: anInteger [

    self putWord: (anInteger bitAnd: 65535); putWord: (anInteger bitShift: -16)
]

{ #category : #public }
ODBStream >> putPositiveInteger: anInteger [ 
	anInteger < 128 ifTrue: [^self putByte: anInteger].
	self
		putByte: ((anInteger bitAnd: 127) bitOr: 128);
		putPositiveInteger: (anInteger bitShift: -7)
]

{ #category : #public }
ODBStream >> putString: aString [

	self putPositiveInteger: aString basicSize.
	aString basicSize > 0 ifTrue: [ self putBytesFrom: aString asByteArray len: aString basicSize ]
]

{ #category : #public }
ODBStream >> putWord: anInteger [

    self putByte: (anInteger bitAnd: 255); putByte: (anInteger bitShift: -8)
]

{ #category : #public }
ODBStream >> setToEnd [
        "Set to stream to end and answer position."

    ^self position: self size
]
