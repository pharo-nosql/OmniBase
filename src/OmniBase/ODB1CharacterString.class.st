Class {
	#name : #ODB1CharacterString,
	#superclass : #ODBDeserializers,
	#category : #'OmniBase-Serializers'
}

{ #category : #accessing }
ODB1CharacterString class >> odbDeserialize: deserializer [

   ^ deserializer stream nextOneCharacterString
]
