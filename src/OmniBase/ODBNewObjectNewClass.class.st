Class {
	#name : #ODBNewObjectNewClass,
	#superclass : #ODBDeserializers,
	#category : #'OmniBase-Serializers'
}

{ #category : #serialization }
ODBNewObjectNewClass class >> odbDeserialize: deserializer [

	^ deserializer newObjectNewClass
]
