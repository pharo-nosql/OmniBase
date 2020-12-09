Extension { #name : #SystemDictionary }

{ #category : #'*omnibase' }
SystemDictionary >> odbBasicSerialize: serializer [

	serializer stream putByte: 19
]

{ #category : #'*omnibase' }
SystemDictionary >> odbSerialize: serializer [

	serializer stream putByte: 19
]
