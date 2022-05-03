Extension { #name : #Symbol }

{ #category : #'*omnibase' }
Symbol >> odbBasicSerialize: serializer [

	serializer stream nextPutSymbol: self
]

{ #category : #'*omnibase' }
Symbol class >> odbDeserialize: deserializer [

	^ deserializer stream nextSymbol
]

{ #category : #'*omnibase' }
Symbol >> odbSerialize: serializer [

	self odbBasicSerialize: serializer
]
