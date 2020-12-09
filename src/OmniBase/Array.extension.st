Extension { #name : #Array }

{ #category : #'*omnibase' }
Array >> odbBasicSerialize: serializer [

	serializer stream putByte: 35; putPositiveInteger: self size.
	1 to: self size do: [:i | (self at: i) odbSerialize: serializer ].
]

{ #category : #'*omnibase' }
Array class >> odbDeserialize: deserializer [

	| array |
	array := self new: deserializer stream getPositiveInteger.
	deserializer register: array.
	1 to: array size do: [:i | array at: i put: deserializer odbNextObject ].
	^array
]
