Extension { #name : #True }

{ #category : #'*omnibase' }
True >> odbBasicSerialize: serializer [

	serializer stream nextPutTrue: self 
]

{ #category : #'*omnibase' }
True >> odbObjectID [

	^ODBObjectID containerID: 0 index: 2
]

{ #category : #'*omnibase' }
True >> odbSerialize: serializer [

	self odbBasicSerialize: serializer
]
