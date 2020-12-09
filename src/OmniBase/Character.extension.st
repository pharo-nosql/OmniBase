Extension { #name : #Character }

{ #category : #'*omnibase' }
Character >> odbBasicSerialize: serializer [

	self asInteger < 256 ifTrue: [
		serializer stream putByte: 13; putChar: self.
		^self
	].
	serializer stream putByte: 29; putWord: self asInteger
]

{ #category : #'*omnibase' }
Character class >> odbDeserialize: deserializer [

	^deserializer stream getChar
]

{ #category : #'*omnibase' }
Character >> odbSerialize: serializer [

	self asInteger < 256 ifTrue: [
		serializer stream putByte: 13; putChar: self.
		^self
	].
	serializer stream putByte: 29; putWord: self asInteger
]
