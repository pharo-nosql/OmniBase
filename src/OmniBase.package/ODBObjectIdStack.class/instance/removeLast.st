public
removeLast
	top == bottom ifTrue: [self loadPage].
	bottom > self cacheSize ifTrue: [^self removeLastCache2].
	^self removeLastCache1