private
removeLastCache1

	| cache1 result |
	cache1 := cache at: 1.
	result := cache1 at: bottom.
	cache1 at: bottom put: nil.
	bottom := bottom + 1.
	^result