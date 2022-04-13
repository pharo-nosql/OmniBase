Class {
	#name : #ODBPrimitiveEncodingStream,
	#superclass : #Object,
	#instVars : [
		'stream'
	],
	#category : #'OmniBase-Streams'
}

{ #category : #accessing }
ODBPrimitiveEncodingStream >> atEnd [ 
	^ stream atEnd
]

{ #category : #public }
ODBPrimitiveEncodingStream >> getBoolean [

    ^ self  getByte = 1
]

{ #category : #public }
ODBPrimitiveEncodingStream >> getByte [
	self subclassResponsibility 
]

{ #category : #public }
ODBPrimitiveEncodingStream >> getBytesFor: aByteCollection [

    ^ self getBytesFor: aByteCollection len: aByteCollection size
]

{ #category : #public }
ODBPrimitiveEncodingStream >> getBytesFor: bytes len: size [
	self subclassResponsibility 
]

{ #category : #public }
ODBPrimitiveEncodingStream >> getChar [

    ^ Character value: stream getByte
]

{ #category : #public }
ODBPrimitiveEncodingStream >> getInteger [
	"Answer the next Integer encoded in the receiver."

	| int |
	((int := self getPositiveInteger) bitAnd: 1) == 0 ifTrue: [^int bitShift: -1].
	^0 - (int bitShift: -1)
]

{ #category : #public }
ODBPrimitiveEncodingStream >> getPositiveInteger [
	"Answer the next Integer encoded in the receiver."

	| answer |
	(answer := self getByte) < 128 ifTrue: [^answer].
	^(self getPositiveInteger bitShift: 7) bitOr: (answer bitAnd: 127)
]

{ #category : #public }
ODBPrimitiveEncodingStream >> getString [

	| size bytes |
	^(size := self getPositiveInteger) = 0
		ifTrue: [String new]
		ifFalse: [
			bytes := ByteArray new: size.
			self getBytesFor: bytes len: size.
			bytes asString ]
]

{ #category : #accessing }
ODBPrimitiveEncodingStream >> position [
	^ stream position
]

{ #category : #public }
ODBPrimitiveEncodingStream >> putBoolean: aBool [

    self putByte: (aBool ifTrue: [ 1] ifFalse: [0])
]

{ #category : #public }
ODBPrimitiveEncodingStream >> putBytesFrom: aByteCollection [

    ^ self putBytesFrom: aByteCollection len: aByteCollection size
]

{ #category : #public }
ODBPrimitiveEncodingStream >> putChar: aCharacter [

	self putByte: aCharacter asInteger
]

{ #category : #public }
ODBPrimitiveEncodingStream >> putInteger: anInteger [ 
	anInteger < 0 ifTrue: [^self putPositiveInteger: (0 - anInteger bitShift: 1) + 1].
	self putPositiveInteger: (anInteger bitShift: 1)
]

{ #category : #public }
ODBPrimitiveEncodingStream >> putPositiveInteger: anInteger [ 
	anInteger < 128 ifTrue: [^self putByte: anInteger].
	self
		putByte: ((anInteger bitAnd: 127) bitOr: 128);
		putPositiveInteger: (anInteger bitShift: -7)
]

{ #category : #public }
ODBPrimitiveEncodingStream >> putString: aString [

	self putPositiveInteger: aString basicSize.
	aString basicSize > 0 ifTrue: [ self putBytesFrom: aString asByteArray len: aString basicSize ]
]

{ #category : #accessing }
ODBPrimitiveEncodingStream >> size [ 
	^ stream size
]
