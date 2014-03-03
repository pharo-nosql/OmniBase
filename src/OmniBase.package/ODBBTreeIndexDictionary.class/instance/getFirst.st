public
getFirst
	| assoc |
	self basicGoTo: (ByteArray new: keySize).
	(assoc := self getCurrent) isNil ifTrue: [^self getNext].
	^assoc