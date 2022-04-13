Class {
	#name : #ODBLargePositiveInteger,
	#superclass : #ODBDeserializers,
	#category : #'OmniBase-Serializers'
}

{ #category : #'no category' }
ODBLargePositiveInteger class >> odbDeserialize: deserializer [
 
	^ deserializer stream nextLargePositiveInteger
]
