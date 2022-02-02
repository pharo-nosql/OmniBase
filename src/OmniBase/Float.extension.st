Extension { #name : #Float }

{ #category : #'*omnibase' }
Float >> asBtreeKeyOfSize: keySize [

	^ self asIEEE32BitWord asBtreeKeyOfSize: keySize
]

{ #category : #'*omnibase' }
Float class >> odbDeserialize: deserializer [

	^ BoxedFloat64 basicNew
		  at: 1 put: deserializer stream getInteger;
		  at: 2 put: deserializer stream getInteger;
		  * 1
]
