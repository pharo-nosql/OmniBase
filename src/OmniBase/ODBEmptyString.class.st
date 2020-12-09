Class {
	#name : #ODBEmptyString,
	#superclass : #ODBDeserializers,
	#category : 'OmniBase'
}

{ #category : #accessing }
ODBEmptyString class >> odbDeserialize: deserializer [

    ^deserializer register: String new
]
