Extension { #name : #Time }

{ #category : #'*omnibase' }
Time >> odbBasicSerialize: serializer [
	self class == Time ifFalse: [ ^ super odbBasicSerialize: serializer ].
	serializer stream nextPutTime: self
]

{ #category : #'*omnibase' }
Time class >> odbDeserialize: deserializer [

	^ deserializer stream nextTime
]
