Extension { #name : #True }

{ #category : #'*omnibase' }
True >> odbBasicSerialize: serializer [

	serializer stream putByte: 15
]

{ #category : #'*omnibase' }
True >> odbObjectID [

	^ODBObjectID containerID: 0 index: 2
]

{ #category : #'*omnibase' }
True >> odbSerialize: serializer [

	serializer stream putByte: 15
]
