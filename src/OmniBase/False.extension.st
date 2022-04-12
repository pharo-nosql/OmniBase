Extension { #name : #False }

{ #category : #'*omnibase' }
False >> odbBasicSerialize: serializer [

	serializer stream nextPutFalse: self 
]

{ #category : #'*omnibase' }
False >> odbObjectID [

	^ODBObjectID containerID: 0 index: 3
]

{ #category : #'*omnibase' }
False >> odbSerialize: serializer [

	self odbBasicSerialize: serializer
]
