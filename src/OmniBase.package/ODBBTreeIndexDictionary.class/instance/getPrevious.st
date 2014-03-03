enumerating
getPrevious
	| a1 a2 |
	changed isNil 
		ifFalse: 
			[[(a1 := changed peekPrevious) isNil] whileFalse: 
					[((a2 := self dbPeekPrevious) notNil and: [a1 < a2]) 
						ifTrue: 
							[changed goTo: (currentKey := a2 key).
							^a2].
					currentKey := a1 key.
					changed goToPrevious.
					a1 valueHolder isRemoved ifFalse: [^a1]]].
	(a2 := self dbPeekPrevious) isNil ifTrue: [^nil].
	currentKey := self bytesFromKey: a2 key.
	^a2