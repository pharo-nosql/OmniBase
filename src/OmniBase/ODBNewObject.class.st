Class {
	#name : #ODBNewObject,
	#superclass : #ODBDeserializers,
	#category : #'OmniBase-Serializers'
}

{ #category : #'as yet unclassified' }
ODBNewObject class >> odbDeserialize: deserializer [

	^deserializer newObjectOldClass
]
