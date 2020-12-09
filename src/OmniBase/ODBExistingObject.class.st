Class {
	#name : #ODBExistingObject,
	#superclass : #ODBDeserializers,
	#category : 'OmniBase'
}

{ #category : #serialization }
ODBExistingObject class >> odbDeserialize: deserializer [

    ^deserializer existingObject
]
