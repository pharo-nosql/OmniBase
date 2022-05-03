Extension { #name : #Association }

{ #category : #'*omnibase' }
Association >> odbBasicSerialize: serializer [
	self class == Association ifFalse: [ ^ super odbBasicSerialize: serializer ].
	serializer stream nextPutAssociation: self
]

{ #category : #'*omnibase' }
Association class >> odbDeserialize: deserializer [

	^ deserializer stream nextAssociation: self
]
