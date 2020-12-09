Class {
	#name : #ODBFloatAsInteger,
	#superclass : #ODBDeserializers,
	#category : 'OmniBase'
}

{ #category : #accessing }
ODBFloatAsInteger class >> odbDeserialize: deserializer [

    ^deserializer stream getInteger asFloat
]
