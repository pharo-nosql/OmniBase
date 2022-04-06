Class {
	#name : #ODBUndefinedObject,
	#superclass : #Object,
	#instVars : [
		'variables',
		'indexedVariables',
		'bytes',
		'classInfo',
		'basicSize'
	],
	#category : #'OmniBase-Serializers'
}

{ #category : #public }
ODBUndefinedObject >> className [
	^classInfo name
]

{ #category : #public }
ODBUndefinedObject >> instVarNames [
	^classInfo instVarNames
]

{ #category : #public }
ODBUndefinedObject >> instVarValues [
	^variables
]

{ #category : #private }
ODBUndefinedObject >> odbLoadVariables: deserializer classInfo: aClassInfo [ 
	"Private - Deserialize instance of a nonexisting class."

	| stream |
	stream := deserializer stream.
	classInfo := aClassInfo.
	classInfo isVariable 
		ifTrue: [basicSize := stream getPositiveInteger]
		ifFalse: [basicSize := 0].
	deserializer register: self.
	classInfo isBytes 
		ifTrue: [stream getBytesFor: (bytes := ByteArray new: basicSize) len: basicSize]
		ifFalse: 
			[variables := Array new: classInfo instSize.
			1 to: classInfo instSize do: [:i | variables at: i put: deserializer odbNextObject].
			basicSize > 0 ifTrue: [indexedVariables := Array new: basicSize].
			1 to: basicSize do: [:i | indexedVariables at: i put: deserializer odbNextObject]].
	^self odbDeserialized: deserializer
]
