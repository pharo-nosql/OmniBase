public
at: aKey put: anObject ifLocked: aBlock 
	"Associate aKey with anObject.
	Evaluate aBlock if aKey has been locked before in some other transaction."

	| key |
	key := self bytesFromKey: aKey.
	(self basicLockKey: key) ifFalse: [^aBlock value].
	transaction isNil ifFalse: [transaction makePersistent: anObject in: holder container].
	^self addKey: key value: anObject