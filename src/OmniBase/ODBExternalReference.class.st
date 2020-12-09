Class {
	#name : #ODBExternalReference,
	#superclass : #ODBDeserializers,
	#category : 'OmniBase'
}

{ #category : #serialization }
ODBExternalReference class >> odbDeserialize: deserializer [

	^deserializer loadReference
]
