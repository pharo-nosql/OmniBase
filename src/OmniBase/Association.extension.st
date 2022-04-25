Extension { #name : #Association }

{ #category : #'*omnibase' }
Association >> odbBasicSerialize: serializer [

	serializer stream nextPutAssociation: self
]

{ #category : #'*omnibase' }
Association class >> odbDeserialize: deserializer [

	^ deserializer stream nextAssociation: self
]
