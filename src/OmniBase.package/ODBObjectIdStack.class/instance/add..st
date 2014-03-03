public
add: objectID 
	| oid index pos |
	top > self doubleCacheSize ifTrue: [self makeSpace].
	pos := top.
	top := top + 1.
	pos > self cacheSize ifTrue: [^(cache at: 2) at: pos - self cacheSize put: objectID].
	(cache at: 1) at: pos put: objectID