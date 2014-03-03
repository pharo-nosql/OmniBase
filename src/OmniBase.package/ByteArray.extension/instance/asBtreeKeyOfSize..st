*omnibase
asBtreeKeyOfSize: keySize

	self size = keySize ifTrue: [^self].
	^(ByteArray new: keySize)
		replaceFrom: 1 to: (self size min: keySize)
		with: self
		startingAt: 1