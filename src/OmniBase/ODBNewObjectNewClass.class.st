Class {
	#name : #ODBNewObjectNewClass,
	#superclass : #ODBDeserializers,
	#category : #'OmniBase-Serializers'
}

{ #category : #'as yet unclassified' }
ODBNewObjectNewClass class >> odbDeserialize: deserializer [

	^deserializer newObjectNewClass
]
