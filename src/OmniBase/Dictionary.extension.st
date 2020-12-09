Extension { #name : #Dictionary }

{ #category : #'*omnibase' }
Dictionary >> odbBasicSerialize: serializer [

	self class == Dictionary ifFalse: [ ^super odbBasicSerialize: serializer ].
	serializer
		stream putByte: 37;
		putPositiveInteger: self size.
	self keysAndValuesDo: [:key :value |
		key odbSerialize: serializer.
		value odbSerialize: serializer.
	].
]

{ #category : #'*omnibase' }
Dictionary class >> odbDeserialize: deserializer [

	| size dict key |
	size := deserializer stream getPositiveInteger.
	dict := self new: size.
	deserializer register: dict.
	size timesRepeat: [
		key := deserializer odbNextObject.
		dict at: key put: deserializer odbNextObject.
	].
	^dict
]
