Extension { #name : #False }

{ #category : #'*omnibase' }
False >> odbObjectID [

	^ODBObjectID containerID: 0 index: 3
]

{ #category : #'*omnibase' }
False >> odbSerialize: serializer [

	serializer stream putByte: 16
]
