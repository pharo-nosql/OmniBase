Class {
	#name : #ODBLargePositiveInteger,
	#superclass : #ODBDeserializers,
	#category : 'OmniBase'
}

{ #category : #'no category' }
ODBLargePositiveInteger class >> odbDeserialize: deserializer [

	^deserializer stream getPositiveInteger
]
