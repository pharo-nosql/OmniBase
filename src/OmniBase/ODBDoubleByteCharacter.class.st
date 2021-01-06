Class {
	#name : #ODBDoubleByteCharacter,
	#superclass : #ODBDeserializers,
	#category : #'OmniBase-Serializers'
}

{ #category : #serialization }
ODBDoubleByteCharacter class >> odbDeserialize: deserializer [

    ^Character value: deserializer stream getWord
]
