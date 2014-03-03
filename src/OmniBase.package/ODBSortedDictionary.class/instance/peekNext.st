public
peekNext
	| i |
	currentIndex < 1 ifTrue: [i := 0 - currentIndex] ifFalse: [i := currentIndex + 1].
	i > elementCount ifTrue: [^nil].
	^ODBBTreeDictionaryAssociation new setKey: (keys at: i) value: (values at: i)