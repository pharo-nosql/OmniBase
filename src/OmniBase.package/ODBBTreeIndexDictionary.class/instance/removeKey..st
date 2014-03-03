public
removeKey: aKey 
	| key value |
	key := self bytesFromKey: aKey.
	value := self valueAt: key ifAbsent: [^nil].
	value isRemoved 
		ifFalse: 
			[value removed.
			changed isNil ifTrue: [changed := self newChangedDictionary].
			changed at: key put: value]