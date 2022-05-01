Extension { #name : #Array }

{ #category : #'*omnibase' }
Array >> odbBasicSerialize: serializer [
	self class == Array ifFalse: [ ^ super odbBasicSerialize: serializer ].
	serializer stream nextPutArray: self
]

{ #category : #'*omnibase' }
Array class >> odbDeserialize: deserializer [

	^ deserializer stream nextArray: self
]
