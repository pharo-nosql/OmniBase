Class {
	#name : #ODBExternalBuffer,
	#superclass : #Object,
	#instVars : [
		'contents'
	],
	#category : 'OmniBase'
}

{ #category : #'instance creation' }
ODBExternalBuffer class >> createOn: aByteArray [

	^self basicNew contents: aByteArray
]

{ #category : #'instance creation' }
ODBExternalBuffer class >> new [

	^self new: self sizeInBytes
]

{ #category : #'instance creation' }
ODBExternalBuffer class >> new: size [

	^self basicNew contents: (ByteArray new: size)
]

{ #category : #converting }
ODBExternalBuffer >> bytesAtOffset: offset count: count [

	^contents copyFrom: offset + 1 to: offset + count
]

{ #category : #converting }
ODBExternalBuffer >> bytesAtOffset: offset put: bytes [

	^contents
		replaceFrom: offset + 1
		to: offset + bytes size
		with: bytes
		startingAt: 1.
]

{ #category : #converting }
ODBExternalBuffer >> contents [

	^contents
]

{ #category : #converting }
ODBExternalBuffer >> contents: aByteArray [

	contents := aByteArray
]

{ #category : #converting }
ODBExternalBuffer >> loadFromStream: aStream [

	aStream getBytesFor: contents
]

{ #category : #public }
ODBExternalBuffer >> loadFromStream: aStream at: position [ 
	aStream atPosition: position getBytesFor: contents
]

{ #category : #converting }
ODBExternalBuffer >> storeOnStream: aStream [

	aStream putBytesFrom: contents
]

{ #category : #public }
ODBExternalBuffer >> storeOnStream: aStream at: position [ 
	aStream atPosition: position putBytesFrom: contents
]

{ #category : #converting }
ODBExternalBuffer >> uLongAtOffset: offset [

	^(contents at: offset + 1) +
		((contents at: offset + 2) bitShift: 8) +
		((contents at: offset + 3) bitShift: 16) +
		((contents at: offset + 4) bitShift: 24)
]

{ #category : #converting }
ODBExternalBuffer >> uLongAtOffset: offset put: longValue [

	contents
		at: offset + 1 put: (longValue bitAnd: 16rFF);
		at: offset + 2 put: ((longValue bitShift: -8 ) bitAnd: 16rFF);
		at: offset + 3 put: ((longValue bitShift: -16 ) bitAnd: 16rFF);
		at: offset + 4 put: (longValue bitShift: -24).
	^longValue
]

{ #category : #converting }
ODBExternalBuffer >> uShortAtOffset: offset [

	^(contents at: offset + 1) + ((contents at: offset + 2) bitShift: 8)
]

{ #category : #converting }
ODBExternalBuffer >> uShortAtOffset: offset put: longValue [

	contents
		at: offset + 1 put: (longValue bitAnd: 16rFF);
		at: offset + 2 put: ((longValue bitShift: -8 ) bitAnd: 16rFF).
	^longValue
]
