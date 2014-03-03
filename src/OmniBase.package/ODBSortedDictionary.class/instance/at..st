public
at: aKey 
	| index |
	(index := self findKey: aKey) > 0 ifTrue: [^values at: index].
	^nil