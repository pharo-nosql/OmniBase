Class {
	#name : #ODB1CharacterString,
	#superclass : #ODBDeserializers,
	#category : 'OmniBase'
}

{ #category : #accessing }
ODB1CharacterString class >> odbDeserialize: deserializer [

    | str |
    (str := String new: 1) at: 1 put: deserializer stream getChar.
    ^deserializer register: str
]
