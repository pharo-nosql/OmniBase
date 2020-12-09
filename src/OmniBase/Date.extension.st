Extension { #name : #Date }

{ #category : #'*omnibase' }
Date >> asBtreeKeyOfSize: keySize [

	keySize < 3 ifTrue: [OmniBase signalError: 'Key size has to be at least 3 bytes to accomodate a date'].
	^self julianDayNumber asBtreeKeyOfSize: keySize
]

{ #category : #'*omnibase' }
Date >> odbBasicSerialize: serializer [

	serializer stream putByte: 32; putInteger: self julianDayNumber - 2415386
]

{ #category : #'*omnibase' }
Date class >> odbDeserialize: deserializer [

	^deserializer register: (self fromDays: deserializer stream getInteger)
]
