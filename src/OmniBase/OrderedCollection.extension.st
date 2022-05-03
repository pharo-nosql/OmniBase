Extension { #name : #OrderedCollection }

{ #category : #'*omnibase' }
OrderedCollection >> odbBasicSerialize: serializer [
	self class == OrderedCollection ifFalse: [ ^ super odbBasicSerialize: serializer ].
	serializer stream nextPutOrderedCollection: self
]

{ #category : #'*omnibase' }
OrderedCollection class >> odbDeserialize: deserializer [

	^ deserializer stream nextOrderedCollection: self
]
