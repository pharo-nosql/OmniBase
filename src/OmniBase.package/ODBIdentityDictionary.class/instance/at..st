public
at: anObject 
	"Answer value at anObject, <nil> if absent."

	| index lastIndex key |
	lastIndex := keys size.
	index := anObject identityHash \\ lastIndex.
	[anObject == (key := keys at: (index := index + 1))] whileFalse: 
			[key isNil ifTrue: [^nil].
			index == lastIndex ifTrue: [index := 0]].
	^values at: index