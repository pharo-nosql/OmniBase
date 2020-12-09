Class {
	#name : #ODBCopyValue,
	#superclass : #ODBDeserializers,
	#instVars : [
		'value'
	],
	#category : 'OmniBase'
}

{ #category : #accessing }
ODBCopyValue class >> value: anObject [

    ^self new value: anObject
]

{ #category : #private }
ODBCopyValue >> odbDeserialize: deserializer [

	^value copy
]

{ #category : #private }
ODBCopyValue >> value: anObject [

    value := anObject.
]
