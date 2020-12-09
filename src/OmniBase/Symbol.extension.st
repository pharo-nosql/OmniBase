Extension { #name : #Symbol }

{ #category : #'*omnibase' }
Symbol >> odbBasicSerialize: serializer [

	serializer stream
		putByte: 18;
		putPositiveInteger: self size;
		putBytesFrom: self asByteArray len: self size
]

{ #category : #'*omnibase' }
Symbol class >> odbDeserialize: deserializer [

	| bytes len |
	bytes := ByteArray new: (len := deserializer stream getPositiveInteger).
	deserializer stream getBytesFor: bytes len: len.
	^bytes asString asSymbol
]

{ #category : #'*omnibase' }
Symbol >> odbSerialize: serializer [

	serializer stream
		putByte: 18;
		putPositiveInteger: self size;
		putBytesFrom: self asByteArray len: self size
]
