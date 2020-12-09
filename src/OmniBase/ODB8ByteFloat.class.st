Class {
	#name : #ODB8ByteFloat,
	#superclass : #ODBDeserializers,
	#category : 'OmniBase'
}

{ #category : #accessing }
ODB8ByteFloat class >> odbDeserialize: deserializer [ 
	| float |
	float := Float basicNew: 8.
	deserializer stream getBytesFor: (ExternalAddress fromInteger: float yourAddress) len: 8.
	^float
]
