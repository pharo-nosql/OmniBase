Class {
	#name : #ODBExternalReference,
	#superclass : #ODBDeserializers,
	#category : #'OmniBase-Serializers'
}

{ #category : #serialization }
ODBExternalReference class >> odbDeserialize: deserializer [

	^ deserializer loadReference
]
