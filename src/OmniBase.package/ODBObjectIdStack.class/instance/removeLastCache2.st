private
removeLastCache2

	| cache2 result |
	cache2 := cache at: 2.
	result := cache2 at: bottom - self cacheSize.
	cache2 at: bottom - self cacheSize put: nil.
	bottom := bottom + 1.
	^result