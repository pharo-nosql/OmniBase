public
includesKey: anObject 
	| index lastIndex key |
	lastIndex := keys size.
	index := anObject identityHash \\ lastIndex.
	[anObject == (key := keys at: (index := index + 1))] whileFalse: 
			[key isNil ifTrue: [^false].
			index == lastIndex ifTrue: [index := 0]].
	^true