Extension { #name : #Message }

{ #category : #'*omnibase' }
Message >> odbBasicSerialize: serializer [ 
	self class == Message ifFalse: [^super odbBasicSerialize: serializer].
	serializer stream putByte: 17.
	selector odbSerialize: serializer.
	args odbSerialize: serializer
]

{ #category : #'*omnibase' }
Message class >> odbDeserialize: deserializer [ 
	| result |
	deserializer register: (result := self new).
	^result
		setSelector: deserializer nextObject arguments: deserializer nextObject;
		yourself
]
