public
peekPrevious
	| i |
	i := currentIndex abs - 1.
	i < 1 ifTrue: [^nil].
	^ODBBTreeDictionaryAssociation new setKey: (keys at: i) value: (values at: i)