public
removeKey: aKey ifAbsent: aBlock 
	"Remove aKey from receiver. Evaluate aBlock if absent."

	| index lastIndex key |
	lastIndex := keys size.
	index := aKey identityHash \\ lastIndex.
	[aKey == (key := keys at: (index := index + 1))] whileFalse: 
			[key isNil ifTrue: [^aBlock value].
			index == lastIndex ifTrue: [index := 0]].
	keys at: index put: emptySlotMarker.
	^values at: index put: nil