Extension { #name : #String }

{ #category : #'*omnibase' }
String >> asBtreeKeyOfSize: keySize [

	^self asByteArray asBtreeKeyOfSize: keySize
]

{ #category : #'*omnibase' }
String >> odbBasicSerialize: serializer [

	| buf |
	(buf := self asByteArray) size < 10
		ifTrue: [
			^serializer stream
				putByte: 70 + buf size;
				putBytesFrom: buf len: buf size ].
	serializer stream
		putByte: 34;
		putPositiveInteger: buf size;
		putBytesFrom: buf len: buf size
]

{ #category : #'*omnibase' }
String class >> odbDeserialize: deserializer [

	| string |
	string := deserializer stream nextString.
	deserializer register: string.
	^ string
]

{ #category : #'*omnibase' }
String >> trimBlanks [
	^self withBlanksCondensed
]
