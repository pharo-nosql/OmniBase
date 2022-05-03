Class {
	#name : #ODBnCharacterString,
	#superclass : #ODBDeserializers,
	#instVars : [
		'n'
	],
	#category : #'OmniBase-Serializers'
}

{ #category : #creation }
ODBnCharacterString class >> length: anInteger [

    ^self new n: anInteger
]

{ #category : #private }
ODBnCharacterString >> n: anInteger [

    n := anInteger.
]

{ #category : #accessing }
ODBnCharacterString >> odbDeserialize: deserializer [

  ^ deserializer stream nextnCharacterStringSize: n
]
