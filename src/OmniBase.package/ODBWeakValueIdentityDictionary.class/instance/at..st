public
at: anObject
		"Answer value at anObject, <nil> if absent."

	| index lastIndex key value |
	lastIndex := keys size.
	index := anObject identityHash \\ lastIndex.
	[ anObject == (key := keys at: (index := index + 1)) ]
		whileFalse: [
			key == nil ifTrue: [ ^nil ].
			index == lastIndex ifTrue: [ index := 0 ]].
	(value := values at: index) == 0 ifFalse: [ ^value ].
	^nil