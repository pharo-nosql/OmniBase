Class {
	#name : #ODBFloatAs100Integer,
	#superclass : #ODBDeserializers,
	#category : 'OmniBase'
}

{ #category : #accessing }
ODBFloatAs100Integer class >> odbDeserialize: deserializer [

    ^deserializer stream getInteger / 100.0
]
