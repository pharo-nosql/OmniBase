Class {
	#name : #ODBEmptyString,
	#superclass : #ODBDeserializers,
	#category : #'OmniBase-Serializers'
}

{ #category : #accessing }
ODBEmptyString class >> odbDeserialize: deserializer [

    ^ deserializer register: String new
]
