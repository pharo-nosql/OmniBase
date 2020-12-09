Class {
	#name : #ODBNewObjectNewClass,
	#superclass : #ODBDeserializers,
	#category : 'OmniBase'
}

{ #category : #'as yet unclassified' }
ODBNewObjectNewClass class >> odbDeserialize: deserializer [

	^deserializer newObjectNewClass
]
