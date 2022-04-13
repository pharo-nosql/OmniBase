Class {
	#name : #ODBDoubleByteCharacter,
	#superclass : #ODBDeserializers,
	#category : #'OmniBase-Serializers'
}

{ #category : #serialization }
ODBDoubleByteCharacter class >> odbDeserialize: deserializer [

    ^ deserializer stream nextDoubleByteCharacter
]
