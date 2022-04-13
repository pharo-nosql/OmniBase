Class {
	#name : #ODBFloatAs100Integer,
	#superclass : #ODBDeserializers,
	#category : #'OmniBase-Serializers'
}

{ #category : #accessing }
ODBFloatAs100Integer class >> odbDeserialize: deserializer [

    ^ deserializer stream nextFloatAs100Integer
]
