Extension { #name : #Float }

{ #category : #'*omnibase' }
Float >> asBtreeKeyOfSize: keySize [

	^ self asIEEE32BitWord asBtreeKeyOfSize: keySize
]

{ #category : #'*omnibase' }
Float class >> odbDeserialize: deserializer [

	^ deserializer stream nextSmallFloat64: deserializer
]
