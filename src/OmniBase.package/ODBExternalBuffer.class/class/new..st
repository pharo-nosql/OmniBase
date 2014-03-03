instance creation
new: size

	^self basicNew contents: (ByteArray new: size)