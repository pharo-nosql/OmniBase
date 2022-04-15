Extension { #name : #MessageSend }

{ #category : #'*omnibase' }
MessageSend >> odbBasicSerialize: serializer [ 
	
	serializer stream nextPutMessageSend: self
]

{ #category : #'*omnibase' }
MessageSend class >> odbDeserialize: deserializer [ 

	^ deserializer stream nextMessageSend: self
]
