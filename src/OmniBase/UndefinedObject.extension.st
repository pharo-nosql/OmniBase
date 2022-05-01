Extension { #name : #UndefinedObject }

{ #category : #'*omnibase' }
UndefinedObject >> odbBasicSerialize: serializer [
	self class == UndefinedObject ifFalse: [ ^ super odbBasicSerialize: serializer ].
	serializer stream nextPutNil: self
]

{ #category : #'*omnibase' }
UndefinedObject >> odbDeserialize: deserializer [

	deserializer loadError
]

{ #category : #'*omnibase' }
UndefinedObject class >> odbDeserialize: deserializer [

	^ nil
]

{ #category : #'*omnibase' }
UndefinedObject >> odbLoadVariables: deserializer classInfo: classInfo [

	^ODBUndefinedObject new odbLoadVariables: deserializer classInfo: classInfo
]

{ #category : #'*omnibase' }
UndefinedObject >> odbObjectID [

	^ODBObjectID containerID: 0 index: 1
]

{ #category : #'*omnibase' }
UndefinedObject >> odbSerialize: serializer [

	self odbBasicSerialize: serializer
]
