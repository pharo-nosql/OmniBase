Class {
	#name : #ODBNewObject,
	#superclass : #ODBDeserializers,
	#category : #'OmniBase-Serializers'
}

{ #category : #serialization }
ODBNewObject class >> odbDeserialize: deserializer [

	^ deserializer newObjectOldClass
]
