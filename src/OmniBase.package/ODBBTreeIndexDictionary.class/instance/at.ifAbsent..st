public
at: aKey ifAbsent: aBlock 
	| key value |
	key := self bytesFromKey: aKey.
	value := self valueAt: key ifAbsent: [^aBlock value].
	value isRemoved ifTrue: [^aBlock value].
	^value getObjectIn: transaction