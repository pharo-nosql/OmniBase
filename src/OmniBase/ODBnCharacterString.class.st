Class {
	#name : #ODBnCharacterString,
	#superclass : #ODBDeserializers,
	#instVars : [
		'n'
	],
	#category : 'OmniBase'
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

    | buf |
    deserializer stream getBytesFor: (buf := ByteArray new: n) len: n.
    ^deserializer register: buf asString
]
