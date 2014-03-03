public
getCurrent
	currentIndex < 1 ifTrue: [^nil].
	^ODBBTreeDictionaryAssociation new setKey: (keys at: currentIndex)
		value: (values at: currentIndex)