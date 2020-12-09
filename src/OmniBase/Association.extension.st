Extension { #name : #Association }

{ #category : #'*omnibase' }
Association >> odbBasicSerialize: serializer [

	serializer stream putByte: 31.
	key odbSerialize: serializer.
	value odbSerialize: serializer.
]

{ #category : #'*omnibase' }
Association class >> odbDeserialize: deserializer [

	| result |
	deserializer register: (result := self new).
	^result
		key: deserializer odbNextObject;
		value: deserializer odbNextObject
]
