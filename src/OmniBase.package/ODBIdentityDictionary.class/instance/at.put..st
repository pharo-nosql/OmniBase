public
at: aKey put: anObject 
	"Answer anObject. If aKey exists in the receiver,
	replace the corresponding value with anObject, else
	add the aKey/anObject pair to the receiver."

	| index lastIndex key |
	lastIndex := keys size.
	index := aKey identityHash \\ lastIndex.
	[aKey == (key := keys at: (index := index + 1))] whileFalse: 
			[key isNil 
				ifTrue: 
					[keys at: index put: aKey.
					values at: index put: anObject.
					(elementCount := elementCount + 1) < sizeLimit ifFalse: [self grow].
					^anObject].
			key == emptySlotMarker 
				ifTrue: 
					[keys at: index put: aKey.
					^values at: index put: anObject].
			index == lastIndex ifTrue: [index := 0]].
	^values at: index put: anObject