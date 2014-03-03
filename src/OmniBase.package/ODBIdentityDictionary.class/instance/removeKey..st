public
removeKey: aKey 
	"Remove aKey from receiver. Do nothing if absent."

	| index lastIndex key |
	lastIndex := keys size.
	index := aKey identityHash \\ lastIndex.
	[aKey == (key := keys at: (index := index + 1))] whileFalse: 
			[key isNil ifTrue: [^self].
			index == lastIndex ifTrue: [index := 0]].
	keys at: index put: emptySlotMarker.
	^values at: index put: nil