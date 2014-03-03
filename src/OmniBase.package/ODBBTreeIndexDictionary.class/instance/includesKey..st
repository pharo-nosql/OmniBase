public
includesKey: aKey 
	| value |
	value := self valueAt: (self bytesFromKey: aKey) ifAbsent: [^false].
	^value isRemoved not