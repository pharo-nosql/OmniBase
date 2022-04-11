Class {
	#name : #ODBPrimitiveCodedStream,
	#superclass : #Object,
	#instVars : [
		'stream'
	],
	#category : #'OmniBase-Streams'
}

{ #category : #public }
ODBPrimitiveCodedStream >> getBoolean [

    ^ self  getByte = 1
]

{ #category : #public }
ODBPrimitiveCodedStream >> getBytesFor: aByteCollection [

    ^ self getBytesFor: aByteCollection len: aByteCollection size
]

{ #category : #public }
ODBPrimitiveCodedStream >> getPositiveInteger [
	"Answer the next Integer encoded in the receiver."

	| answer |
	(answer := self getByte) < 128 ifTrue: [^answer].
	^(self getPositiveInteger bitShift: 7) bitOr: (answer bitAnd: 127)
]

{ #category : #public }
ODBPrimitiveCodedStream >> getString [

	| size bytes |
	^(size := self getPositiveInteger) = 0
		ifTrue: [String new]
		ifFalse: [
			bytes := ByteArray new: size.
			self getBytesFor: bytes len: size.
			bytes asString ]
]

{ #category : #accessing }
ODBPrimitiveCodedStream >> position [
	^ stream position
]

{ #category : #public }
ODBPrimitiveCodedStream >> putBoolean: aBool [

    self putByte: (aBool ifTrue: [ 1] ifFalse: [0])
]

{ #category : #public }
ODBPrimitiveCodedStream >> putBytesFrom: aByteCollection [

    ^ self putBytesFrom: aByteCollection len: aByteCollection size
]

{ #category : #public }
ODBPrimitiveCodedStream >> putChar: aCharacter [

	self putByte: aCharacter asInteger
]

{ #category : #public }
ODBPrimitiveCodedStream >> putInteger: anInteger [ 
	anInteger < 0 ifTrue: [^self putPositiveInteger: (0 - anInteger bitShift: 1) + 1].
	self putPositiveInteger: (anInteger bitShift: 1)
]

{ #category : #public }
ODBPrimitiveCodedStream >> putPositiveInteger: anInteger [ 
	anInteger < 128 ifTrue: [^self putByte: anInteger].
	self
		putByte: ((anInteger bitAnd: 127) bitOr: 128);
		putPositiveInteger: (anInteger bitShift: -7)
]

{ #category : #public }
ODBPrimitiveCodedStream >> putString: aString [

	self putPositiveInteger: aString basicSize.
	aString basicSize > 0 ifTrue: [ self putBytesFrom: aString asByteArray len: aString basicSize ]
]

{ #category : #accessing }
ODBPrimitiveCodedStream >> size [ 
	^ stream size
]
