public
isKeyLocked: aKey 
	"Answer <true> if aKey is locked."

	| key result |
	dataBaseObject isNil ifTrue: [^false].
	transaction isGlobalLocked ifTrue: [^false].
	key := self bytesFromKey: aKey.
	dataBaseObject iterator critical: 
			[result := (locks notNil and: [locks includesKey: key]) or: 
							[(dataBaseObject iterator)
								goTo: key;
								isLocked]].
	^result