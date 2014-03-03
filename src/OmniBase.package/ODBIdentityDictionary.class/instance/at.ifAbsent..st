public
at: anObject ifAbsent: aBlock 
	| index lastIndex key |
	anObject isNil ifTrue: [^aBlock value].
	lastIndex := keys size.
	index := anObject identityHash \\ lastIndex.
	[anObject == (key := keys at: (index := index + 1))] whileFalse: 
			[key isNil ifTrue: [^aBlock value].
			index == lastIndex ifTrue: [index := 0]].
	^values at: index