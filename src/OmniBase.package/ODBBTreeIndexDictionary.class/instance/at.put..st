public
at: aKey put: anObject 
	"Associate aKey with anObject. Answer anObject."

	| key value |
	key := self bytesFromKey: aKey.
	value := self valueAt: key.
	value object: anObject.
	changed isNil ifTrue: [changed := self newChangedDictionary].
	changed at: key put: value.
	^anObject