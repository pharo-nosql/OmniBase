Extension { #name : #Fraction }

{ #category : #'*omnibase' }
Fraction >> odbBasicSerialize: serializer [

	serializer stream
		putByte: 39;
		putInteger: numerator;
		putInteger: denominator
]

{ #category : #'*omnibase' }
Fraction class >> odbDeserialize: deserializer [

	^self numerator: deserializer stream getInteger
		denominator: deserializer stream getInteger
]

{ #category : #'*omnibase' }
Fraction >> odbSerialize: serializer [

	serializer stream
		putByte: 39;
		putInteger: numerator;
		putInteger: denominator
]
