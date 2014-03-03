public
forKeysStartingWith: aStringOrByteArray do: aBlock 
	"Evaluate aOneArgumentBlock for every key that starts with aStringOrByteArray."

	| fromKey toKey assoc |
	fromKey := self bytesFromKey: aStringOrByteArray.
	toKey := fromKey copy.
	aStringOrByteArray size + 1 to: keySize do: [:i | toKey at: i put: 255].
	self basicGoTo: fromKey.
	(assoc := self getCurrent) isNil ifTrue: [assoc := self getNext].
	[assoc isNil] whileFalse: 
			[(toKey odbIsLessThan: assoc key) ifTrue: [^self].
			aBlock value: assoc value.
			assoc := self getNext]