public
getLast
	| assoc |
	self basicGoTo: ((ByteArray new: keySize) atAllPut: 255).
	(assoc := self getCurrent) isNil ifTrue: [^self getPrevious].
	^assoc