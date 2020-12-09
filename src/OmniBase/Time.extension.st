Extension { #name : #Time }

{ #category : #'*omnibase' }
Time >> odbBasicSerialize: serializer [

	serializer stream
		putByte: 33;
		putPositiveInteger: self asSeconds
]

{ #category : #'*omnibase' }
Time class >> odbDeserialize: deserializer [

	^deserializer register: (self fromSeconds: deserializer stream getPositiveInteger)
]
