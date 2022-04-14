Class {
	#name : #ODBFloatAsInteger,
	#superclass : #ODBDeserializers,
	#category : #'OmniBase-Serializers'
}

{ #category : #accessing }
ODBFloatAsInteger class >> odbDeserialize: deserializer [

    ^ deserializer stream nextFloatAsInteger
]
