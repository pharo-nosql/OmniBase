Extension { #name : #ByteArray }

{ #category : #'*omnibase' }
ByteArray >> asBtreeKeyOfSize: keySize [

	self size = keySize ifTrue: [^self].
	^(ByteArray new: keySize)
		replaceFrom: 1 to: (self size min: keySize)
		with: self
		startingAt: 1
]

{ #category : #'*omnibase' }
ByteArray >> odbAsInteger [
	| result each negative |
	result := 0.
	1 to: self size
		do: 
			[:i | 
			each := self at: i.
			i = 1 
				ifTrue: 
					[result := each bitAnd: 15.
					each > 31 ifTrue: [negative := true]]
				ifFalse: [result := result * 100 + (each bitAnd: 15) + ((each bitShift: -4) * 10)]].
	negative = true ifTrue: [^0 - result].
	^result
]

{ #category : #'*omnibase' }
ByteArray >> odbIsLessOrEqualTo: aByteArray [

    | i size |
    i := 1. size := self size.
    [(self at: i) = (aByteArray at: i) and: [i < size]] whileTrue: [i := i + 1].
    ^(self at: i) <= (aByteArray at: i)
]

{ #category : #'*omnibase' }
ByteArray >> odbIsLessThan: aByteArray [

    | i size |
    i := 1. size := self size.
    [(self at: i) = (aByteArray at: i) and: [i < size]] whileTrue: [i := i + 1].
    ^(self at: i) < (aByteArray at: i)
]

{ #category : #'*omnibase' }
ByteArray >> odbLongAt: index [

	^(self at: index) +
		((self at: index + 1) bitShift: 8) +
		((self at: index + 2) bitShift: 16) +
		((self at: index + 3) bitShift: 24)
]

{ #category : #'*omnibase' }
ByteArray >> odbLongAt: index put: longValue [

	self
		at: index put: (longValue bitAnd: 16rFF);
		at: index + 1 put: ((longValue bitShift: -8 ) bitAnd: 16rFF);
		at: index + 2 put: ((longValue bitShift: -16 ) bitAnd: 16rFF);
		at: index + 3 put: (longValue bitShift: -24)
]

{ #category : #'*omnibase' }
ByteArray >> odbShortAt: index [

	^(self at: index) + ((self at: index + 1) bitShift: 8)
]

{ #category : #'*omnibase' }
ByteArray >> odbShortAt: index put: longValue [

	self
		at: index put: (longValue bitAnd: 16rFF);
		at: index + 1 put: ((longValue bitShift: -8 ) bitAnd: 16rFF)
]
