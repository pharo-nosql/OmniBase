public
keysFrom: key1 to: key2 do: aBlock 
	"Evaluate aBlock for each key in the given key range."

	| toKey assoc |
	toKey := self bytesFromKey: key2.
	self goTo: key1.
	(assoc := self getCurrent) isNil ifTrue: [assoc := self getNext].
	[assoc isNil] whileFalse: 
			[(toKey odbIsLessThan: assoc key) ifTrue: [^self].
			aBlock value: assoc key.
			assoc := self getNext]