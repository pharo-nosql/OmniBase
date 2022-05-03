Extension { #name : #String }

{ #category : #'*omnibase' }
String >> asBtreeKeyOfSize: keySize [

	^self asByteArray asBtreeKeyOfSize: keySize
]

{ #category : #'*omnibase' }
String >> odbBasicSerialize: serializer [
	serializer stream nextPutString: self
]

{ #category : #'*omnibase' }
String class >> odbDeserialize: deserializer [

	^ deserializer stream nextString
]
