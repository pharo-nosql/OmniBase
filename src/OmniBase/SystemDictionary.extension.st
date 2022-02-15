Extension { #name : #SystemDictionary }

{ #category : #'*omnibase' }
SystemDictionary >> odbSerialize: serializer [

	serializer stream putByte: 19
]
