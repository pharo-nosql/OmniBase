Class {
	#name : #ODBLargeNegativeInteger,
	#superclass : #ODBDeserializers,
	#category : 'OmniBase'
}

{ #category : #'no category' }
ODBLargeNegativeInteger class >> odbDeserialize: deserializer [

	^0 - deserializer stream getPositiveInteger
]
