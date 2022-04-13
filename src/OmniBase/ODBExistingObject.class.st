Class {
	#name : #ODBExistingObject,
	#superclass : #ODBDeserializers,
	#category : #'OmniBase-Serializers'
}

{ #category : #serialization }
ODBExistingObject class >> odbDeserialize: deserializer [

    ^ deserializer existingObject
]
