Extension { #name : #SystemDictionary }

{ #category : #'*omnibase' }
SystemDictionary >> odbBasicSerialize: serializer [

	serializer stream nextPutSystemDictionary: self 
]

{ #category : #'*omnibase' }
SystemDictionary >> odbSerialize: serializer [

	self odbBasicSerialize: serializer
]
