Extension { #name : #Dictionary }

{ #category : #'*omnibase' }
Dictionary >> odbBasicSerialize: serializer [

	serializer stream nextPutDictionary: self 
]

{ #category : #'*omnibase' }
Dictionary class >> odbDeserialize: deserializer [

	^ deserializer stream nextDictionary: self 
]
