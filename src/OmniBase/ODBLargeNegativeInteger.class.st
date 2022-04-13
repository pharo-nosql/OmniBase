Class {
	#name : #ODBLargeNegativeInteger,
	#superclass : #ODBDeserializers,
	#category : #'OmniBase-Serializers'
}

{ #category : #'no category' }
ODBLargeNegativeInteger class >> odbDeserialize: deserializer [

	^ deserializer stream nextLargeNegativeInteger
]
