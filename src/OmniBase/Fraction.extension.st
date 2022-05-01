Extension { #name : #Fraction }

{ #category : #'*omnibase' }
Fraction >> odbBasicSerialize: serializer [
	self class == Fraction ifFalse: [ ^ super odbBasicSerialize: serializer ].
	serializer stream nextPutFraction: self
]

{ #category : #'*omnibase' }
Fraction class >> odbDeserialize: deserializer [

	^ deserializer stream nextFraction: self
]

{ #category : #'*omnibase' }
Fraction >> odbSerialize: serializer [

	self odbBasicSerialize: serializer
]
