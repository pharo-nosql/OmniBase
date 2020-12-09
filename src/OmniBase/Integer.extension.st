Extension { #name : #Integer }

{ #category : #'*omnibase' }
Integer >> asBtreeKeyOfSize: keySize [ 
	"Answer BCD encoded byte array for indexing integers in B-tree."

	| bytes b i n |
	bytes := ByteArray new: keySize.
	n := self abs.
	i := keySize.
	[i = 1] whileFalse: 
			[b := n \\ 10.
			n := n // 10.
			b := n \\ 10 * 16 bitOr: b.
			n := n // 10.
			bytes at: i put: b.
			i := i - 1].
	b := n \\ 10.
	self < 0 ifTrue: [b := b bitOr: 32].
	bytes at: 1 put: b.
	n < 10 
		ifFalse: 
			[self error: 'B-tree dictionary key size is too short to convert receiver into byte array'].
	^bytes
]

{ #category : #'*omnibase' }
Integer >> odbBasicSerialize: serializer [

	self < 0 ifTrue: [
		self > -4 ifTrue: [ ^serializer stream putByte: self + 70 ].
		^serializer stream putByte: 12; putPositiveInteger: 0 - self.
	].
	self < 17 ifTrue: [ ^serializer stream putByte: self + 50 ].
	serializer stream putByte: 11; putPositiveInteger: self
]

{ #category : #'*omnibase' }
Integer >> odbSerialize: serializer [

	self < 0 ifTrue: [
		self > -4 ifTrue: [ ^serializer stream putByte: self + 70 ].
		^serializer stream putByte: 12; putPositiveInteger: 0 - self.
	].
	self < 17 ifTrue: [ ^serializer stream putByte: self + 50 ].
	serializer stream putByte: 11; putPositiveInteger: self
]
