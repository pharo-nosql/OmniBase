public
makeSpace
	"Private - Make space on stack."

	| cache1 pos |
	bottom == 1 ifTrue: [^self storePage].
	cache1 := cache at: 1.
	cache
		at: 1 put: (cache at: 2);
		at: 2 put: cache1.
	bottom > self cacheSize 
		ifTrue: 
			[top := top - self cacheSize.
			bottom := bottom - self cacheSize.
			^self].
	pos := bottom - 1.
	bottom := 1.
	top := top - pos.
	1 to: top - 1 - self cacheSize do: [:i | cache1 at: i put: (cache1 at: i + pos)]