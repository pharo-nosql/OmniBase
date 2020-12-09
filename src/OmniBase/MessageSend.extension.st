Extension { #name : #MessageSend }

{ #category : #'*omnibase' }
MessageSend >> odbBasicSerialize: serializer [ 
	self class == MessageSend ifFalse: [^super odbBasicSerialize: serializer].
	serializer stream putByte: 20.
	receiver odbSerialize: serializer.
	selector odbSerialize: serializer.
	arguments odbSerialize: serializer
]

{ #category : #'*omnibase' }
MessageSend class >> odbDeserialize: deserializer [ 
	| result |
	deserializer register: (result := self new).
	^result
		receiver: deserializer nextObject;
		selector: deserializer nextObject;
		arguments: deserializer nextObject;
		yourself
]
