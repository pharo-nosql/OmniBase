Extension { #name : #Message }

{ #category : #'*omnibase' }
Message >> odbBasicSerialize: serializer [ 
	
	serializer stream nextPutMessage: self
]

{ #category : #'*omnibase' }
Message class >> odbDeserialize: deserializer [ 
	
	^ deserializer stream nextMessage: self
]
