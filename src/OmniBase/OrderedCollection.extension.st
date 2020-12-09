Extension { #name : #OrderedCollection }

{ #category : #'*omnibase' }
OrderedCollection >> odbBasicSerialize: serializer [

	serializer stream
		putByte: 81;
		putPositiveInteger: self size.
	self do: [:each | each odbSerialize: serializer ].
]

{ #category : #'*omnibase' }
OrderedCollection class >> odbDeserialize: deserializer [

	| coll size |
	size := deserializer stream getPositiveInteger.
	deserializer register: (coll := self new: size).
	size timesRepeat: [ coll addLast: deserializer odbNextObject ].
	^coll
]
