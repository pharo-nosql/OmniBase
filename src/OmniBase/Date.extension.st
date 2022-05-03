Extension { #name : #Date }

{ #category : #'*omnibase' }
Date >> asBtreeKeyOfSize: keySize [

	keySize < 3 ifTrue: [OmniBase signalError: 'Key size has to be at least 3 bytes to accomodate a date'].
	^self julianDayNumber asBtreeKeyOfSize: keySize
]

{ #category : #'*omnibase' }
Date >> odbBasicSerialize: serializer [
	self class == Date ifFalse: [ ^ super odbBasicSerialize: serializer ].
	serializer stream nextPutDate: self
]

{ #category : #'*OmniBase' }
Date class >> odbDateFromSeconds: seconds offset: offset [
	^ self 
		julianDayNumber: SqueakEpoch + seconds 
		offset: ( Duration hours: offset)
]

{ #category : #'*omnibase' }
Date class >> odbDeserialize: deserializer [

	^ deserializer stream nextDate: self
]
