public
at: anObject ifAbsent: aBlock

	| index lastIndex key value |
	lastIndex := keys size.
	index := anObject identityHash \\ lastIndex.
	[ anObject == (key := keys at: (index := index + 1)) ]
		whileFalse: [
			key == nil ifTrue: [ ^aBlock value ].
			index == lastIndex ifTrue: [ index := 0 ]].
	(value := values at: index) == 0 ifFalse: [ ^value ].
	^aBlock value