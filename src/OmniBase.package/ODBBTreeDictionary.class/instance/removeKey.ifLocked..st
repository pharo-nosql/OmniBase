public
removeKey: aKey ifLocked: aBlock 
	| key value |
	key := self bytesFromKey: aKey.
	(self basicLockKey: key) ifFalse: [^aBlock value].
	value := self valueAt: key ifAbsent: [^nil].
	value isRemoved 
		ifFalse: 
			[value removed.
			changed isNil ifTrue: [changed := self newChangedDictionary].
			changed at: key put: value.
			deltaSize := deltaSize - 1]