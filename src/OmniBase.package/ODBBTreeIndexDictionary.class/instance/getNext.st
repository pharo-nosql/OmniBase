enumerating
getNext
	| a1 a2 |
	changed isNil 
		ifFalse: 
			[[(a1 := changed peekNext) isNil] whileFalse: 
					[((a2 := self dbPeekNext) notNil and: [a2 < a1]) 
						ifTrue: 
							[changed goTo: (currentKey := a2 key).
							^a2].
					currentKey := a1 key.
					changed goToNext.
					a1 valueHolder isRemoved ifFalse: [^a1]]].
	(a2 := self dbPeekNext) isNil ifTrue: [^nil].
	currentKey := self bytesFromKey: a2 key.
	^a2