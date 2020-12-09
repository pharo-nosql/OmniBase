Class {
	#name : #ODBNewObject,
	#superclass : #ODBDeserializers,
	#category : 'OmniBase'
}

{ #category : #'as yet unclassified' }
ODBNewObject class >> odbDeserialize: deserializer [

	^deserializer newObjectOldClass
]
